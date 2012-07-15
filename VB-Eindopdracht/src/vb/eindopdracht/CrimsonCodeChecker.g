tree grammar CrimsonCodeChecker;

options {
    tokenVocab=CrimsonCodeGrammar;
    ASTLabelType=CommonTree;
}

@header {
  package vb.eindopdracht;
  import vb.eindopdracht.helpers.CheckerHelper;
  import vb.eindopdracht.symboltable.ProcEntry;
  import vb.eindopdracht.symboltable.IdEntry;
  import vb.eindopdracht.symboltable.FuncEntry;
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

compExpr returns [String type = null;]
  :   ^(CONST id=IDENTIFIER ex=expression) { ch.processConstantEntry($id.text, $ex.type); $type = "no_type"; }
  |   ^(VAR id=IDENTIFIER)              { ch.processEntry($id.text); $type = "no_type"; }
  |   ^(PROC id=IDENTIFIER              {
                                          ProcEntry pe = (ProcEntry)ch.processEntry($id.text);
                                          ch.symbolTable.openScope();
                                        }
            par=paramdecls expression   {
                                          $type = "no_type";
                                          pe.setParameters($par.paramList);
                                          ch.symbolTable.closeScope();
                                        })
  |   ^(FUNC id=IDENTIFIER              {
                                          FuncEntry fe = (FuncEntry) ch.processEntry($id.text);
                                          ch.symbolTable.openScope();
                                        }
            par=paramdecls ex=expression    {
                                          $type = "no_type";
                                          fe.setReturnType($ex.type);
                                          fe.setParameters($par.paramList);
                                          ch.symbolTable.closeScope();
                                        })
  |   ^(TYPE id=IDENTIFIER n1=NUMBER n2=NUMBER)     { ch.processDynamicType($id.text, $n1.text, $n2.text); $type = "no_type"; }
  |   ex=expression                     { $type = $ex.type; }
  ;
  
paramdecls returns [ArrayList<String> paramList = new ArrayList<String>();]
  :   (p=paramdecl { paramList.add($p.type); } par=paramdecls { paramList.addAll($par.paramList); })?
  ;

paramdecl returns [String type = null;]
  :   ^(PARAM id=IDENTIFIER)            { ch.processEntry($id.text); $type = ch.getType($id.text); }
  |   ^(VAR id=IDENTIFIER)              { ch.processEntry($id.text); $type = "variable " + ch.getType($id.text); }
  ;

paramuses returns [ArrayList<String> paramList = new ArrayList<String>();]
  :   (p=paramuse { paramList.add($p.type); } par=paramuses { paramList.addAll($par.paramList); })?
  ;
paramuse returns [String type = null;]
  :   ^(PARAM id=IDENTIFIER)
        {
	        if(ch.symbolTable.retrieve($id.text) == null)
	          throw new Exception($id.text + " is not declared.");
	        else
	          $type = ch.getType($id.text);
	      }
  |   ^(VAR id=IDENTIFIER)
        {
	        if(ch.symbolTable.retrieve($id.text) == null)
	          throw new Exception($id.text + " is not declared.");
          else
            $type = "variable " + ch.getType($id.text);
	      }
  ;
  
expression returns [String type = null;]
  :   ^(NEG ex=expression)                    { $type = ch.checkType("Pill", $ex.type); }
  |   ^(UPLUS ex=expression)                  { $type = ch.checkType("Int", $ex.type); }
  |   ^(UMINUS ex=expression)                 { $type = ch.checkType("Int", $ex.type); }
  |   ^(PLUS e1=expression e2=expression)     { $type = ch.checkType("Int", $e1.type); $type = ch.checkType($type, $e2.type); }
  |   ^(MINUS e1=expression e2=expression)    { $type = ch.checkType("Int", $e1.type); $type = ch.checkType($type, $e2.type); }
  |   ^(BECOMES id=IDENTIFIER ex=expression)  { $type = ch.processAssignment($id.text, $ex.type); }
  |   ^(OR e1=expression e2=expression)       { $type = ch.checkType("Pill", $e1.type); $type = ch.checkType($type, $e2.type); }
  |   ^(AND e1=expression e2=expression)      { $type = ch.checkType("Pill", $e1.type); $type = ch.checkType($type, $e2.type); }
  |   ^(LT e1=expression e2=expression)       { ch.checkType("Int", $e1.type); ch.checkType("Int", $e2.type); $type = "Pill"; }
  |   ^(LE e1=expression e2=expression)       { ch.checkType("Int", $e1.type); ch.checkType("Int", $e2.type); $type = "Pill"; }
  |   ^(GT e1=expression e2=expression)       { ch.checkType("Int", $e1.type); ch.checkType("Int", $e2.type); $type = "Pill"; }
  |   ^(GE e1=expression e2=expression)       { ch.checkType("Int", $e1.type); ch.checkType("Int", $e2.type); $type = "Pill"; }
  |   ^(EQ e1=expression e2=expression)       { ch.checkType($e1.type, $e2.type); $type = "Pill"; }
  |   ^(NEQ e1=expression e2=expression)      { ch.checkType($e1.type, $e2.type); $type = "Pill"; }
  |   ^(TIMES e1=expression e2=expression)    { $type = ch.checkType("Int", $e1.type); $type = ch.checkType($type, $e2.type); }
  |   ^(DIVIDE e1=expression e2=expression)   { $type = ch.checkType("Int", $e1.type); $type = ch.checkType($type, $e2.type); }
  |   ^(MOD e1=expression e2=expression)      { $type = ch.checkType("Int", $e1.type); $type = ch.checkType($type, $e2.type); }
  |   ^(IF                                    { ch.symbolTable.openScope(); }
            e1=compExpr* e2=thenExpr)         {
                                                ch.checkType("Pill", $e1.type);
                                                $type = $e2.type;
                                                ch.symbolTable.closeScope();
                                              }
  |   ^(WHILE                                 { ch.symbolTable.openScope(); }
            e1=compExpr* doExpr)              {
                                                ch.checkType("Pill", $e1.type);
                                                $type = "void";
                                                ch.symbolTable.closeScope();
                                              }
  |   ^(READ id=IDENTIFIER { $type = ch.getReadType($id.text); } (id=IDENTIFIER { ch.checkDeclared($id.text); $type = "void"; })*)
  |   ^(PRINT ex=expression                   {
                                                $type = $ex.type;
                                                if("void".equals($ex.type))
                                                  throw new Exception("Can't print void expression");
                                              }
            (ex=expression                    {
                                                $type = "void";
                                                if("void".equals($ex.type))
                                                  throw new Exception("Can't print void expression");
                                              })*)
  |   ^(PRINTLN ex=expression                   {
                                                $type = $ex.type;
                                                if("void".equals($ex.type))
                                                  throw new Exception("Can't print void expression");
                                              }
            (ex=expression                    {
                                                $type = "void";
                                                if("void".equals($ex.type))
                                                  throw new Exception("Can't print void expression");
                                              })*)
  |   ^(CCOMPEXPR { ch.symbolTable.openScope(); } (ce=compExpr { $type = $ce.type; })+ { ch.symbolTable.closeScope(); })
  |   ^(ARRAY ex=expression 
               { 
                 int n = 1; $type = $ex.type; 
               } 
             (ex=expression { 
                 ch.checkType($type, $ex.type); 
                 n++; 
               })*
       ) 
       { 
        $type = $type + "Array[" + n + "]"; 
       }
  |   op=operand                              { $type = $op.type; }
  ;
  
thenExpr returns [String type = null;]
  :   ^(THEN                                  { ch.symbolTable.openScope(); }
            e1=compExpr*                      { ch.symbolTable.closeScope(); }
            (e2=elseExpr)?)                   {
                                                try {
                                                  $type = ch.checkType($e1.type, $e2.type);
                                                }
                                                catch(Exception e) {
                                                  $type = "void";
                                                }
                                              }
  ;

elseExpr returns [String type = null;]
  :   ^(ELSE                                  { ch.symbolTable.openScope(); }
            e1=compExpr*)                     { $type = $e1.type; ch.symbolTable.closeScope(); }
  ;
  
doExpr returns [String type = null;]
  :   ^(DO { ch.symbolTable.openScope(); } e2=compExpr* { ch.symbolTable.closeScope(); })
  ;
  
operand returns [String type = null;]
  :   ^(id=IDENTIFIER                         { $type = ch.getType($id.text); }
            expression* par=paramuses         {
                                                if($par.paramList.size() > 0) {
	                                                ch.checkParameters($id.text, $par.paramList);
	                                              }
                                              })
  |   TRUE              { $type = "Pill"; }
  |   FALSE             { $type = "Pill"; }
  |   NUMBER            { $type = "Int"; }
  |   CHARACTER         { $type = "Char"; }
  ;
