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
  int label;  //helpvariable to pass label to different rules
  boolean condition;  //helpvariable to pass condition to different rules 
}

program
  :   ^(PROGRAM (cex=compExpr
              {
                if($cex.val != null) {
                  int exprSize = 1;
                  int lastIndex = -2;
									while(lastIndex != -1){
									       lastIndex = $cex.val.indexOf(",", lastIndex+1);
									       if(lastIndex != -1){
									             exprSize++;
									      }
									}
                  gh.printStatementCleanup("non-returning expression", exprSize);
                }
              })+
              ) { gh.endProgram(); }
  ;
   
compExpr returns [String val = null;]
  :   ^(CONST 
              { 
                gh.setConstantScope(true); //Constant scope is nodig om geen literals e.d. te printen
              } 
              id=IDENTIFIER ex=expression) 
              { 
                gh.defineConstant($id.text, $ex.val); 
                gh.setConstantScope(false); 
              }
  |   ^(VAR id=IDENTIFIER) { gh.defineVariable($id.text); }
  |   ^(PROC id=IDENTIFIER 
              { 
                int number = gh.defineProcedure_Start($id.text); 
                int i = 0; 
              }
              (par=paramdecls {
                for(i = 0; i < $par.paramList.size(); i++) {
                  gh.defineParameters((String)$par.paramList.get(i), i-$par.paramList.size());
                }
              })?
             expression) { gh.defineProcedure_End(number, i); }
  |   ^(FUNC id=IDENTIFIER 
              { 
                int number = gh.defineFunction_Start($id.text); 
                int i = 0; 
              }
              (par=paramdecls {
                for(i = 0; i < $par.paramList.size(); i++) {
                  gh.defineParameters((String)$par.paramList.get(i), i-$par.paramList.size());
                }
              })?
              expression) { gh.defineFunction_End(number, i); }
  |   expr=expression { $val = $expr.val; }
  ;
  
paramdecls returns [List paramList = new ArrayList();]
  :   ^(PARAM id=IDENTIFIER)  { $paramList.add($id.text); }        (par=paramdecls { $paramList.addAll($par.paramList); })?
  |   ^(VAR id=IDENTIFIER)    { $paramList.add($id.text+"Var"); }  (par=paramdecls { $paramList.addAll($par.paramList); })?
  ;

paramuses returns [List paramList = new ArrayList();]
  :   ^(PARAM ex=expression)  { $paramList.add($ex.val); } (par=paramuses { $paramList.addAll($par.paramList); })?
  |   ^(VAR id=IDENTIFIER)    { $paramList.add($id.text+"Var"); gh.getAddress($id.text); } (par=paramuses { $paramList.addAll($par.paramList); })?
  ;
    
