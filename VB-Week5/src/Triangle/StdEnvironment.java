/*
 * @(#)StdEnvironment.java                        2.0 1999/08/11
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

package Triangle;

import Triangle.AbstractSyntaxTrees.*;

public final class StdEnvironment {

  // These are small ASTs representing standard types.

  public static TypeDenoter
    booleanType, charType, integerType, anyType, errorType;

  public static TypeDeclaration
    booleanDecl, charDecl, integerDecl;

  // These are small ASTs representing "declarations" of standard entities.

  public static ConstDeclaration
    falseDecl, trueDecl, maxintDecl;

  public static UnaryOperatorDeclaration
    notDecl;

  public static BinaryOperatorDeclaration
    andDecl, orDecl,
    addDecl, subtractDecl, multiplyDecl, divideDecl, moduloDecl,
    equalDecl, unequalDecl, lessDecl, notlessDecl, greaterDecl, notgreaterDecl;

  public static ProcDeclaration
    getDecl, putDecl, getintDecl, putintDecl, geteolDecl, puteolDecl;

  public static FuncDeclaration
    chrDecl, ordDecl, eolDecl, eofDecl;

}
