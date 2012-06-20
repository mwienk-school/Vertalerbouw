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
  private static SymbolTable<IdEntry> symbolTable;
  private static HashMap<String, String> tokenSuffix;
  static {
    symbolTable = new SymbolTable<IdEntry>();
    symbolTable.openScope();
    tokenSuffix = new HashMap<String, String>();
    tokenSuffix.put("Pill", "vb.eindopdracht.symboltable.BooleanEntry");
    tokenSuffix.put("Int", "vb.eindopdracht.symboltable.IntEntry");
    tokenSuffix.put("Char", "vb.eindopdracht.symboltable.CharEntry");
    tokenSuffix.put("Array", "vb.eindopdracht.symboltable.CharEntry");
    tokenSuffix.put("Proc", "vb.eindopdracht.symboltable.ProcEntry");
    tokenSuffix.put("Func", "vb.eindopdracht.symboltable.FuncEntry");
    
  };
  
  private static IdEntry processEntry(String identifier) throws Exception {
    String[] str = identifier.split("(?<!(^|[A-Z]))(?=[A-Z])|(?<!^)(?=[A-Z][a-z])");
    if(tokenSuffix.containsKey(str[str.length-1])) {
      Constructor constructor = Class.forName(tokenSuffix.get(str[str.length-1])).getConstructor(String.class);
      IdEntry entry = (IdEntry) constructor.newInstance(str[str.length-2]);
      symbolTable.enter(identifier, entry);
      return entry;
    } else {
      throw new Exception("The declared type of " + identifier + "(" + str[str.length-1] + ") is an unknown type.");
    }
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
        } param+ expression
        {
            symbolTable.closeScope();
        })                              { processEntry($id.text); }
  |   ^(FUNC id=IDENTIFIER
        {
            symbolTable.openScope();
        } param+ expression
        {
            symbolTable.closeScope();
        })                              { processEntry($id.text); }
  |   expression
  ;

param
  :   ^(PARAM id=IDENTIFIER) { processEntry($id.text); }
  |   ^(VAR id=IDENTIFIER)   { processEntry($id.text); }
  ;
  
expression
  :   ^(UPLUS expression)
  |   ^(UMINUS expression)
  |   ^(PLUS expression expression)
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
  |   ^(IF expression expression expression)
  |   ^(WHILE expression expression)
  |   ^(READ varlist)
  |   ^(PRINT exprlist)
  |   ^(CCOMPEXPR { symbolTable.openScope(); } compExpr+ { symbolTable.closeScope(); })
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
  :   id=IDENTIFIER
      {
        if(symbolTable.retrieve($id.text) == null)
          throw new Exception($id.text + " is not declared.");
      }
  |   TRUE
  |   FALSE
  |   NUMBER
  ;