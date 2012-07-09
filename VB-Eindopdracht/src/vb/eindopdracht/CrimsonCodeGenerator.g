tree grammar CrimsonCodeGenerator;

options {
    tokenVocab=CrimsonCodeGrammar;
    ASTLabelType=CommonTree;
}

@rulecatch { 
    catch (Exception e) { 
        System.err.println("ERROR:");
        e.printStackTrace(); 
    } 
}

@header {
  package vb.eindopdracht;
  import java.util.HashMap;
  import vb.eindopdracht.symboltable.*;
  import vb.eindopdracht.helpers.*;
}

@members {
  private GeneratorHelper gh = new GeneratorHelper();
}

//Parser regels

program
  : ^(PROGRAM compExpr+) { gh.endProgram(); }
  ;
   
compExpr
  :   ^(CONST { gh.setConstantScope(true); } id=IDENTIFIER ex=expression) { gh.defineConstant($id.text, ex); gh.setConstantScope(false); }
  |   ^(VAR id=IDENTIFIER) { gh.defineVariable($id.text); }
  |   //TODO implementaties van PROC & FUNC en paramdecl en paramuse
      ^(PROC id=IDENTIFIER { gh.symbolTable.openScope(); } paramdecl+ expression {gh.symbolTable.closeScope();})
  |   ^(FUNC id=IDENTIFIER { gh.symbolTable.openScope(); } paramdecl+ expression {gh.symbolTable.closeScope();})
  |   expression
  ;
  
paramdecl
  :   ^(PARAM id=IDENTIFIER) { gh.defineVariable($id.text); }
  |   ^(VAR id=IDENTIFIER)   { gh.defineVariable($id.text); }
  ;

paramuse
  :   ^(PARAM id=IDENTIFIER)
      {
        //TODO ??
      } 
  |   ^(VAR id=IDENTIFIER)
      {
        //TODO ??
      }
  ;
    
expression returns [String val = null;] 
  :   ^(NEG ex=expression)
      {
        gh.printPrimitiveRoutine("not", "Negate");
        if(ex.equals("0")) {
          val = "1";
        } else {
          val = "0";
        }
      }
  |   ^(UPLUS ex=expression)   { val = ex; }
  |   ^(UMINUS ex=expression)  
      { 
        gh.loadLiteral("-1");
        gh.printPrimitiveRoutine("mult", "Multiply the top of the stack");
        val = ex;
      }
  |   ^(PLUS ex=expression ey=expression)  
      { 
        gh.printPrimitiveRoutine("add", "Add the top of the stack");
        val = String.valueOf(Integer.parseInt(ex) + Integer.parseInt(ey)); 
      }  
  |   ^(MINUS ex=expression ey=expression) 
      { 
        gh.printPrimitiveRoutine("sub", "Subtract the top of the stack");
        val = String.valueOf(Integer.parseInt(ex) - Integer.parseInt(ey));
      }
  |   ^(BECOMES id=IDENTIFIER ex=expression)  
      { 
        gh.storeValue($id.text, ex);
        val = ex;
      }
  |   ^(OR ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("or", "OR statement");
        val = (!ex.equals("0") && !ex.equals("") || !ey.equals("0") && !ey.equals("")) ? "1" : "0";
      }
  |   ^(AND ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("and", "AND statement");
        val = (!ex.equals("0") && !ex.equals("") && !ey.equals("0") && !ey.equals("")) ? "1" : "0";
      }
  |   ^(LT ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("lt", "Lesser than");
        val = Integer.parseInt(ex) < Integer.parseInt(ey) ? "1" : "0";
      }
  |   ^(LE ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("le", "Lesser or equal to");
        val = Integer.parseInt(ex) <= Integer.parseInt(ey) ? "1" : "0";
      }
  |   ^(GT ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("gt", "Greater than");
        val = Integer.parseInt(ex) > Integer.parseInt(ey) ? "1" : "0";
      }
  |   ^(GE ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("ge", "Greater or equal to");
        val = Integer.parseInt(ex) >= Integer.parseInt(ey) ? "1" : "0";
      }
  |   ^(EQ ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("eq", "Equal to");
        val = Integer.parseInt(ex) == Integer.parseInt(ey) ? "1" : "0";
      }
  |   ^(NEQ ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("ne", "Not equal to");
        val = Integer.parseInt(ex) != Integer.parseInt(ey) ? "1" : "0";
      }
  |   ^(TIMES ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("mult", "Multiplication");
        val = String.valueOf(Integer.parseInt(ex) * Integer.parseInt(ey));
      }
  |   ^(DIVIDE expression expression)
      {
        gh.printPrimitiveRoutine("div", "Division");
        val = String.valueOf(Integer.parseInt(ex) / Integer.parseInt(ey));
      }
  |   ^(IF expression  { int ifVal = gh.printStatementIf_Start();} 
           expression  { gh.printStatementIf_Else(ifVal);} 
           expression) { gh.printStatementIf_End(ifVal); }
  |   ^(WHILE expression  { WhileInfo info = gh.printStatementWhile_Start(); }
              expression) { gh.printStatementWhile_End(info); }
  |   ^(READ readvar+)
  |   ^(PRINT printexpr+)
  |   ^(CCOMPEXPR { gh.symbolTable.openScope(); } compExpr+)
      { 
        gh.symbolTable.closeScope();
      }
  |   ^(ARRAY expression+)
      {
        //TODO
      }
  |   ^(TYPE id=IDENTIFIER NUMBER NUMBER)
      {
        //TODO
      }
  |   ex=operand 
      {
        val = ex;
      }
  ;
  
readvar
  :   id=IDENTIFIER { gh.printPrimitiveRoutine("get", "Get a value for an id"); }
  ;
  
printexpr
  :   expression { gh.printPrimitiveRoutine("put", "Print the first value on the stack"); }
  ;
  
operand returns [String val = null;]
  :   ^(id=IDENTIFIER expression* paramuse*)  
      { 
//        if(!vars.get($id.text).isConstant()) {
//          printTAM("LOAD(1)", vars.get($id.text).getAddress(), "Load variable " + $id.text);
//        } TODO moet dit erin?
        val = gh.getValue($id.text);
      } 
  |   TRUE
      {
        if(!gh.isConstantScope()) gh.loadLiteral("1");
        val = "1";
      }
  |   FALSE
      {
        if(!gh.isConstantScope()) gh.loadLiteral("0");
        val = "0";
      }
  |   n=NUMBER
      {
        if(!gh.isConstantScope()) gh.loadLiteral(String.valueOf(n));
        val = String.valueOf(n);
      }
  ;