tree grammar CrimsonCodeChecker;

options {
    tokenVocab=CrimsonCodeGrammar;                    // import tokens from Calc.tokens
    ASTLabelType=CommonTree;            // AST nodes are of type CommonTree
}

@header {
  package vb.eindopdracht;
}
  
program
  :
  ;