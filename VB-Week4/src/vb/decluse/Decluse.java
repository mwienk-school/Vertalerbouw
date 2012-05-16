package vb.decluse;
import java.io.FileInputStream;

import org.antlr.runtime.*;             // ANTLR runtime library
import org.antlr.runtime.tree.*;        // For ANTLR's Tree classes
import org.antlr.stringtemplate.*;      // For the DOTTreeGenerator

public class Decluse {
    private static boolean  opt_ast             = false,
                               opt_dot             = false,
                               opt_no_interpreter  = false;
    private static String file = null;
    
    public static void parseOptions(String[] args) {
        for (int i=0; i<args.length; i++) {
            if (args[i].equals("-ast"))
                opt_ast = true;
            else if (args[i].equals("-dot"))
                opt_dot = true;
            else if (args[i].equals("-no_interpreter"))
                opt_no_interpreter = true;
            else if (args[i].equals("-file")) {
            	file = args[i+1];
            	i++;
            }
            else {
                System.err.println("error: unknown option '" + args[i] + "'");
                System.err.println("valid options: -ast -dot " +
                                   "-no_checker -no_interpreter");
                System.exit(1);
            }
        }
    }
        
    public static void main(String[] args) {
        parseOptions(args);
        
        try {
            DecluseGrammarLexer lexer = new DecluseGrammarLexer(new ANTLRInputStream(new FileInputStream(file)));
            TokenStream tokens = new CommonTokenStream(lexer);
            DecluseGrammarParser parser = new DecluseGrammarParser(tokens);
            
            DecluseGrammarParser.decluse_return result = parser.decluse();
            CommonTree tree = (CommonTree) result.getTree();
            

            if (! opt_no_interpreter) {  // interpret the AST
                TreeNodeStream nodes = new BufferedTreeNodeStream(tree);
                DecluseTreeParser interpreter = new DecluseTreeParser(nodes);
                interpreter.decluse();
            }

            if (opt_ast) {          // print the AST as string
                System.out.println(tree.toStringTree());
            } else if (opt_dot) {   // print the AST as DOT specification
                DOTTreeGenerator gen = new DOTTreeGenerator(); 
                StringTemplate st = gen.toDOT(tree); 
                System.out.println(st);
            }
            
        } catch (RecognitionException e) {
            System.err.print("ERROR: Recognition exception thrown by compiler: ");
            System.err.println(e.getMessage());
            e.printStackTrace();
        } catch (Exception e) { 
            System.err.print("ERROR: uncaught exception thrown by compiler: ");
            System.err.println(e.getMessage());
            e.printStackTrace();
        }
    }
}
