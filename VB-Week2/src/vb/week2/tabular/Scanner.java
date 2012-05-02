package vb.week2.tabular;
import java.io.IOException;
import java.io.InputStream;
import java.io.FileInputStream;

public class Scanner {
    private int             currentLineNr = 0;
    private InputStream     in;
	private StringBuffer buffer = new StringBuffer();
	private char current;


    private static final char cSPACE    = ' ',
                              cTAB      = '\t',
                              cEOLr     = '\r',
                              cEOLn     = '\n',
                              cPERCENT  = '%',
                              cEOT      = '\u0000',         /* End OF Text */
    						  cBSLASH   = '\u005C\u005C';
    // == '\\'  
    // We cannot use the '\\' denotation here because 
    // otherwise LaTeX's listings package will get very 
    // confused. Students should use '\\' of course.

   /** 
    * Constructor. 
    * @param in the stream from which the characters will be read
    */
    public Scanner(InputStream in) {
        this.in = in;
    }                              
    
    /* Returns the next character. 
     * Returns cEOT when end-of-file or in case of an error. */
    private char getNextChar() {
        try {
            int ch = in.read();
            
            if (ch == -1) {
                ch = cEOT;
            } else if (ch == cEOLn) {
                currentLineNr++;
            }
            
            return (char)ch;
        } catch (IOException e) {
            return cEOT;
        }
    }

   /** 
    * Returns the next Token from the input.
    * @return the next Token 
    * @throws SyntaxError when an unknown or unexpected character 
    *         has been found in the input. 
    */
    public Token scan() throws SyntaxError {
    	Token result = null;
    	current = this.getNextChar();
    	while(result == null && current != cEOT) {
    		switch (current) {
    		case cSPACE: case cEOLn: case cTAB: case cEOLr:
    			current = this.getNextChar();
    			break;
    		case cPERCENT:
    			while(current != cEOLn) {
    				current = this.getNextChar();
    			}
    			break;
    		case '{':
    			result = new Token(Token.Kind.LCURLY, String.valueOf(current));
    			current = this.getNextChar();
    			break;
    		case '}':
    			result = new Token(Token.Kind.RCURLY, String.valueOf(current));
    			current = this.getNextChar();
    			break;
    		case '&':
    			result = new Token(Token.Kind.AMPERSAND, String.valueOf(current));
    			current = this.getNextChar();
    			break;
    		case cBSLASH:
    			current = this.getNextChar();
    			if(current == cBSLASH) {
    				result = new Token(Token.Kind.DOUBLE_BSLASH, cBSLASH + String.valueOf(current));
    				current = this.getNextChar();
    			} else {
    				result = new Token(Token.Kind.BSLASH, String.valueOf(cBSLASH));
    			}
    			break;
    	    case 'a': case 'b': case 'c': case 'd': case 'e': case 'f': case 'g':
    	    case 'h': case 'i': case 'j': case 'k': case 'l': case 'm': case 'n':
    	    case 'o': case 'p': case 'q': case 'r': case 's': case 't': case 'u':
    	    case 'v': case 'w': case 'x': case 'y': case 'z':
    	    	takeIt(); // letter
    	    	while(isLetter(current) || isDigit(current)) {
    	    		takeIt(); // (letter | digit) *
    	    	}
    	    	if(buffer.toString().equals("begin")) {
    	    		//Begin token
    	    		result = new Token(Token.Kind.BEGIN, buffer.toString());
    	    	} else if (buffer.toString().equals("end")) {
    	    		//End token
    	    		result = new Token(Token.Kind.END, buffer.toString());
    	    	} else if (buffer.toString().equals("tabular")) {
    	    		//Tabular token
    	    		result = new Token(Token.Kind.TABULAR, buffer.toString());
    	    	} else {
    	    		//Identifier
    	    		result = new Token(Token.Kind.IDENTIFIER, buffer.toString());
    	    	}
    	    	buffer.delete(0, buffer.length());
    	    	current = this.getNextChar();
    	    	break;
    	    case '0': case '1': case '2': case '3': case '4': case '5': case '6':
    	    case '7': case '8': case '9':
    	    	takeIt(); // digit
    	    	while(isDigit(current)) {
    	    		takeIt(); // (digit) *
    	    	}
    	    	result = new Token(Token.Kind.NUM, buffer.toString());
    	    	buffer.delete(0, buffer.length());
    	    	current = this.getNextChar();
    	    	break;
    	    default:
    	    	throw new SyntaxError("Unknown character: " + current + " at line " + currentLineNr);
    	    }
    	}
    	return result;
    }
    
    /**
     * Append the current token and move to the next character
     */
    private void takeIt() {
    	buffer.append(current);
    	current = this.getNextChar();
    }
    
    /**
     * Check if character is a letter
     * @param ch
     * @return
     */
    private static boolean isLetter(char ch) {
    	return Character.isLowerCase(ch);
    }
    
    /**
     * Check if character is a digit
     * @param ch
     * @return
     */
    private static boolean isDigit(char ch) {
    	return Character.isDigit(ch);
    }
    
    
    public static void main(String[] args) {
    	for (int i = 0; i < args.length; i++) {
			String fname = args[i];
			try {
				Scanner scanner = new Scanner(new FileInputStream(fname));
				Token tempToken;
				while((tempToken = scanner.scan()) != null) {
					System.out.println("Kind: " + tempToken.getKind().getSpelling()
							+ ", representation: " + tempToken.getRepr());
				}
			}
			catch(Exception e) {
				System.out.println(e.getMessage());
			}
    	}
    }	
}
