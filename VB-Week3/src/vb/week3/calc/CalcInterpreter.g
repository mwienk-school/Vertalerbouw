// [file: CalcInterpreter.g, started: 22-Apr-2008]
//
// Calc - Simple calculator with memory variables.
// CalcInterpreter.g: interpreter
//
// @author   Theo Ruys
// @version  2008.04.22

tree grammar CalcInterpreter;

options {
    tokenVocab=Calc;                    // import tokens from Calc.tokens
    ASTLabelType=CommonTree;            // AST nodes are of type CommonTree
}

// Alter code generation so catch-clauses get replaced with this action. 
// This disables ANTLR error handling: CalcExceptions are propagated upwards.
@rulecatch { 
    catch (RecognitionException e) { 
        throw e; 
    } 
}

@header {
package vb.week3.calc;
import java.util.Map;
import java.util.HashMap;
}

@members { 
    private Map<String,Integer> store = new HashMap<String,Integer>(); 
    private int temp;  
}

program
    :   ^(PROGRAM (declaration* statement)+)
    ;
    
declaration
    :   ^(VAR id=IDENTIFIER type)
            { store.put($id.text, 0); 
              System.out.println($id + "declared");} 
    ;

statement
@init { int ix = input.index(); }
    :   ^(PRINT v=expr)
            { System.out.println("" + v);   }
    |   ^(SWAP id1=IDENTIFIER id2=IDENTIFIER)
            { int temp = store.get($id1.text); 
              store.put($id1.text, store.get($id2.text)); 
              store.put($id2.text, temp); }
    |   ^(DO ex=expr statement+)
            {  if(ex > 0) {
                 input.rewind(ix);
               }
            }
    |   expr
    ;
    
expr returns [int val = 0;]
    :   ^(IF c=expr e1=expr e2=expr) { if(c != 0) { val = e1; } else { val = e2; }}
    |   ^(BECOMES e1=expr)           { val = e1;}
    |   ^(OPERAND o=operand)         { val = o; }
    |   ^(OPERAND id=IDENTIFIER e1=expr) { temp = 0;
                                           store.put($id.text, e1); 
                                           val = e1; }
    |   ^(OPERAND n=NUMBER e1=expr) {  System.out.println(temp);
                                       val = e1;}
    |   ^(PLUS e1=expr)      { val = temp + e1; 
    System.out.println(temp);
     }
    |   ^(MINUS e1=expr)     { val = temp - e1;  }
    |   ^(TIMES e1=expr)     { val = temp * e1;  }
    |   ^(DIVIDE e1=expr)    { if(e2 == 0) throw new CalcException("ERROR: Division by zero!");
                                       val = e1 / e2;    }
    |   ^(LESS e1=expr)      { if(e1 < e2)  val = 1; else val = 0; }
    |   ^(LESSEQ e1=expr)    { if(e1 <= e2) val = 1; else val = 0; }
    |   ^(MORE e1=expr)      { if(e1 > e2)  val = 1; else val = 0; }
    |   ^(MOREEQ e1=expr)    { if(e1 >= e2) val = 1; else val = 0; }
    |   ^(EQ e1=expr)        { if(e1 == e2) val = 1; else val = 0; }
    |   ^(NEQ e1=expr)       { if(e1 != e2) val = 1; else val = 0; }
    ;
    
operand returns [int val = 0]
    :   id=IDENTIFIER                       { val = store.get($id.text);       } 
    |   n=NUMBER                            { val = Integer.parseInt($n.text); }
    ;
    
type
    :   INTEGER
    ;
