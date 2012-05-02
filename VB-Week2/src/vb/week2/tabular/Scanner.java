package vb.week2.tabular;
import java.io.IOException;
import java.io.InputStream;
import vb.week2.tabular.Token.Kind;

public class Scanner {
    private int             currentLineNr = 0;
    private InputStream     in;

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
    public Token scan() throws SyntaxError
    {
        // body nog toe te voegen
    }                              
}
