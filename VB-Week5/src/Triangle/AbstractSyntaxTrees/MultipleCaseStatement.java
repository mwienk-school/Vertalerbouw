package Triangle.AbstractSyntaxTrees;

import Triangle.SyntacticAnalyzer.SourcePosition;

public class MultipleCaseStatement extends CaseStatement {

	public MultipleCaseStatement(SourcePosition thePosition, IntegerLiteral iAST, Command cAST, CaseStatement csAST) {
		super(thePosition);
		I = iAST;
		C = cAST;
		CS = csAST;
	}

	@Override
	public Object visit(Visitor v, Object o) {
		// TODO Auto-generated method stub
		return null;
	}
	
	public IntegerLiteral I;
	public Command C;
	public CaseStatement CS;
}
