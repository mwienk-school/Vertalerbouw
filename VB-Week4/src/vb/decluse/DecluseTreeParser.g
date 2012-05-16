tree grammar DecluseTreeParser;

options {
  tokenVocab=DecluseGrammar;
  ASTLabelType=CommonTree;
}

@header {
package vb.decluse;
import vb.week1.symtab.*;
}

@members {
protected SymbolTable<IdEntry> symtab = new SymbolTable<IdEntry>();
}

decluse
    :  open serie close
    ;

serie
    :  unit*
    ;
    
open
    :   ^(OPEN LPAREN)    { symtab.openScope(); }
    ;
    
close
    :   ^(CLOSE RPAREN)   { symtab.closeScope(); }
    ;
    
unit
    :   ^(DECL id=LETTER+) {
          try {
            symtab.enter($id.text, new IdEntry());
            System.out.println("DECLARED");
          } catch (Exception e) {
            System.out.println($id.text + " already declared on the current level");
          }
        }
    |   ^(USE id=LETTER+)         {
              //Retrieve IdEntry from SymbolTable on use
              IdEntry use = symtab.retrieve($id.text);
              System.out.print("U:" + $id.text);
              if(use != null) {
                System.out.println("declared on level " + use.getLevel());
              } else {
                System.out.println("*undeclared*");
              }
        }
    |   open serie close
    ;
    
