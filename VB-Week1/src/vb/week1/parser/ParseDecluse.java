package vb.week1.parser;

import java.io.*;

import vb.week1.symtab.*;

public class ParseDecluse {
	protected static final String LOWERCASE_ALPHABET = "abcdefghijklmnopqrstuvwxyz";
	protected int level = -1;
	protected Reader reader = null;
	protected SymbolTable<IdEntry> symtab = new SymbolTable<IdEntry>();
	protected String currentOp = "";
	protected StringBuffer currentNode = new StringBuffer();

	public void setReader(Reader r) {
		reader = r;
	}

	public void parse() throws Exception {
		char ch;
		int readch;
		char expectedch = '(';
		while((readch = reader.read()) != -1) {
			ch = (char) readch;
			if (!Character.isWhitespace(ch)) {
				switch(expectedch) {
				case 'b':
					if(LOWERCASE_ALPHABET.contains(""+ch)){
						currentNode.append(ch);
						break;
					} else {
						//Identity boundary found
						//Create IdEntry
						IdEntry entry = new IdEntry();
						entry.setLevel(level);
						if(currentOp.equals("decl")) {
							//Store IdEntry in SymbolTable on declare
							try {
								symtab.enter(currentNode.toString(), entry);
								System.out.println("D:" + currentNode + 
										" on level " + 
										symtab.retrieve(currentNode.toString()).getLevel());
							} catch (Exception e) {
								System.out.println(currentNode + "' already declared on the current level");
							}
						} else if(currentOp.equals("use")) {
							//Retrieve IdEntry from SymbolTable on use
							IdEntry use = symtab.retrieve(currentNode.toString());
							System.out.print("U:" + currentNode + " on level " + level + ", ");
							if(use != null) {
								System.out.println("declared on level " + use.getLevel());
							} else {
								System.out.println("*undeclared*");
							}
						}
						//Reset the CurrentNode buffer
						currentNode.delete(0, currentNode.length());
					}
				case ' ':
					switch(ch) {
					case '(':
						level++;
						expectedch = ' ';
						symtab.openScope();
						break;
					case ')':
						level--;
						if(level < -1)
							throw new Exception("Unexpected closing bracket.");
						expectedch = ' ';
						symtab.closeScope();
						break;
					case 'U':
						expectedch = ':';
						currentOp = "use";
						break;
					case 'D':
						expectedch = ':';
						currentOp = "decl";
						break;
					default:
						throw new Exception("Unexpected character '" + ch + "'.");
					}
					break;
				case 'a':
					if(LOWERCASE_ALPHABET.contains(""+ch)) {
						expectedch = 'b';
						currentNode.append(ch);
					} else 
						throw new Exception("Unexpected character '" + ch + "', expected a lowercase letter.");
					break;
				case ':':
					if(ch == expectedch)
						expectedch = 'a';
					else
						throw new Exception("Unexpected character '" + ch + "', expected a ':'.");
					break;
				case '(':
					if(ch == expectedch) {
						level++;
						expectedch = ' ';
						symtab.openScope();
					}
					else
						throw new Exception("Unexpected character '" + ch + "', expected a '('.");
					break;
				}
			}
		}
		if(level != -1)
			throw new Exception(level + " more closing brackets expected.");
		System.out.println(currentNode);
	}
	
	public static void parseArgs(String[] args, ParseDecluse pd) {
		for (int i = 0; i < args.length; i++) {
			String fname = args[i];
			File f = new File(fname);
			try {
				pd.setReader(new BufferedReader(new FileReader(f)));
				try {
					pd.parse();
				} catch (Exception e) {
					System.out.println("Parsing error! " + e.getMessage());
				}
			} catch (FileNotFoundException e) {
				System.err.println("error opening: " + e.getMessage());
			}
		}
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		parseArgs(args, new ParseDecluse());
	}

}
