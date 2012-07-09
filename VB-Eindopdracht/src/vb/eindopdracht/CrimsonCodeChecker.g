tree grammar CrimsonCodeChecker;

options {
    tokenVocab=CrimsonCodeGrammar;
    ASTLabelType=CommonTree;
}

@header {
  package vb.eindopdracht;
  import vb.eindopdracht.helpers.CheckerHelper;
}

@rulecatch { 
    catch (Exception e) { 
        System.err.println("ERROR:");
        e.printStackTrace(); 
    } 
}

@members {
  private CheckerHelper ch = new CheckerHelper();
}

program
  :   ^(PROGRAM compExpr+)
  ;

compExpr
  :   ^(CONST id=IDENTIFIER expression) { ch.processEntry($id.text); }
  |   ^(VAR id=IDENTIFIER)              { ch.processEntry($id.text); }
  |   ^(PROC id=IDENTIFIER {ch.symbolTable.openScope();} paramdecl+ expression {ch.symbolTable.closeScope();})
                                        { ch.processEntry($id.text); }
  |   ^(FUNC id=IDENTIFIER {ch.symbolTable.openScope();} paramdecl+ expression {ch.symbolTable.closeScope();})
                                        { ch.processEntry($id.text); }
  |   expression
  ;

paramdecl
  :   ^(PARAM id=IDENTIFIER)            { ch.processEntry($id.text); }
  |   ^(VAR id=IDENTIFIER)              { ch.processEntry($id.text); }
  ;

paramuse
  :   ^(PARAM id=IDENTIFIER)
        {
	        if(ch.symbolTable.retrieve($id.text) == null) throw new Exception($id.text + " is not declared.");
	      }
  |   ^(VAR id=IDENTIFIER)
        {
	        if(ch.symbolTable.retrieve($id.text) == null) throw new Exception($id.text + " is not declared.");
	      }
  ;
  
expression returns [String val = null;]
  :   ^(NEG ex=expression)        { retval.val = ch.checkType("boolean", $ex.text); }
  |   ^(UPLUS ex=expression)      { retval.val = ch.checkType("integer", $ex.text); }
  |   ^(UMINUS ex=expression)     { retval.val = ch.checkType("integer", $ex.text); }
  |   ^(PLUS e1=expression e2=expression)
  |   ^(MINUS expression expression)
  |   ^(BECOMES id=IDENTIFIER expression)   { ch.checkDeclared($id.text);}
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
  |   ^(MOD expression expression)
  |   ^(IF expression expression expression)
  |   ^(WHILE expression expression)
  |   ^(READ varlist)
  |   ^(PRINT exprlist)
  |   ^(CCOMPEXPR { ch.symbolTable.openScope(); } compExpr+ { ch.symbolTable.closeScope(); })
  |   ^(ARRAY expression+)
  |   ^(TYPE id=IDENTIFIER NUMBER NUMBER)                { ch.processDynamicType($id.text); }
  |   operand
  ;
  
exprlist
  :   expression+
  ;
  
varlist
  :   id=IDENTIFIER+    { ch.checkDeclared($id.text); }
  ;
  
operand 
  :   ^(id=IDENTIFIER   { ch.checkDeclared($id.text);} expression* paramuse*)
  |   TRUE
  |   FALSE
  |   NUMBER
  ;
