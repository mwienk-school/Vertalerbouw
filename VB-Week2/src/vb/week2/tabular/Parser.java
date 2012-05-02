package vb.week2.tabular;

import java.io.FileInputStream;

public class Parser {
	protected Token currentToken;
	protected Scanner scanner;
	
	protected void accept(Token.Kind expected) throws SyntaxError {
		if(currentToken.getKind().equals(expected)) {
			currentToken = scanner.scan();
			System.out.println("Accepted" + currentToken.getKind());
		} else {
			throw new SyntaxError("Error: expected " + expected + " but received " + currentToken.getKind());
		}
	}
	
	protected void acceptIt() throws SyntaxError {
		currentToken = scanner.scan();
	}
	
	protected void parseLatexTabular() throws SyntaxError {
		System.out.println("A");
		parseBeginTabular();
		parseColsSpec();
		parseRows();
		parseEndTabular();
	}
	
	protected void parseColsSpec() throws SyntaxError {
		System.out.println("A");
		accept(Token.Kind.LCURLY);
		parseIdentifier();
		accept(Token.Kind.RCURLY);
	}
	
	protected void parseRows() {
		try {
			while(true)	parseRow(); 
		} catch (Exception e) {}
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
	
	protected void parseEntry() {}
	protected void parseBeginTabular() {}
	protected void parseEndTabular() {}
	protected void parseNum() {}
	protected void parseIdentifier() {}
	
	public Parser(Scanner scanner) {
		this.scanner = scanner;
	}
    
    public static void main(String[] args) {
    	for (int i = 0; i < args.length; i++) {
			String fname = args[i];
			try {
				Scanner scanner = new Scanner(new FileInputStream(fname));
				Parser parser = new Parser(scanner);
				System.out.println(fname);
				parser.parseLatexTabular();
			}
			catch(Exception e) {
				System.out.println(e.getMessage());
			}
    	}
    }
}
