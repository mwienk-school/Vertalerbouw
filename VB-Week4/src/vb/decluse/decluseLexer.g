grammar decluseLexer;

options {
  language = Java;
}

tokens {
    LPAREN      =   '('     ;
    RPAREN      =   ')'     ;
}

decluse
   : LPAREN! serie RPAREN!
   ;
   
serie
   :
   ;
