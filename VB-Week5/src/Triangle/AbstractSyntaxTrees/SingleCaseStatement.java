package Triangle.AbstractSyntaxTrees;

import Triangle.SyntacticAnalyzer.SourcePosition;

public class SingleCaseStatement extends CaseStatement {

	public SingleCaseStatement(SourcePosition thePosition, IntegerLiteral iAST, Command cAST) {
		super(thePosition);
		I = iAST;
		C = cAST;
	}

	@Override
	public Object visit(Visitor v, Object o) {
		// TODO Auto-generated method stub
		return null;
	}
	
	public IntegerLiteral I;
	public Command C;

}
