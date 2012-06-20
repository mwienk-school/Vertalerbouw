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
}


//Parser regels

program
  :
  ;