expression returns [String val = null;] 
  :   ^(NEG ex=expression)
      {
        gh.printPrimitiveRoutine("not", "Negate");
        if($ex.val.equals("0")) {
          $val = "1";
        } else {
          $val = "0";
        }
      }
  |   ^(UPLUS ex=expression)   { $val = $ex.val; }
  |   ^(UMINUS ex=expression)  
      { 
        gh.loadLiteral("-1");
        gh.printPrimitiveRoutine("mult", "Multiply the top of the stack");
        $val = $ex.val;
      }
  |   ^(PLUS ex=expression ey=expression)  
      { 
        gh.printPrimitiveRoutine("add", "Add the top of the stack");
        $val = String.valueOf(Integer.parseInt($ex.val) + Integer.parseInt($ey.val)); 
      }  
  |   ^(MINUS ex=expression ey=expression) 
      { 
        gh.printPrimitiveRoutine("sub", "Subtract the top of the stack");
        $val = String.valueOf(Integer.parseInt($ex.val) - Integer.parseInt($ey.val));
      }
  |   ^(BECOMES id=IDENTIFIER ex=expression)  
      {
        gh.storeValue($id.text, $ex.val);
        $val = $ex.val;
        //TODO
//        System.out.println($id.text + ": " + $val);
      }
  |   ^(OR ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("or", "OR statement");
        $val = (!$ex.val.equals("0") && !$ex.val.equals("") || !$ey.val.equals("0") && !$ey.val.equals("")) ? "1" : "0";
      }
  |   ^(AND ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("and", "AND statement");
        $val = (!$ex.val.equals("0") && !$ex.val.equals("") && !$ey.val.equals("0") && !$ey.val.equals("")) ? "1" : "0";
      }
  |   ^(LT ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("lt", "Lesser than");
        $val = Integer.parseInt($ex.val) < Integer.parseInt($ey.val) ? "1" : "0";
      }
  |   ^(LE ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("le", "Lesser or equal to");
        $val = Integer.parseInt($ex.val) <= Integer.parseInt($ey.val) ? "1" : "0";
      }
  |   ^(GT ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("gt", "Greater than");
        $val = Integer.parseInt($ex.val) > Integer.parseInt($ey.val) ? "1" : "0";
      }
  |   ^(GE ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("ge", "Greater or equal to");
        $val = Integer.parseInt($ex.val) >= Integer.parseInt($ey.val) ? "1" : "0";
      }
  |   ^(EQ ex=expression ey=expression)
      {
        gh.loadLiteral("1");
        gh.printPrimitiveRoutine("eq", "Equal to");
        $val = $ex.val.equals($ey.val) ? "1" : "0";
      }
  |   ^(NEQ ex=expression ey=expression)
      {
        gh.loadLiteral("1");
        gh.printPrimitiveRoutine("ne", "Not equal to");
        $val = $ex.val.equals($ey.val) ? "0" : "1";
      }
  |   ^(TIMES ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("mult", "Multiplication");
        $val = String.valueOf(Integer.parseInt($ex.val) * Integer.parseInt($ey.val));
      }
  |   ^(DIVIDE ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("div", "Division");
        $val = String.valueOf(Integer.parseInt($ex.val) / Integer.parseInt($ey.val));
      }
  |   ^(MOD ex=expression ey=expression)
      {
        gh.printPrimitiveRoutine("mod", "Modulus");
        $val = String.valueOf(Integer.parseInt($ex.val) \% Integer.parseInt($ey.val));
      }
  |   ^(IF { gh.openScope(); }
            ex=compExpr 
            ({
              // Evaluate the if statement
              if($ex.val != null) {
                int exprSize = 1;
                int lastIndex = -2;
                while(lastIndex != -1){
                       lastIndex = $ex.val.indexOf(",", lastIndex+1);
                       if(lastIndex != -1){
                             exprSize++;
                      }
                }
                gh.printStatementCleanup("non-returning expression", exprSize);
              }
             }
            ex=compExpr)*                  
            { 
              // True expression
              label = gh.printStatementIf_Start();
              condition = $ex.val.equals("1"); 
            }
            ey=thenExpr         
            {
              // False expression
              gh.printStatementIf_End(label);
              $val = $ey.val;
              if($ey.val == null)
                gh.closeScope(0);
              else
                gh.closeScope(1);
            })
  |   ^(WHILE 
            { 
              // A WhileInfo object stores essential information that is injected into the code later
              WhileInfo info = gh.printStatementWhile_Start(); //Prints start of WHILE 
              gh.openScope(); 
            }
            ex=compExpr
            ({
              // Evaluate the expression
              if($ex.val != null) {
                int exprSize = 1;
                int lastIndex = -2;
                while(lastIndex != -1){
                       lastIndex = $ex.val.indexOf(",", lastIndex+1);
                       if(lastIndex != -1){
                             exprSize++;
                      }
                }
                gh.printStatementCleanup("non-returning expression", exprSize);
              }
            }
            ex=compExpr
            )*
            { 
              //Prints start of DO (needed for jumping)
              gh.printStatementWhile_Do(info);  
            }
            doExpr) 
            { 
              //Prints end of WHILE (needed for jumping)
              gh.printStatementWhile_End(info); 
              gh.closeScope(0); 
            }
  |   ^(READ r=readvar { $val = $r.val; }
            (readvar 
            { 
              gh.printStatementCleanup("read", 1);
              gh.printStatementCleanup("read", 1); 
              $val = null; 
            }
            (readvar 
            { 
              gh.printStatementCleanup("read", 1); 
            }
            )*)?)
  |   ^(PRINT p=printexpr { $val = $p.val; }
            (p=printexpr 
            {
						  int exprSize = 1;
						  int lastIndex = -2;
						  while(lastIndex != -1){
						    lastIndex = $val.indexOf(",", lastIndex+1);
						    if(lastIndex != -1){
						      exprSize++;
						    }
						  }
              gh.printStatementCleanup("print", exprSize);
						  
						  exprSize = 1;
						  lastIndex = -2;
						  while(lastIndex != -1){
						    lastIndex = $p.val.indexOf(",", lastIndex+1);
						    if(lastIndex != -1){
						      exprSize++;
						    }
						  } 
              gh.printStatementCleanup("print", exprSize); 
              $val = null;
            }
            (printexpr 
            {
						  exprSize = 1;
						  lastIndex = -2;
						  while(lastIndex != -1){
						    lastIndex = $p.val.indexOf(",", lastIndex+1);
						    if(lastIndex != -1){
						      exprSize++;
						    }
						  }
              gh.printStatementCleanup("print", exprSize); 
            }
            )*)?)
  |   ^(PRINTLN p=printexpr { $val = $p.val; }
            (p=printexpr 
            {
              int exprSize = 1;
              int lastIndex = -2;
              while(lastIndex != -1){
                lastIndex = $val.indexOf(",", lastIndex+1);
                if(lastIndex != -1){
                  exprSize++;
                }
              }
              gh.printStatementCleanup("print", exprSize);
              
              exprSize = 1;
              lastIndex = -2;
              while(lastIndex != -1){
                lastIndex = $p.val.indexOf(",", lastIndex+1);
                if(lastIndex != -1){
                  exprSize++;
                }
              } 
              gh.printStatementCleanup("print", exprSize); 
              $val = null;
            }
            (printexpr 
            {
              exprSize = 1;
              lastIndex = -2;
              while(lastIndex != -1){
                lastIndex = $p.val.indexOf(",", lastIndex+1);
                if(lastIndex != -1){
                  exprSize++;
                }
              }
              gh.printStatementCleanup("print", exprSize); 
            }
            )*)?)
            { 
              gh.printStatementPrint("\n"); 
            }
  |   ^(CCOMPEXPR { gh.openScope(); }
            cex=compExpr { $val = $cex.val; }
            ({
              if($val != null) {
                int exprSize = 1;
                int lastIndex = -2;
                while(lastIndex != -1){
                       lastIndex = $val.indexOf(",", lastIndex+1);
                       if(lastIndex != -1){
                             exprSize++;
                      }
                }
                gh.printStatementCleanup("non-returning expression", exprSize);
              }
            }
            cex=compExpr { $val = $cex.val; })*)
			      { 
			        if($val == null)
			          gh.closeScope(0);
		          else {
                int exprSize = 1;
                int lastIndex = -2;
                while(lastIndex != -1){
                       lastIndex = $val.indexOf(",", lastIndex+1);
                       if(lastIndex != -1){
                             exprSize++;
                      }
                }
		            gh.closeScope(exprSize);
	            }
			      }
  |   ^(ARRAY ex=expression { $val = $ex.val; } 
            (ex=expression 
            {
              $val = $val + "," + $ex.val; 
            })*)
  |   ^(TYPE id=IDENTIFIER n1=NUMBER n2=NUMBER)
      {
        gh.defineArray_Type($id.text, $n1.text, $n2.text);
      }
  |   op=operand 
      {
        $val = $op.val;
      }
  |   ^(ARRINDEX ex=expression { $val = $ex.val; } (ex=expression { $val += $ex.val; })*)
  ;

