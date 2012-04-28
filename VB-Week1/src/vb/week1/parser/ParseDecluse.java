package vb.week1.parser;

import java.io.*;

public class ParseDecluse {
	protected int level = 0;
	protected Reader reader = null;

	public void setReader(Reader r) {
		reader = r;
	}

	public boolean parse() throws Exception {
		char ch;
		int readch;
		boolean success = true;
		char expectedch = '(';
		while ((readch = reader.read()) != -1) {
			ch = (char) readch;
			if (!Character.isWhitespace(ch)) {
				switch (expectedch) {
				case 'b':
					if (Character.isLowerCase(ch)) {
						break;
					}
				case ' ':
					switch (ch) {
					case '(':
						level++;
						expectedch = ' ';
						break;
					case ')':
						level--;
						if (level < 0)
							throw new Exception();
						expectedch = ' ';
						break;
					case 'U':
					case 'D':
						expectedch = ':';
						break;
					default:
						throw new Exception();
					}
					break;
				case 'a':
					if (Character.isLowerCase(ch))
						expectedch = 'b';
					else
						throw new Exception();
					break;
				case ':':
					if (ch != expectedch)
						throw new Exception();
					else
						expectedch = 'a';
					break;
				case '(':
					if (ch != expectedch)
						throw new Exception();
					else {
						level++;
						expectedch = ' ';
					}
					break;
				}
			}
		}
		if(level != 0) throw new Exception();
		return success;
	}

	public static void parseArgs(String[] args, ParseDecluse pd) {
		for (int i = 0; i < args.length; i++) {
			String fname = args[i];
			File f = new File(fname);
			try {
				pd.setReader(new BufferedReader(new FileReader(f)));
				try {
					if(pd.parse()) {
						System.out.println("Succes.");
					}
				} catch (Exception e) {
					System.out.println("Parsing error! Incorrect nesting or incorrect prefix.");
				}
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