// [file: CalcST.java, started: 5-Apr-2003]
//
// Driver for Calc compiler + Code Generator.
//
// CHANGES
//      2003.04.05  ruys  Started (VB 2003).
//      2004.04.12  ruys  Modifications for VB 2004.
//                         -  AST is not longer re-built by Treeparsers.
//                         -  CalcChecker can now throw a CalcException.
//      2008.04.22  ruys  Migrated to ANTLR 3.
//      2009.05.01  ruys  Added CodeGenerator.
package vb.week4.calc;
import java.io.*;
import java.util.EnumSet;
import java.util.Set;

import org.antlr.runtime.*;             // ANTLR runtime library
import org.antlr.runtime.tree.*;        // For ANTLR's Tree classes
import org.antlr.stringtemplate.*;      // For the DOTTreeGenerator

/** 
 * Program that creates and starts the Calc lexer, parser, etc.
 * @author  Theo Ruys
 * @version 2009.05.01
 */
public class Calc {
    private static final Set<Option> options = EnumSet.noneOf(Option.class);
    private static String inputFile;
    
    public static void parseOptions(String[] args) {
        if (args.length == 0) {
            System.err.println(USAGE_MESSAGE);
            System.exit(1);
        }
        for (int i=0; i<args.length; i++) {
            try {
                Option option = getOption(args[i]);
                if (option == null) {
                    if (i < args.length - 1) {
                        System.err.println("Input file name '%s' should be last argument");
                        System.exit(1);
                    } else {
                        inputFile = args[i];
                    }
                } else {
                options.add(option);
                }
            } catch (IllegalArgumentException exc) {
                System.err.println(exc.getMessage());
                System.err.println(USAGE_MESSAGE);
                System.exit(1);
            }
        }
    }
        
    public static void main(String[] args) {
        parseOptions(args);
        
        try {
            InputStream in = inputFile == null ? System.in : new FileInputStream(inputFile);
            CalcLexer lexer = new CalcLexer(new ANTLRInputStream(in));
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            CalcParser parser = new CalcParser(tokens);
            
            CalcParser.program_return result = parser.program();
            CommonTree tree = (CommonTree) result.getTree();
            
            if (!options.contains(Option.NO_CHECKER)) {      // check the AST
                CommonTreeNodeStream nodes = new CommonTreeNodeStream(tree);
                CalcChecker checker = new CalcChecker(nodes);
                checker.program();
            }

            if (!options.contains(Option.NO_INTERPRETER) &&
                    !options.contains(Option.CODE_GENERATOR)) {  // interpret the AST
                TreeNodeStream nodes = new BufferedTreeNodeStream(tree);
                CalcInterpreter interpreter = new CalcInterpreter(nodes);
                interpreter.program();
            }

            if (options.contains(Option.CODE_GENERATOR)) {
                TreeNodeStream nodes = new BufferedTreeNodeStream(tree);
                CalcCodeGenerator generator = new CalcCodeGenerator(nodes);
                generator.program();
            }

            if (options.contains(Option.AST)) {          // print the AST as string
                System.out.println(tree.toStringTree());
            } 
            
            if (options.contains(Option.DOT)) {   // print the AST as DOT specification
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
    
    private static Option getOption(String text) throws IllegalArgumentException {
        if (!text.startsWith(OPTION_PREFIX)) {
            return null;
        }
        String stripped = text.substring(OPTION_PREFIX.length());
        for (Option option: Option.values()) {
            if (option.getText().equals(stripped)) {
                return option;
            }
        }
        throw new IllegalArgumentException(String.format("Illegal option value '%s'", text));
    }
    
    private static final String USAGE_MESSAGE;
    
    static {
        StringBuilder message = new StringBuilder("Usage:");
        for (Option option: Option.values()) {
            message.append(" [");
            message.append(option.getText());
            message.append("]");
        }
        message.append(" [filename]");
        USAGE_MESSAGE = message.toString();
    }

    private static enum Option {
        DOT,
        AST,
        NO_CHECKER,
        NO_INTERPRETER,
        CODE_GENERATOR;
        
        private Option() {
            this.text = name().toLowerCase();
        }
        
        /** Returns the option text of this option. */
        public String getText() {
            return text;
        }
        
        private final String text;
    }
    
    private static final String OPTION_PREFIX = "-";
}