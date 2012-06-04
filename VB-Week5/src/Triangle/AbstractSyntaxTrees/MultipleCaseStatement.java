package Triangle.AbstractSyntaxTrees;

import Triangle.SyntacticAnalyzer.SourcePosition;

public class MultipleCaseStatement extends CaseStatement {

	public MultipleCaseStatement(IntegerLiteral iAST, Command cAST, CaseStatement csAST, SourcePosition thePosition) {
		super(thePosition);
		I = iAST;
		C = cAST;
		CS = csAST;
	}

	@Override
	public Object visit(Visitor v, Object o) {
		v.visitMultipleCaseStatement(this, o);
		return null;
	}
	
	public IntegerLiteral I;
	public Command C;
	public CaseStatement CS;
}
