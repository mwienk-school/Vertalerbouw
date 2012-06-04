package Triangle.AbstractSyntaxTrees;

import Triangle.SyntacticAnalyzer.SourcePosition;

public class SingleCaseStatement extends CaseStatement {

	public SingleCaseStatement(IntegerLiteral iAST, Command cAST, SourcePosition thePosition) {
		super(thePosition);
		I = iAST;
		C = cAST;
	}

	@Override
	public Object visit(Visitor v, Object o) {
		return v.visitSingleCaseStatement(this, o);
	}
	
	public IntegerLiteral I;
	public Command C;

}
