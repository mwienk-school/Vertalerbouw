package Triangle.AbstractSyntaxTrees;

import Triangle.SyntacticAnalyzer.SourcePosition;

public class RepeatCommand extends Command {
	
	public RepeatCommand (Expression eAST, Command cAST, SourcePosition thePosition) {
	    super (thePosition);
	    E = eAST;
	    C = cAST;
	  }

	@Override
	public Object visit(Visitor v, Object o) {
		// TODO Auto-generated method stub
		return null;
	}
	
	public Expression E;
	public Command C;
}
