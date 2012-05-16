tree grammar decluseTreeParser;

options {
  tokenVocab=decluseGrammar;
  ASTLabelType=CommonTree;
}

@header {
package vb.decluse;
}

program
    : ^(DECL ID)
    | ^(USE ID)
    ;
