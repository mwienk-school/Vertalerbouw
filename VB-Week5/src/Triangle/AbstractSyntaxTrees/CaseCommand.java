package Triangle.AbstractSyntaxTrees;

import Triangle.SyntacticAnalyzer.SourcePosition;

public class CaseCommand extends Command {
	
	  public CaseCommand (Expression eAST, Command cAST,
              SourcePosition thePosition) {
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
