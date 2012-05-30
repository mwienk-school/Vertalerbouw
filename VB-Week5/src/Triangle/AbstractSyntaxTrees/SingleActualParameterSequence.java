/*
 * @(#)SingleActualParameterSequence.java                2.0 1999/08/11
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

public class SingleActualParameterSequence extends ActualParameterSequence {

  public SingleActualParameterSequence (ActualParameter apAST,
                                 SourcePosition thePosition) {
    super (thePosition);
    AP = apAST;
  }

  public Object visit(Visitor v, Object o) {
    return v.visitSingleActualParameterSequence(this, o);
  }

  public ActualParameter AP;
}
