package vb.week1.wc;

import java.io.*;

/**
 * VB prac week1. WordCount in Java.
 * 
 * @author Theo Ruys
 * @version 2006.04.21
 */
public class WordCount {
	protected Reader reader = null;
	protected int nChars = 0;
	protected int nWords = 0;
	protected int nLines = 0;

	public void setReader(Reader r) {
		reader = r;
	}

	/**
	 * Counts the number of characters, words and lines in this WordCount's
	 * reader.
	 */
	public void count() throws IOException {
		nChars = nWords = nLines = 0;
		BufferedReader in = new BufferedReader(reader);

		int ch;
		boolean inWhiteSpace = true;
		while ((ch = in.read()) != -1) {
			nChars++;
			if (Character.isWhitespace((char) ch)) {
				inWhiteSpace = true;
				if (ch == '\n')
					nLines++;
			} else if (inWhiteSpace) { // previous char was whitespace
				nWords++;
				inWhiteSpace = false;
			}
		}
	}

	public int getChars() {
		return nChars;
	}

	public int getWords() {
		return nWords;
	}

	public int getLines() {
		return nLines;
	}

	private static String right(String s, int width) {
		return right(s, width, ' ');
	}

	public static String right(String s, int width, char fillChar) {
		if (s.length() >= width)
			return s;
		StringBuffer sb = new StringBuffer(width);
		for (int i = width - s.length(); --i >= 0;)
			sb.append(fillChar);
		sb.append(s);
		return sb.toString();
	}

	public String toString() {
		return right(Integer.toString(nLines), 8)
				+ right(Integer.toString(nWords), 8)
				+ right(Integer.toString(nChars), 8);
	}

	public static void wcArgs(String[] args, WordCount wc) {
		for (int i = 0; i < args.length; i++) {
			String fname = args[i];
			File f = new File(fname);
			try {
				wc.setReader(new FileReader(f));
				wc.count();
				System.out.println(wc + " " + fname);
			} catch (FileNotFoundException e) {
				System.err.println("error opening: " + e.getMessage());
			} catch (IOException e) {
				System.err.println("error reading file: " + fname);
			}
		}
	}

	public static void main(String[] args) {
		wcArgs(args, new WordCount());
	}
}