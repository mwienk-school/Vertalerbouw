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
}

program
    :   ^(PROGRAM (declaration | statement)+)
    ;
    
declaration
    :   ^(VAR id=IDENTIFIER type)
            { store.put($id.text, 0); } 
    ;

statement 
    :   ^(BECOMES id=IDENTIFIER v=expr)
            { store.put($id.text, v);       }
    |   ^(PRINT v=expr)
            { System.out.println("" + v);   }            
    |   ^(SWAP id1=IDENTIFIER id2=IDENTIFIER)
            { int temp = store.get($id1.text); store.put($id1.text, store.get($id2.text)); store.put($id2.text, temp); }
    ;
    
expr returns [int val = 0;] 
    :   z=operand               { val = z;      }
    |   ^(PLUS x=expr y=expr)   { val = x + y;  }
    |   ^(MINUS x=expr y=expr)  { val = x - y;  }
    |   ^(TIMES x=expr y=expr)  { val = x * y;  }
    |   ^(DIVIDE x=expr y=expr) { if(y == 0) throw new CalcException("ERROR: Division by zero!");
                                  val = x / y;
                                }
    |   ^(IF c=expr e1=expr e2=expr) { if(c != 0) { val = e1; } else { val = e2; }}
    |   ^(LESS e1=expr e2=expr) { if(e1 < e2) val = 1; else val = 0; }
    |   ^(LESSEQ e1=expr e2=expr) { if(e1 <= e2) val = 1; else val = 0; }
    |   ^(MORE e1=expr e2=expr) { if(e1 > e2) val = 1; else val = 0; }
    |   ^(MOREEQ e1=expr e2=expr) { if(e1 >= e2) val = 1; else val = 0; }
    |   ^(EQ e1=expr e2=expr) { if(e1 == e2) val = 1; else val = 0; }
    |   ^(NEQ e1=expr e2=expr) { if(e1 != e2) val = 1; else val = 0; }
    ;
    
operand returns [int val = 0]
    :   id=IDENTIFIER   { val = store.get($id.text);       } 
    |   n=NUMBER        { val = Integer.parseInt($n.text); }
    |   ^(BECOMES id=IDENTIFIER v=expr) { store.put($id.text, v); val = v; }
    ;
    
type
    :   INTEGER
    ;
