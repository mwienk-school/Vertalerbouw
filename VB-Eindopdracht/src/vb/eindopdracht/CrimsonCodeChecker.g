tree grammar CrimsonCodeChecker;

options {
    tokenVocab=CrimsonCodeGrammar;                    // import tokens from Calc.tokens
    ASTLabelType=CommonTree;            // AST nodes are of type CommonTree
}

@header {
  package vb.eindopdracht;
}
  
program
  :   ^(PROGRAM compExpr)
  ;

compExpr
  :   ^(CONST IDENTIFIER expression)
  |   ^(VAR IDENTIFIER)
  |   expression
  ;
  
expression
  :   ^(UPLUS expression)
  |   ^(UMINUS expression)
  |   ^(PLUS expression expression)
  |   ^(MINUS expression expression)
  |   ^(BECOMES IDENTIFIER expression)
  |   ^(VARASSIGN expression)
  |   ^(OR expression expression)
  |   ^(AND expression expression)
  |   ^(LT expression expression)
  |   ^(LE expression expression)
  |   ^(GT expression expression)
  |   ^(GE expression expression)
  |   ^(EQ expression expression)
  |   ^(NEQ expression expression)
  |   ^(TIMES expression expression)
  |   ^(DIVIDE expression expression)
  |   ^(IF expression expression expression)
  |   ^(WHILE expression expression)
  |   ^(READ varlist)
  |   ^(PRINT exprlist)
  |   operand
  ;
  
exprlist
  :   expression+
  ;
  
varlist
  :   IDENTIFIER+
  ;
  
operand
  :   IDENTIFIER
  |   TRUE
  |   FALSE
  |   NUMBER
  ;
  
declaration
  :   ^(VAR id=IDENTIFIER) 
        {   if($id.text.endsWith("Pill")) {
              System.out.println("pilletje gevonden!");
            } else {
              System.out.println("WAAR IS MIJN PIL!?!?!");
            };
        }
  ;