/*
 * @(#)BinaryExpression.java                        2.0 1999/08/11
 *
 * Copyright (C) 1999 D.A. Watt and D.F. Brown
 * Dept. of Computing Science, University of Glasgow, Glasgow G12 8QQ Scotland
 * and School of Computer and Math Sciences, The Robert Gordon University,
 * St. Andrew Street, Aberdeen AB25 1HG, Scotland.
 * All rights reserved.
 *
 * This software is provided free for educational use only. It may
 * not be used for commercial purposes without the prior written permission
 * of the authors.
 */

package Triangle.AbstractSyntaxTrees;

import Triangle.SyntacticAnalyzer.SourcePosition;

public class BinaryExpression extends Expression {

  public BinaryExpression (Expression e1AST, Operator oAST, Expression e2AST,
             SourcePosition thePosition) {
    super (thePosition);
    O = oAST;
    E1 = e1AST;
    E2 = e2AST;
  }

  public Object visit(Visitor v, Object o) {
    return v.visitBinaryExpression(this, o);
  }

  public Expression E1, E2;
  public Operator O;
}
