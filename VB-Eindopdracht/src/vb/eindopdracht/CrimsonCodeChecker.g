tree grammar CrimsonCodeChecker;

options {
    tokenVocab=CrimsonCodeGrammar;
    ASTLabelType=CommonTree;
}

@header {
  package vb.eindopdracht;
  import java.util.Map;
  import java.util.HashMap;
  import vb.eindopdracht.symboltable.*;
  import java.lang.reflect.Constructor;
}

@rulecatch { 
    catch (Exception e) { 
        System.err.println("ERROR:");
        e.printStackTrace(); 
    } 
}

@members {
  //TODO: Met live private maken (dit is alleen voor debug public)
  public static SymbolTable<IdEntry> symbolTable;
  private static HashMap<String, String> tokenSuffix;
  private static HashMap<String, String> dynamicTypes;
  static {
    symbolTable = new SymbolTable<IdEntry>();
    symbolTable.openScope();
    tokenSuffix = new HashMap<String, String>();
    tokenSuffix.put("Pill", "vb.eindopdracht.symboltable.BooleanEntry");
    tokenSuffix.put("Int", "vb.eindopdracht.symboltable.IntEntry");
    tokenSuffix.put("Char", "vb.eindopdracht.symboltable.CharEntry");
    tokenSuffix.put("Proc", "vb.eindopdracht.symboltable.ProcEntry");
    tokenSuffix.put("Func", "vb.eindopdracht.symboltable.FuncEntry");
  };
  
  private static IdEntry processEntry(String identifier) throws Exception {
    String[] str = identifier.split("(?<!(^|[A-Z]))(?=[A-Z])|(?<!^)(?=[A-Z][a-z])");
    String lastPart = "";
    for(int i = 1; i < str.length; i++) {
      lastPart = str[str.length-i] + lastPart;
      if(tokenSuffix.containsKey(lastPart.toString())) {
        Constructor constructor = Class.forName(tokenSuffix.get(lastPart.toString())).getConstructor(String.class);
        IdEntry entry = (IdEntry) constructor.newInstance(str[str.length-(i+1)]);
        symbolTable.enter(identifier, entry);
        return entry;
      }
    }
    //Type isn't found.
    throw new Exception("The declared type of " + identifier + "(" + lastPart + ") is an unknown type.");
  }
  
  private static void processDynamicType(String identifier) throws Exception {
    String[] str = identifier.split("(?<!(^|[A-Z]))(?=[A-Z])|(?<!^)(?=[A-Z][a-z])");
    //Uppercase the first letter so it can be seen as a type
    identifier = identifier.substring(0,1).toUpperCase() + identifier.substring(1);
    if("Array".equals(str[str.length-1])) tokenSuffix.put(identifier,"vb.eindopdracht.symboltable.ArrayEntry");
    //TODO: record nog niet goed (kan maar 1 type aan).
    if("Record".equals(str[str.length-1])) tokenSuffix.put(identifier,"vb.eindopdracht.symboltable.ArrayEntry");
  }
}
program
  :   ^(PROGRAM compExpr+)
  ;

compExpr
  :   ^(CONST id=IDENTIFIER expression) { processEntry($id.text); }
  |   ^(VAR id=IDENTIFIER)              { processEntry($id.text); }
  |   ^(PROC id=IDENTIFIER 
        {
            symbolTable.openScope();
        } paramdecl+ expression
        {
            symbolTable.closeScope();
        })                              { processEntry($id.text); }
  |   ^(FUNC id=IDENTIFIER
        {
            symbolTable.openScope();
        } paramdecl+ expression
        {
            symbolTable.closeScope();
        })                              { processEntry($id.text); }
  |   expression
  ;

paramdecl
  :   ^(PARAM id=IDENTIFIER) { processEntry($id.text); }
  |   ^(VAR id=IDENTIFIER)   { processEntry($id.text); }
  ;

paramuse
  :   ^(PARAM id=IDENTIFIER)
        {
	        if(symbolTable.retrieve($id.text) == null)
	          throw new Exception($id.text + " is not declared.");
	      }
  |   ^(VAR id=IDENTIFIER)
        {
	        if(symbolTable.retrieve($id.text) == null)
	          throw new Exception($id.text + " is not declared.");
	      }
  ;
  
expression returns [String val = null;]
  :   ^(NEG ex=expression)
      {
        if($ex.text.equals("boolean"))
          retval.val = "boolean";
        else
          throw new Exception("Boolean expression expected, " + $ex.text + " expression found.");
      }
  |   ^(UPLUS ex=expression)
      {
        if($ex.text.equals("integer"))
          retval.val = "integer";
        else
          throw new Exception("Integer expression expected, " + $ex.text + " expression found.");
      }
  |   ^(UMINUS ex=expression)
      {
        if($ex.text.equals("integer"))
          retval.val = "integer";
        else
          throw new Exception("Integer expression expected, " + $ex.text + " expression found.");
      }
  |   ^(PLUS e1=expression e2=expression)
  |   ^(MINUS expression expression)
  |   ^(BECOMES id=IDENTIFIER expression)
      {
        if(symbolTable.retrieve($id.text) == null)
          throw new Exception($id.text + " is not declared.");
      }
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
  |   ^(MOD expression expression)
  |   ^(IF expression expression expression)
  |   ^(WHILE expression expression)
  |   ^(READ varlist)
  |   ^(PRINT exprlist)
  |   ^(CCOMPEXPR { symbolTable.openScope(); } compExpr+ { symbolTable.closeScope(); })
  |   ^(ARRAY expression+)
  |   ^(TYPE id=IDENTIFIER NUMBER NUMBER)                { processDynamicType($id.text); }
  |   operand
  ;
  
exprlist
  :   expression+
  ;
  
varlist
  :   id=IDENTIFIER+
      {
        if(symbolTable.retrieve($id.text) == null)
          throw new Exception($id.text + " is not declared.");
      }
  ;
  
operand 
  :   ^(id=IDENTIFIER
      { 
        if(symbolTable.retrieve($id.text) == null)
          throw new Exception($id.text + " is not declared.");
      } expression* paramuse*)
  |   TRUE
  |   FALSE
  |   NUMBER
  ;
