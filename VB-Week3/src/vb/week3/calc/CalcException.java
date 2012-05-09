package vb.week3.calc;
import org.antlr.runtime.RecognitionException;
import org.antlr.runtime.tree.*;

class CalcException extends RecognitionException {
    private String msg;
    public static final long serialVersionUID = 24162462L; // for Serializable
    
    // Ctor which only requires the error message to be printed.
    public CalcException(String msg) {
        super();
        this.msg = msg;
    }

    // Ctor that takes a node of the AST tree (i.e. IDENTIFIER) and
    // the error message to build a more informative error message.
    public CalcException(Tree tree, String msg) {
        super();
        this.msg = tree.getText() + 
                   " (" + tree.getLine() + 
                   ":" + tree.getCharPositionInLine() + 
                   ") " + msg;
    }

    public String getMessage() {
        return msg;
    }
}