thenExpr returns [String val = null;]
  :   ^(THEN { gh.openScope(); } 
            ex=compExpr
            ({
              if($ex.val != null) {
                int exprSize = 1;
                int lastIndex = -2;
                while(lastIndex != -1){
                       lastIndex = $ex.val.indexOf(",", lastIndex+1);
                       if(lastIndex != -1){
                             exprSize++;
                      }
                }
                gh.printStatementCleanup("non-returning expression", exprSize);
              }
            }
            ex=compExpr
            )*
            {
				      if($ex.val == null)
				        gh.closeScope(0);
              else {
                int exprSize = 1;
                int lastIndex = -2;
                while(lastIndex != -1){
                       lastIndex = $ex.val.indexOf(",", lastIndex+1);
                       if(lastIndex != -1){
                             exprSize++;
                      }
                }
                gh.closeScope(exprSize);
              }
				      gh.printStatementIf_Else(label);
				    }
				    (ey=elseExpr)?)                     
				    {
				      if(condition)
				        $val = $ex.val;
				      else
				        $val = $ey.val;
				    }
  ;
  
elseExpr returns [String val = null;]
  :   ^(ELSE { gh.openScope(); } 
            ex=compExpr
            ({
              if($ex.val != null) {
                int exprSize = 1;
                int lastIndex = -2;
                while(lastIndex != -1){
                       lastIndex = $ex.val.indexOf(",", lastIndex+1);
                       if(lastIndex != -1){
                             exprSize++;
                      }
                }
                gh.printStatementCleanup("non-returning expression", exprSize);
              }
            }
            ex=compExpr
            )*
            {
              $val = $ex.val;
              if($ex.val == null)
                gh.closeScope(0);
              else
                gh.closeScope(1);
            })
  ;

doExpr returns [String val = null;]
  :   ^(DO { gh.openScope(); }
            (ex=compExpr
            {
              if($ex.val != null) {
                int exprSize = 1;
                int lastIndex = -2;
                while(lastIndex != -1){
                       lastIndex = $ex.val.indexOf(",", lastIndex+1);
                       if(lastIndex != -1){
                             exprSize++;
                      }
                }
                gh.printStatementCleanup("non-returning expression", exprSize);
              }
            })*)
						{
						  gh.closeScope(0);
						  gh.printStatementWhile_Cleanup();
						}
  ;

readvar returns [String val = null;]
  :   id=IDENTIFIER { gh.printStatementRead($id.text); $val = "1"; /*dummy value*/ }
  ;
  
printexpr returns [String val = null;]
  :   ex=expression { gh.printStatementPrint($ex.val); $val = $ex.val; }
  ;
  
operand returns [String val = null;]
  :   ^(id=IDENTIFIER { boolean arr = false; } 
            (ex=expression 
            {
              $val = gh.getValue($id.text, $ex.val);
              arr = true;
            })*
            par=paramuses?)
            { 
              if(!arr) $val = gh.getValue($id.text);
            } 
  |   TRUE          { $val = "1"; if(!gh.isConstantScope()) gh.loadLiteral($val); }
  |   FALSE         { $val = "0"; if(!gh.isConstantScope()) gh.loadLiteral($val); }
  |   n=NUMBER      { $val = String.valueOf(n); if(!gh.isConstantScope()) gh.loadLiteral($val); }
  |   ch=CHARACTER  { $val = $ch.text; if(!gh.isConstantScope()) gh.loadLiteral($val); }
  ;