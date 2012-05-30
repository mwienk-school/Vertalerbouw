/*
 * @(#)Token.java                        2.0 1999/08/11
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

package Triangle.SyntacticAnalyzer;

import Triangle.SyntacticAnalyzer.SourcePosition;

final class Token extends Object {

  protected int kind;
  protected String spelling;
  protected SourcePosition position;

  public Token(int kind, String spelling, SourcePosition position) {

    if (kind == Token.IDENTIFIER) {
      int currentKind = firstReservedWord;
      boolean searching = true;

      while (searching) {
        int comparison = tokenTable[currentKind].compareTo(spelling);
        if (comparison == 0) {
          this.kind = currentKind;
          searching = false;
        } else if (comparison > 0 || currentKind == lastReservedWord) {
          this.kind = Token.IDENTIFIER;
          searching = false;
        } else {
          currentKind ++;
        }
      }
    } else
      this.kind = kind;

    this.spelling = spelling;
    this.position = position;

  }

  public static String spell (int kind) {
    return tokenTable[kind];
  }

  public String toString() {
    return "Kind=" + kind + ", spelling=" + spelling +
      ", position=" + position;
  }

  // Token classes...

  public static final int

    // literals, identifiers, operators...
    INTLITERAL		= 0,
    CHARLITERAL		= 1,
    IDENTIFIER		= 2,
    OPERATOR		= 3,

    // reserved words - must be in alphabetical order...
    ARRAY		= 4,
    BEGIN		= 5,
    CASE		= 6,
    CONST		= 7,
    DO			= 8,
    ELSE		= 9,
    END			= 10,
    FUNC		= 11,
    IF			= 12,
    IN			= 13,
    LET			= 14,
    OF			= 15,
    PROC		= 16,
    RECORD		= 17,
    REPEAT		= 18,
    THEN		= 19,
    TYPE		= 20,
    UNTIL		= 21,
    VAR			= 22,
    WHILE		= 23,

    // punctuation...
    DOT			= 24,
    COLON		= 25,
    SEMICOLON		= 26,
    COMMA		= 27,
    BECOMES		= 28,
    IS			= 29,

    // brackets...
    LPAREN		= 30,
    RPAREN		= 31,
    LBRACKET		= 32,
    RBRACKET		= 33,
    LCURLY		= 34,
    RCURLY		= 35,

    // special tokens...
    EOT			= 36,
    ERROR		= 37;
  	

  private static String[] tokenTable = new String[] {
    "<int>",
    "<char>",
    "<identifier>",
    "<operator>",
    "array",
    "begin",
    "case",
    "const",
    "do",
    "else",
    "end",
    "func",
    "if",
    "in",
    "let",
    "of",
    "proc",
    "record",
    "repeat",
    "then",
    "type",
    "until",
    "var",
    "while",
    ".",
    ":",
    ";",
    ",",
    ":=",   // [2003.04.22 ruys] added missing BECOMES token (reported and fixed by Ingo Wassink)
    "~",
    "(",
    ")",
    "[",
    "]",
    "{",
    "}",
    "",
    "<error>"
  };

  private final static int	firstReservedWord = Token.ARRAY,
  				lastReservedWord  = Token.WHILE;

}
