package vb.eindopdracht.test;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.EnumSet;
import java.util.Set;

import org.antlr.runtime.*;
import org.antlr.runtime.tree.*;

import vb.eindopdracht.CrimsonCodeChecker;
import vb.eindopdracht.CrimsonCodeGenerator;
import vb.eindopdracht.CrimsonCodeGrammarLexer;
import vb.eindopdracht.CrimsonCodeGrammarParser;

public class ASTtest {
	private static final String OPTION_PREFIX = "-";
	private static final String USAGE_MESSAGE;
	
	private static final Set<Option> options = EnumSet.noneOf(Option.class);
	private static String inputFile;
	
	/**
	 * Parse the main's options arguments
	 * @param args
	 */
	public static void parseOptions(String[] args) {
		if (args.length == 0) {
			System.err.println(USAGE_MESSAGE);
			System.exit(1);
		}
		for (int i = 0; i < args.length; i++) {
			try {
				Option option = getOption(args[i]);
				if (option == null) {
					if (i < args.length - 1) {
						System.err
								.println("Input file name '%s' should be last argument");
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
            InputStream in = inputFile == null ? new FileInputStream("src/vb/eindopdracht/test/test3.txt") : new FileInputStream(inputFile);
            CrimsonCodeGrammarLexer lexer = new CrimsonCodeGrammarLexer(new ANTLRInputStream(in));
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            CrimsonCodeGrammarParser parser = new CrimsonCodeGrammarParser(tokens);
            
            RuleReturnScope result = parser.program();
            CommonTree tree = (CommonTree) result.getTree();

		
			if (!options.contains(Option.NO_CHECKER)) { // check the AST
				CommonTreeNodeStream nodes = new CommonTreeNodeStream(tree);
				CrimsonCodeChecker checker = new CrimsonCodeChecker(nodes);
				checker.program();
			}

			if (!options.contains(Option.NO_CODE_GENERATOR)) {
				TreeNodeStream nodes = new BufferedTreeNodeStream(tree);
				CrimsonCodeGenerator generator = new CrimsonCodeGenerator(nodes);
				generator.program();
			}

			if (options.contains(Option.AST)) { // print the AST
				System.out.println("\nWalk tree:\n");
				printTree(tree, 0);
			}

			System.out.println(tokens.toString());

		} catch (RecognitionException e) {
			System.err
					.print("ERROR: Recognition exception thrown by compiler: ");
			System.err.println(e.getMessage());
			e.printStackTrace();
		} catch (Exception e) {
			System.err.print("ERROR: uncaught exception thrown by compiler: ");
			System.err.println(e.getMessage());
			e.printStackTrace();
		}

	}

	/**
	 * Print the tree in a well formatted form
	 * @param t
	 * @param indent
	 */
	public static void printTree(CommonTree t, int indent) {
		if (t != null) {
			StringBuffer sb = new StringBuffer(indent);
			for (int i = 1; i <= indent; i++)
				if (i == indent)
					sb = sb.append("|--");
				else
					sb = sb.append("|  ");
			for (int i = 0; i < t.getChildCount(); i++) {
				System.out.println(sb.toString() + t.getChild(i).toString());
				printTree((CommonTree) t.getChild(i), indent + 1);
			}
		}
	}
	
	static {
		StringBuilder message = new StringBuilder("Usage:");
		for (Option option : Option.values()) {
			message.append(" [");
			message.append(OPTION_PREFIX);
			message.append(option.getText());
			message.append("]");
		}
		message.append(" [filename]");
		USAGE_MESSAGE = message.toString();
	}

	private static enum Option {
		//DOT, 
		AST, NO_CHECKER, NO_INTERPRETER, NO_CODE_GENERATOR;

		private Option() {
			this.text = name().toLowerCase();
		}

		/** Returns the option text of this option. */
		public String getText() {
			return text;
		}

		private final String text;
	}
	
	/**
	 * Get an option from the arguments
	 * @param text
	 * @return
	 * @throws IllegalArgumentException
	 */
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
}
