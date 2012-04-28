package vb.week1.parser;

import java.io.*;

public class ParseDecluse {
	protected static final String LOWERCASE_ALPHABET = "abcdefghijklmnopqrstuvwxyz";
	protected int level = 0;
	protected Reader reader = null;

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
						break;
					}
				case ' ':
					switch(ch) {
					case '(':
						level++;
						expectedch = ' ';
						break;
					case ')':
						level--;
						if(level < 0)
							throw new Exception("Unexpected closing bracket.");
						expectedch = ' ';
						break;
					case 'U':
					case 'D':
						expectedch = ':';
						break;
					default:
						throw new Exception("Unexpected character '" + ch + "'.");
					}
					break;
				case 'a':
					if(LOWERCASE_ALPHABET.contains(""+ch))
						expectedch = 'b';
					else 
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
					}
					else
						throw new Exception("Unexpected character '" + ch + "', expected a '('.");
					break;
				}
			}
		}
		if(level != 0)
			throw new Exception(level + " more closing brackets expected.");
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
				System.out.println(pd + " " + fname);
			} catch (FileNotFoundException e) {
				System.err.println("error opening: " + e.getMessage());
			} catch (IOException e) {
				System.err.println("error reading file: " + fname);
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
