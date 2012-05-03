package vb.week1.wc;

import java.io.IOException;
import java.util.Scanner;

public class WordCountScanner extends WordCount {
	/**
	 * Counts the number of characters, words and lines in this WordCount's
	 * reader.
	 */
	public void count() throws IOException {
		nChars = nWords = nLines = 0;
		Scanner in = new Scanner(reader);

		while(in.hasNextLine()) {
			//Aantal lines
			String line = in.nextLine();
			nLines++;
			
			//Aantal woorden
			Scanner words = new Scanner(line);
			while(words.hasNext()) {
				nWords++;
				words.next();
			}
			
			//Aantal karakters (+1 voor \n)
			nChars += line.length()+1;
		}

	}
	
	public static void main(String[] args) {
		wcArgs(args, new WordCountScanner());
	}
}
