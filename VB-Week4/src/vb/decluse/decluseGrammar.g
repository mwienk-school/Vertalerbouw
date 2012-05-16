grammar decluseLexer;

options {
  language = Java;
}

tokens {
    LPAREN      =   '('     ;
    RPAREN      =   ')'     ;
    DECL        =   'D:'    ;
    USE         =   'U:'    ;
}

decluse
   : LPAREN! serie RPAREN!
   ;
   
serie
   : unit serie?
   ;
   
unit
   : decl
   | use
   | LPAREN! serie RPAREN!
   ;
   
decl
   : DECL id
   ;
   
use
   : USE id
   ;

id
   : LETTER id?
   ;
   
fragment LETTER :   LOWER | UPPER ;
fragment LOWER  :   ('a'..'z') ;
fragment UPPER  :   ('A'..'Z') ;
