package vb.week2.tabular;

/**
 * VB prac week2: LaTeX tabular -> HTML symbolicName.
 * Token class.
 * @author  Theo Ruys, Arend Rensink
 * @version 2012.04.28
 */
public class Token {
	public enum Kind {
		IDENTIFIER("<IDENTIFIER>"), 
		NUM("<NUM>"), 
		BEGIN("begin"), 
		END("end"), 
		TABULAR("tabular"), 
		BSLASH("<BSLASH>"), 
		DOUBLE_BSLASH("<DOUBLE_BSLASH>"), 
		BAR("<BAR>"), 
		AMPERSAND("<AMPERSAND>"), 
		LCURLY("<LCURLY>"), 
		RCURLY("<RCURLY>"), 
		EOT("<EOT>");

		private Kind(String spelling) {
			this.spelling = spelling;
		}

		/** Returns the exact spelling of the keyword tokens. */
		public String getSpelling() {
			return spelling;
		}

		final private String spelling;
	}
	
    private Kind     kind;
    private String   repr;

    /**
     * Construeert een Token-object gegeven de "kind" van het Token
     * en zijn representatie. Als het een IDENTIFIER Token is wordt
     * gecontroleerd of het geen "keyword" is.
     * @param kind soort Token
     * @param repr String representatie van het Token
     */
    public Token(Kind kind, String repr) {
        this.kind = kind;
        this.repr = repr;
        // Recognize keywords
        if (this.kind == Kind.IDENTIFIER) {
            for (Kind k: Kind.values()) {
                if (repr.equals(k.getSpelling())) {
                    this.kind = k;
                    break;
                }
            }
        }
    }
    
    /** Levert het soort Token. */
    public Kind getKind() {
        return kind;
    }
    
    /** Levert de String-representatie van dit Token. */
    public String getRepr() {
        return repr;
    }
}
