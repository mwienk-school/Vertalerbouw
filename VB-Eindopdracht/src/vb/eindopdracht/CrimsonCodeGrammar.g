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
  
  //Types
  INTEGER   = 'int';
  BOOLEAN   = 'bool';
  CHAR      = 'char';
  STRING    = 'string';
  
  //Commands
  IF        = 'if';
  WHILE     = 'while';
  DO        = 'do';
  
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
  : type^ ID
  ;

//Commands  
command
  : ifCommand
  | whileCommand
  ;
  
ifCommand
  : IF^ exprrelop
  ;
  
whileCommand
  : WHILE^ BOOLEAN DO! command
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
  : ID
  ;
  
type
  : INTEGER
  | CHAR
  | BOOLEAN
  | STRING
  ;

//Lexer regels
  
ID
  : LETTER+
  ;
  
COMMENT
    :   '//' .* '\n' 
            { $channel=HIDDEN; }
    ;

WS
    :   (' ' | '\t' | '\f' | '\r' | '\n')+
            { $channel=HIDDEN; }
    ;
  
fragment DIGIT  :   ('0'..'9') ;
fragment LOWER  :   ('a'..'z') ;
fragment UPPER  :   ('A'..'Z') ;
fragment LETTER :   LOWER | UPPER ;