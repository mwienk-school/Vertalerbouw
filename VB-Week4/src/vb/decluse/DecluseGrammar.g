grammar DecluseGrammar;

options {
  language = Java;
  output = AST;
  k = 1;
}

tokens {
    LPAREN      =   '('     ;
    RPAREN      =   ')'     ;
    DECL        =   'D:'    ;
    USE         =   'U:'    ;
    
    OPEN        =   'open'  ;
    CLOSE       =   'close' ;
}
@lexer::header {
   package vb.decluse;
}

@header {
   package vb.decluse;
}

// Parser rules

decluse
   :  open serie close
   ;
   
open
   :  LPAREN
   -> ^(OPEN LPAREN)
   ;
   
close
   :  RPAREN
   -> ^(CLOSE RPAREN)
   ;
   
serie
   :  unit*
   ;
   
unit
   :  DECL^ ID
   |  USE^ ID
   |  open serie close
   ;

// Lexer rules

ID
   :  LETTER+
   ;

WS
    :   (' ' | '\t' | '\f' | '\r' | '\n')+
            { $channel=HIDDEN; }
    ;

fragment LOWER  :   ('a'..'z') ;
fragment UPPER  :   ('A'..'Z') ;  
fragment LETTER :   LOWER | UPPER ;

// EOF
