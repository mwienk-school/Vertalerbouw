tree grammar decluseTreeParser;

options {
  tokenVocab=decluseGrammar;
  ASTLabelType=CommonTree;
}

@header {
package vb.decluse;
import vb.week1.symtab.*;
}

@members {
protected SymbolTable<IdEntry> symtab = new SymbolTable<IdEntry>();
}
program
    :   ^(DECL ID) 
    |   ^(USE ID)
    |   ^(OPEN)
    |   ^(CLOSE)
    ;
