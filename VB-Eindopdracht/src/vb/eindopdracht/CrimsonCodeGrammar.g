grammar CrimsonCodeGrammar;

options {
  language = Java;
  output = AST;
  k = 1;
}

tokens {
  //Global
  PROGRAM   = 'program';
  SEMICOLON = ';';
  COLON     = ':';
  COMMA     = ',';
  VAR       = 'colour';
  
  //Types
  INTEGER   = 'i';
  BOOLEAN   = 'pill';
  CHAR      = 'c';
  STRING    = 'fate';
  
  TRUE      = 'red';
  FALSE     = 'blue';
  
  //Commands
  IF        = 'if';
  WHILE     = 'while';
  DO        = 'do';
  BECOMES   = '=';
  
  //Logic operators
  LT        = '<';
  LE        = '<=';
  GT        = '>';
  GE        = '>=';
  EQ        = '==';
  NEQ       = '!=';
  
  //Math operators
  PLUS      = '+';
  MINUS     = '-';
  TIMES     = '*';
  DIVIDE    = '/';
  
}

@header {
  package vb.eindopdracht;
}
  
@lexer::header {
  package vb.eindopdracht;
}

//Parser regels

program
  : statement+ EOF
    ->^(PROGRAM statement+)
  ;

statement
  : declaration
  | command
  ;
  
declaration
  : VAR^ id (BECOMES^ (TRUE|FALSE))?
  ;

//Commands  
command
  : ifCommand
  | assignCommand
  | whileCommand
  ;
  
ifCommand
  : IF^ exprrelop
  ;

assignCommand
  : id BECOMES^ (TRUE | FALSE)
  ;
  
whileCommand
  : WHILE^ exprrelop DO! command
  ;

//Expressies
exprrelop
  :   exprplus ((LT^ | LE^ | GT^ | GE^ | EQ^ | NEQ^) exprplus)*
  ;
    
exprplus
  :   exprtimes ((PLUS^ | MINUS^) exprtimes)*
  ;
    
exprtimes
  :   operand ((TIMES^ | DIVIDE^) operand)*
  ;

operand
  : id
  ;
  
id
  : type^ CAMEL
  ;
  
type   
  : INTEGER | BOOLEAN | CHAR | STRING;
  
//Lexer regels

COMMENT
  :   '//' .* '\n' 
        { $channel=HIDDEN; }
  ;

WS
  :   (' ' | '\t' | '\f' | '\r' | '\n')+
        { $channel=HIDDEN; }
  ;



CAMEL
  : UPPER LETTER* 
  ;
  
fragment DIGIT  :   ('0'..'9') ;
fragment LOWER  :   ('a'..'z') ;
fragment UPPER  :   ('A'..'Z') ;
fragment LETTER :   LOWER | UPPER ;