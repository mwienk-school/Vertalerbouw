package Triangle.AbstractSyntaxTrees;

import Triangle.SyntacticAnalyzer.SourcePosition;

public class CaseCommand extends Command {
	
	  public CaseCommand (Expression eAST, CaseStatement csAST,
              			   Command cAST, SourcePosition thePosition) {
		  super (thePosition);
		  E = eAST;
		  CS = csAST;
		  C = cAST;
	  }

	  @Override
	  public Object visit(Visitor v, Object o) {
		  return v.visitCaseCommand(this, o);
	  }
	  
	  public Expression E;
	  public CaseStatement CS;
	  public Command C;
}
