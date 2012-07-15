java org.antlr.Tool src\grammar\Grammar.g
java org.antlr.Tool src\grammar\GrammarChecker.g
java org.antlr.Tool src\grammar\GrammarCodeGenerator.g
xcopy *.tokens src\grammar\*.tokens /Y
del *.tokens
javac src\register\*.java
javac src\symbolTable\*.java
javac src\myTree\*.java
javac src\codeStack\*.java
javac src\heapManager\*.java
javac src\grammar\*.java
javac src\checker\*.java
javac TAM\*.java