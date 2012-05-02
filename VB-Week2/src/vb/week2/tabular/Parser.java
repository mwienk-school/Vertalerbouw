package vb.week2.tabular;

public class Parser {

	protected Token currentToken;
	protected Scanner scanner;
	
	protected void accept(Token.Kind expected) throws SyntaxError {
		if(currentToken.getKind().equals(expected)) {
			currentToken = scanner.scan();
		} else {
			throw new SyntaxError("Error: expected " + expected + " but received " + currentToken.getKind());
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
	}
	
	protected void parseRows() {
		try {
			parseRow(); 
		} catch (Exception e) {
			
		}
	}
	
	protected void parseRow() throws SyntaxError {
		parseEntries();
		accept(Token.Kind.DOUBLE_BSLASH);
	}
	
	protected void parseEntries() throws SyntaxError {
		parseEntry();
		while(currentToken.getKind().equals(Token.Kind.AMPERSAND)) {
			acceptIt();
			parseEntry();
		}
		accept(Token.Kind.DOUBLE_BSLASH);
	}
	
	protected void parseEntry() throws SyntaxError {
		switch(currentToken.getKind()) {
		case NUM:
			parseNum();
			break;
		case IDENTIFIER:
			parseIdentifier();
			break;
		}
	}
	protected void parseBeginTabular() throws SyntaxError {
		//BSLASH BEGIN LCURLY TABULAR RCURLY
		accept(Token.Kind.BSLASH);
		accept(Token.Kind.BEGIN);
		accept(Token.Kind.LCURLY);
		accept(Token.Kind.TABULAR);
		accept(Token.Kind.RCURLY);
	}
	protected void parseEndTabular() throws SyntaxError {
		//BSLASH END LCURLY TABULAR RCURLY
		accept(Token.Kind.BSLASH);
		accept(Token.Kind.END);
		accept(Token.Kind.LCURLY);
		accept(Token.Kind.TABULAR);
		accept(Token.Kind.RCURLY);
	}
	protected void parseNum() throws SyntaxError {
		//digit (digit)*
		accept(Token.Kind.NUM);
		try {
			while (true)
				accept(Token.Kind.NUM);
		}
		catch(SyntaxError e) {}
	}
	protected void parseIdentifier() {
		//letter (letter | digit)*
	}
}

