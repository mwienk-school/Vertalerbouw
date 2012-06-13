tree grammar CrimsonCodeChecker;

options {
    tokenVocab=CrimsonCodeGrammar;                    // import tokens from Calc.tokens
    ASTLabelType=CommonTree;            // AST nodes are of type CommonTree
}

@header {
  package vb.eindopdracht;
  import java.util.Map;
  import java.util.HashMap;
}

@rulecatch { 
    catch (Exception e) { 
        System.out.println("ERROR:" + e.getMessage()); 
    } 
}

@members {
  private static String[] tokennames = {"Pill","Int","Char"};
}
program
  :   ^(PROGRAM compExpr+)
  ;

compExpr
  :   ^(CONST IDENTIFIER expression)
  |   ^(VAR id=IDENTIFIER)
        {     boolean validType = false;
              for(String type : tokennames)
              {
                if($id.text.endsWith(type))
                  validType = true;
              }
              if(!validType) throw new Exception("The declared type is an unknown type");
        }
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