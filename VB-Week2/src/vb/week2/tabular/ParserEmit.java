package vb.week2.tabular;

import java.io.FileInputStream;
import java.io.FileNotFoundException;

public class ParserEmit extends Parser {
	
	protected void parseRow() throws SyntaxError {
		System.out.println("<tr>");
		super.parseRow();
		System.out.println("</tr>");
	}
	
	protected void parseEntry() throws SyntaxError {
		switch (currentToken.getKind()) {
		case NUM:
			System.out.println("  <td>" + currentToken.getRepr() + "</td>");
			parseNum();
			break;
		case IDENTIFIER:
			System.out.println("  <td>" + currentToken.getRepr() + "</td>");
			parseIdentifier();
			break;
		case AMPERSAND:
			System.out.println("  <td></td>");
			break;
		}
	}
	
	protected void parseBeginTabular() throws SyntaxError {
		super.parseBeginTabular();
		System.out.println("<table border=\"1\">");
	}

	protected void parseEndTabular() throws SyntaxError {
		super.parseEndTabular();
		System.out.println("</table>");
	}

	public ParserEmit(Scanner scanner) {
		super(scanner);
	}
	
	public static void main(String[] args) {
		for (int i = 0; i < args.length; i++) {
			String fname = args[i];
			Scanner scanner;
			try {
				scanner = new Scanner(new FileInputStream(fname));
				ParserEmit parser = new ParserEmit(scanner);
				System.out.println(fname);
				System.out.println("<html><body>");
				parser.parse();
				System.out.println("</body></html>");
			} catch (FileNotFoundException e) {
				System.out.println(e.getMessage());
			}
		}
	}

}
