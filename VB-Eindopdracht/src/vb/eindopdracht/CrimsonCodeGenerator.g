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
  |   ^(PROC id=IDENTIFIER { int number = gh.defineProcedure_Start($id.text); } 
             par=paramdecls 
             {
               gh.defineProcedure_End(number);
               for(int i = 0; i < $par.paramList.size(); i++) {
                gh.defineParameter((String)$par.paramList.get(i), i-$par.paramList.size());
               }
             }
             expression)
  |   ^(FUNC id=IDENTIFIER { gh.symbolTable.openScope(); } paramdecls expression {gh.symbolTable.closeScope(); //TODO implementaties van PROC & FUNC en paramdecl en paramuse
  })
  |   expression
  ;
  
paramdecls returns [List paramList = new ArrayList();]
  :   ^(PARAM id=IDENTIFIER)  { $paramList.add($id.text); } (par=paramdecls { $paramList.addAll($par.paramList); })?
  |   ^(VAR id=IDENTIFIER)    { $paramList.add($id.text+"Var"); } (par=paramdecls { $paramList.addAll($par.paramList); })?
  ;

paramuse
  :   ^(PARAM id=IDENTIFIER)  { gh.getValue($id.text); }
  |   ^(VAR id=IDENTIFIER)    { gh.getAddress($id.text); }
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
        gh.loadLiteral("1");
        gh.printPrimitiveRoutine("eq", "Equal to");
        val = Integer.parseInt(ex) == Integer.parseInt(ey) ? "1" : "0";
      }
  |   ^(NEQ ex=expression ey=expression)
      {
        gh.loadLiteral("1");
        gh.printPrimitiveRoutine("ne", "Not equal to");
        val = Integer.parseInt(ex) != Integer.parseInt(ey) ? "1" : "0";
      }
  |   ^(TIMES ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("mult", "Multiplication");
        val = String.valueOf(Integer.parseInt(ex) * Integer.parseInt(ey));
      }
  |   ^(DIVIDE ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("div", "Division");
        val = String.valueOf(Integer.parseInt(ex) / Integer.parseInt(ey));
      }
  |   ^(IF expression  { int ifVal = gh.printStatementIf_Start();} 
           expression  { gh.printStatementIf_Else(ifVal);} 
           expression?) { gh.printStatementIf_End(ifVal); }
  |   ^(WHILE { WhileInfo info = gh.printStatementWhile_Start(); }
            expression  { gh.printStatementWhile_Do(info); }
            expression) { gh.printStatementWhile_End(info); }
  |   ^(READ readvar+)
  |   ^(PRINT printexpr+)
  |   ^(PRINTLN printexpr+) { gh.printStatementPrint("\n"); }
  |   ^(CCOMPEXPR { gh.symbolTable.openScope(); } compExpr+)
      { 
        gh.symbolTable.closeScope();
      }
  |   ^(ARRAY (expression)+)
      {
        //TODO Arrays afmaken
      }
  |   ^(TYPE id=IDENTIFIER n1=NUMBER n2=NUMBER)
      {
        gh.defineArray_Type($id.text, $n1.text, $n2.text);
      }
  |   ex=operand 
      {
        val = ex;
      }
  ;
  
readvar
  :   id=IDENTIFIER { gh.printStatementRead($id.text); }
  ;
  
printexpr
  :   ex=expression { gh.printStatementPrint(ex); }
  ;
  
operand returns [String val = null;]
  :   ^(id=IDENTIFIER expression* paramuse*)  
      { 
        $val = gh.getValue($id.text);
      } 
  |   TRUE
      {
        $val = "1";
        if(!gh.isConstantScope()) gh.loadLiteral(val);
      }
  |   FALSE
      {
        $val = "0";
        if(!gh.isConstantScope()) gh.loadLiteral(val);
      }
  |   n=NUMBER
      {
        $val = String.valueOf(n);
        if(!gh.isConstantScope()) gh.loadLiteral(val);
      }
  |   ch=CHARACTER
      {
        $val = $ch.text.substring(1,2);
        if(!gh.isConstantScope()) gh.loadLiteral(val);
      }
  ;
