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
    
    SERIE       =   '#serie';
}
@lexer::header {
   package vb.decluse;
}

@header {
   package vb.decluse;
}

// Parser rules

decluse
   :  LPAREN serie RPAREN
      ->  ^(SERIE serie)
   ;
   
serie
   :  unit*
   ;
   
unit
   :  DECL^ ID
   |  USE^ ID
   |  LPAREN serie RPAREN
      ->  ^(SERIE serie)
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
