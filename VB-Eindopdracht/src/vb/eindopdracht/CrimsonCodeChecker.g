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
  };
}
program
  :   ^(PROGRAM compExpr+)
  ;

compExpr
  :   ^(CONST id=IDENTIFIER expression)
        {
            String[] str = $id.text.split("(?<!(^|[A-Z]))(?=[A-Z])|(?<!^)(?=[A-Z][a-z])");
            if(tokenSuffix.containsKey(str[str.length-1])) {
              //Instantiate the constant as it's type entry
              IdEntry constant = (IdEntry) Class.forName(tokenSuffix.get(str[str.length-1])).newInstance();
              symbolTable.enter($id.text, constant);
            } else {
              throw new Exception("The declared constant type " + $id.text + " is an unknown type.");
            }
        }
  |   ^(VAR id=IDENTIFIER)
        {
            String[] str = $id.text.split("(?<!(^|[A-Z]))(?=[A-Z])|(?<!^)(?=[A-Z][a-z])");
            if(tokenSuffix.containsKey(str[str.length-1])) {
              //Instantiate the variable as it's type entry
              IdEntry var = (IdEntry) Class.forName(tokenSuffix.get(str[str.length-1])).newInstance();
              symbolTable.enter($id.text, var);
            } else {
              throw new Exception("The declared variable type " + $id.text + "  is an unknown type.");
            }
        }
  |    ^(PROC id=IDENTIFIER
        {
            symbolTable.openScope();
        } param+ expression
        {
            symbolTable.closeScope();
        })
        {
            String[] str = $id.text.split("(?<!(^|[A-Z]))(?=[A-Z])|(?<!^)(?=[A-Z][a-z])");
            if(str[str.length-1].equals("ProcEntry")) {
              //Instantiate the procedure in the symboltable
              ProcEntry proc = new ProcEntry();
              symbolTable.enter($id.text, proc);
            } else {
              throw new Exception("The declared function type " + $id.text + "  is an unknown type.");
            }
        }
  |    ^(FUNC id=IDENTIFIER
        {
            symbolTable.openScope();
        } param+ expression
        {
            symbolTable.closeScope();
        })
        {
            String[] str = $id.text.split("(?<!(^|[A-Z]))(?=[A-Z])|(?<!^)(?=[A-Z][a-z])");
            if(str[str.length-1].equals("Func")) {
              if(tokenSuffix.containsKey(str[str.length-2])) {
                //Instantiate the function in the symboltable
                FuncEntry func = new FuncEntry();
                func.setReturnType(str[str.length-2]);
                symbolTable.enter($id.text, func);
              }
            } else {
              throw new Exception("The declared procedure type " + $id.text + "  is an unknown type.");
            }
        }
  |   expression
  ;

param
  :   ^(PARAM id=IDENTIFIER)
        {
            String[] str = $id.text.split("(?<!(^|[A-Z]))(?=[A-Z])|(?<!^)(?=[A-Z][a-z])");
            if(tokenSuffix.containsKey(str[str.length-1])) {
              //Instantiate the parameter as it's type entry
              IdEntry param = (IdEntry) Class.forName(tokenSuffix.get(str[str.length-1])).newInstance();
              symbolTable.enter($id.text, param);
            } else {
              throw new Exception("The declared parameter type " + $id.text + "  is an unknown type.");
            }
        }
  |   ^(VAR id=IDENTIFIER)
        {
            String[] str = $id.text.split("(?<!(^|[A-Z]))(?=[A-Z])|(?<!^)(?=[A-Z][a-z])");
            if(tokenSuffix.containsKey(str[str.length-1])) {
              //Instantiate the parameter as it's type entry
              IdEntry parameter = (IdEntry) Class.forName(tokenSuffix.get(str[str.length-1])).newInstance();
              symbolTable.enter($id.text, parameter);
            } else {
              throw new Exception("The declared parameter type " + $id.text + "  is an unknown type.");
            }
        }
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