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
    :   ^(SERIE {symtab.openScope(); } serie {symtab.closeScope(); })
    ;

serie
    :   unit*
    ;
    
unit
    :   ^(DECL id=ID) {
          try {
            symtab.enter($id.text, new IdEntry());
          } catch (Exception e) {
            System.out.println($id.text + " already declared on the current level " + symtab.currentLevel());
            e.printStackTrace();
          }
        }
    |   ^(USE id=ID)         {
              //Retrieve IdEntry from SymbolTable on use
              IdEntry use = symtab.retrieve($id.text);
              System.out.print("U:" + $id.text);
              if(use != null) {
                System.out.println(" declared on level " + use.getLevel());
              } else {
                System.out.println("*undeclared*");
              }
        }
    |   ^(SERIE {symtab.openScope(); } serie {symtab.closeScope(); })
    ;    
