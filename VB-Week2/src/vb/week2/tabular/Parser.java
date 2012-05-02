package vb.week2.tabular;

import java.io.FileInputStream;

public class Parser {

	protected Token currentToken;
	protected Scanner scanner;

	protected void accept(Token.Kind expected) throws SyntaxError {
		if (currentToken.getKind() == expected) {
			System.out.println("TOKENCHECK: " + currentToken.getKind());
			currentToken = scanner.scan();
		} else {
			throw new SyntaxError("Error: expected " + expected
					+ " but received " + currentToken.getKind());
		}
	}

	protected void acceptIt() throws SyntaxError {
		currentToken = scanner.scan();
	}

	protected void parseLatexTabular() throws SyntaxError {
		parseBeginTabular();
		parseColsSpec();
		parseRows();
		parseEndTabular();
	}

	protected void parseColsSpec() throws SyntaxError {
		accept(Token.Kind.LCURLY);
		parseIdentifier();
		accept(Token.Kind.RCURLY);
		System.out.println("Accepted: ColsSpec");
	}

	protected void parseRows() {
		try {
			//TODO - lookahead gebruiken (hoewel dit wel werkt als de file klopt)
			while(true) parseRow();
		} catch (Exception e) {
		}
	}

	protected void parseRow() throws SyntaxError {
		parseEntries();
		accept(Token.Kind.DOUBLE_BSLASH);
		System.out.println("Accepted: Row");
	}

	protected void parseEntries() throws SyntaxError {
		parseEntry();
		while (currentToken.getKind().equals(Token.Kind.AMPERSAND)) {
			acceptIt();
			parseEntry();
		}
		System.out.println("Accepted: Entries");
	}

	protected void parseEntry() throws SyntaxError {
		switch (currentToken.getKind()) {
		case NUM:
			parseNum();
			break;
		case IDENTIFIER:
			parseIdentifier();
			break;
		}
		System.out.println("Accepted: Entry");
	}

	protected void parseBeginTabular() throws SyntaxError {
		// BSLASH BEGIN LCURLY TABULAR RCURLY
		accept(Token.Kind.BSLASH);
		accept(Token.Kind.BEGIN);
		accept(Token.Kind.LCURLY);
		accept(Token.Kind.TABULAR);
		accept(Token.Kind.RCURLY);
		System.out.println("Accepted: BeginTabular");
	}

	protected void parseEndTabular() throws SyntaxError {
		// BSLASH END LCURLY TABULAR RCURLY
		accept(Token.Kind.BSLASH);
		accept(Token.Kind.END);
		accept(Token.Kind.LCURLY);
		accept(Token.Kind.TABULAR);
		accept(Token.Kind.RCURLY);
		System.out.println("Accepted: EndTabular");
	}

	protected void parseNum() throws SyntaxError {
		// digit (digit)*
		accept(Token.Kind.NUM);
		try {
			while (true)
				accept(Token.Kind.NUM);
		} catch (SyntaxError e) {
		}
		System.out.println("Accepted: Num");

	}

	protected void parseIdentifier() throws SyntaxError {
		accept(Token.Kind.IDENTIFIER);
		System.out.println("Accepted: Identifier");
	}

	public Parser(Scanner scanner) throws SyntaxError {
		this.scanner = scanner;
		currentToken = scanner.scan();
	}

	public static void main(String[] args) {
		for (int i = 0; i < args.length; i++) {
			String fname = args[i];
			try {
				Scanner scanner = new Scanner(new FileInputStream(fname));
				Parser parser = new Parser(scanner);
				System.out.println(fname);
				parser.parseLatexTabular();
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
	}
}
