grammar decluseGrammar;

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
}
@lexer::header {
   package vb.decluse;
}

@header {
   package vb.decluse;
}

// Parser rules

decluse
   :  LPAREN! serie RPAREN!
   ;
   
serie
   :  unit*
   ;
   
unit
   :  DECL^ ID
   |  USE^ ID
   |  LPAREN! serie RPAREN!
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
