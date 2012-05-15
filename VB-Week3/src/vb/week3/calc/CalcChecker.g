tree grammar CalcChecker;

options {
    tokenVocab=Calc;                    // import tokens from Calc.tokens
    ASTLabelType=CommonTree;            // AST nodes are of type CommonTree
}

@header {
package vb.week3.calc;
import java.util.Set;
import java.util.HashSet;
}

// Alter code generation so catch-clauses get replaced with this action. 
// This disables ANTLR error handling: CalcExceptions are propagated upwards.
@rulecatch { 
    catch (RecognitionException e) { 
        throw e; 
    } 
}

@members {
    // idset - a set of declared identifiers.
    private Set<String> idset = new HashSet<String>();   
    
    public boolean  isDeclared(String s)     { return idset.contains(s); }
    public void     declare(String s)        { idset.add(s);             }
}

program
    :   ^(PROGRAM (declaration* statement)+)
    ;
    
declaration
    :   ^(VAR id=IDENTIFIER type)
        { if (isDeclared($id.text)) 
               throw new CalcException($id, "is already declared");
          else
               declare($id.getText());
        }
    ;
    
statement
    :   ^(PRINT expr)
    |   ^(SWAP IDENTIFIER IDENTIFIER)
    |   ^(DO expr statement+)
    |   expr
    ;

        
expr
    :   ^(IF expr expr expr)
    |   ^(BECOMES expr)
    |   ^(OPERAND operand expr?)   
    |   ^(PLUS expr)
    |   ^(MINUS expr)
    |   ^(TIMES expr)
    |   ^(DIVIDE expr)
    |   ^(LESS expr)
    |   ^(LESSEQ expr)
    |   ^(MORE expr)
    |   ^(MOREEQ expr)
    |   ^(EQ expr)
    |   ^(NEQ expr)
    ;
    
operand
    :   id=IDENTIFIER 
        {   if (!isDeclared($id.text))
                throw new CalcException($id, "is not declared");
        }
    |   n=NUMBER 
    ;
    
type
    :   INTEGER
    ;
