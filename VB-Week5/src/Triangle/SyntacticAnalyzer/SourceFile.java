/*
 * @(#)SourceFile.java                        2.0 1999/08/11
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

public class SourceFile {

  final static char eol = '\n';         // [2003.03.11 ruys] was non-static
  final static char eot = '\u0000';     // [2003.03.11 ruys] was non-static

  java.io.File sourceFile;
  java.io.FileInputStream source;
  int currentLine;

  public SourceFile(String filename) {
    try {
      sourceFile = new java.io.File(filename);
      source = new java.io.FileInputStream(sourceFile);
      currentLine = 1;
    }
    catch (java.io.IOException s) {
      sourceFile = null;
      source = null;
      currentLine = 0;
    }
  }

  char getSource() {
    try {
      int c = source.read();

      if (c == -1) {
        c = eot;
      } else if (c == eol) {
          currentLine++;
      }
      return (char) c;
    }
    catch (java.io.IOException s) {
      return eot;
    }
  }

  int getCurrentLine() {
    return currentLine;
  }
}
