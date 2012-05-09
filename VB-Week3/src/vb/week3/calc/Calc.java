// [file: Calc.java, started: 5-Apr-2003]
//
// Driver for Calc compiler.
//
// CHANGES
//      2003.04.05  ruys  Started (VB 2003).
//      2004.04.12  ruys  Modifications for VB 2004.
//                         -  AST is not longer re-built by Treeparsers.
//                         -  CalcChecker can now throw a CalcException.
//      2008.04.22  ruys  Migrated to ANTLR 3.
package vb.week3.calc;
import org.antlr.runtime.*;             // ANTLR runtime library
import org.antlr.runtime.tree.*;        // For ANTLR's Tree classes
import org.antlr.stringtemplate.*;      // For the DOTTreeGenerator

/** 
 * Program that creates and starts the Calc lexer, parser, etc.
 * @author  Theo Ruys
 * @version 2008.04.22
 */
public class Calc {
    private static boolean  opt_ast             = false,
                            opt_dot             = false,
                            opt_no_checker      = false,
                            opt_no_interpreter  = false;
    
    public static void parseOptions(String[] args) {
        for (int i=0; i<args.length; i++) {
            if (args[i].equals("-ast"))
                opt_ast = true;
            else if (args[i].equals("-dot"))
                opt_dot = true;
            else if (args[i].equals("-no_checker"))
                opt_no_checker = true;
            else if (args[i].equals("-no_interpreter"))
                opt_no_interpreter = true;
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
            CalcLexer lexer = new CalcLexer(new ANTLRInputStream(System.in));
            TokenStream tokens = new CommonTokenStream(lexer);
            CalcParser parser = new CalcParser(tokens);
            
            CalcParser.program_return result = parser.program();
            CommonTree tree = (CommonTree) result.getTree();
            
            if (! opt_no_checker) {      // check the AST
                TreeNodeStream nodes = new CommonTreeNodeStream(tree);
                CalcChecker checker = new CalcChecker(nodes);
                checker.program();
            }

            if (! opt_no_interpreter) {  // interpret the AST
                TreeNodeStream nodes = new BufferedTreeNodeStream(tree);
                CalcInterpreter interpreter = new CalcInterpreter(nodes);
                interpreter.program();
            }

            if (opt_ast) {          // print the AST as string
                System.out.println(tree.toStringTree());
            } else if (opt_dot) {   // print the AST as DOT specification
                DOTTreeGenerator gen = new DOTTreeGenerator(); 
                StringTemplate st = gen.toDOT(tree); 
                System.out.println(st);
            }
            
        } catch (CalcException e) { 
            System.err.print("ERROR: CalcException thrown by compiler: ");
            System.err.println(e.getMessage());
        } catch (RecognitionException e) {
            System.err.print("ERROR: recognition exception thrown by compiler: ");
            System.err.println(e.getMessage());
            e.printStackTrace();
        } catch (Exception e) { 
            System.err.print("ERROR: uncaught exception thrown by compiler: ");
            System.err.println(e.getMessage());
            e.printStackTrace();
        }
    }
}
