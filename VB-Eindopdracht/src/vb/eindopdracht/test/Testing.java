package vb.eindopdracht.test;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

import junit.framework.TestCase;

public class Testing extends TestCase {
	private final ByteArrayOutputStream outContent = new ByteArrayOutputStream();
	private final ByteArrayOutputStream errContent = new ByteArrayOutputStream();

	public void setUp() {
	    System.setOut(new PrintStream(outContent));
	    System.setErr(new PrintStream(errContent));
	}
	
	public void testWhile01() {
		try {
			new Tester("src/vb/eindopdracht/test/while/while01");
			assertEquals(
					"          PUSH              1 ; Push variable eenInt\n" +
					"          PUSH              1 ; Push variable tweeInt\n" +
					"          LOADL            50 ; Load literal value '50'\n" +
					"          STORE(1)      0[SB] ; Store in variable eenInt\n" +
					"          LOAD(1)       0[SB] ; Load the variable address\n" +
					"          LOADL            50 ; Load literal value '50'\n" +
					"          CALL            div ; Division\n" +
					"          STORE(1)      1[SB] ; Store in variable tweeInt\n" +
					"While0:   LOAD(1)       0[SB] ; Load the variable address\n" +
					"          LOAD(1)       1[SB] ; Load the variable address\n" +
					"          CALL             lt ; Lesser than\n" +
					"          JUMPIF(0)  End0[CB] ; Jump past body\n" +
					"          LOAD(1)       0[SB] ; Load the variable address\n" +
					"          CALL         putint ; Print the int value on top of the stack\n" +
					"          CALL         puteol ; Print a newline to the stdout\n" +
					"          LOAD(1)       0[SB] ; Load the variable address\n" +
					"          LOADL             1 ; Load literal value '1'\n" +
					"          CALL            sub ; Subtract the top of the stack\n" +
					"          STORE(1)      0[SB] ; Store in variable eenInt\n" +
					"          JUMP      While0[CB] ; Jump to WHILE-expression\n" +
					"End0:     POP(0)            2 ; Pop 2 variables\n" +
					"          HALT                ; End of program\n", outContent.toString());
		} catch (Exception e) {
			fail();
		}
	}
	
	//TODO
	public void testWhile02() {
		try {
			new Tester("src/vb/eindopdracht/test/while/while02");
			//Test moet falen, maar kan pas als checker goed werkt.
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	//TODO
	public void testProc1() {
		try {
			new Tester("src/vb/eindopdracht/test/proc/proc1");
		} catch (Exception e) {
			fail();
		}
	}
	
	public void testStandard1() {
		try {
			new Tester("src/vb/eindopdracht/test/standard/standard1");
			assertEquals(
			"          PUSH              1 ; Push variable eenInt\n" +
			"          PUSH              1 ; Push variable eenPill\n"+
			"          LOADL             1 ; Load literal value '1'\n"+
			"          STORE(1)      1[SB] ; Store in variable eenPill\n"+
			"          LOADL            10 ; Load literal value '10'\n"+
			"          STORE(1)      0[SB] ; Store in variable eenInt\n"+
			"While0:   LOAD(1)       1[SB] ; Load the variable address\n"+
			"          JUMPIF(0)  End0[CB] ; Jump past body\n"+
			"          LOAD(1)       0[SB] ; Load the variable address\n"+
			"          CALL         putint ; Print the int value on top of the stack\n"+
			"          LOADL            32 ; Load literal value '32'\n"+
			"          CALL            put ; Print the value on top of the stack\n"+
			"          LOAD(1)       0[SB] ; Load the variable address\n"+
			"          LOADL             1 ; Load literal value '1'\n"+
			"          CALL            sub ; Subtract the top of the stack\n"+
			"          STORE(1)      0[SB] ; Store in variable eenInt\n"+
			"          LOAD(1)       0[SB] ; Load the variable address\n"+
			"          LOADL             1 ; Load literal value '1'\n"+
			"          LOADL             1 ; Load literal value '1'\n"+
			"          CALL             eq ; Equal to\n"+
			"          JUMPIF(0) Else1[CB] ; Jump to ELSE\n"+
			"          LOADL             0 ; Load literal value '0'\n"+
			"          STORE(1)      1[SB] ; Store in variable eenPill\n"+
			"          JUMP       End1[CB] ; Jump over ELSE\n"+
			"Else1:    JUMP       End1[CB] ; Jump to End, no Else clause\n"+
			"End1:     JUMP      While0[CB] ; Jump to WHILE-expression\n"+
			"End0:     POP(0)            2 ; Pop 2 variables\n"+
			"          HALT                ; End of program\n", 
			outContent.toString());
		} catch (Exception e) {
			fail();
		}
	}
	
	public void testStandard2() {
		try {
			new Tester("src/vb/eindopdracht/test/standard/standard2");
			assertEquals("ERROR:\n"+
"java.lang.Exception: Int expression expected, Pill expression found.\n"+
"	at vb.eindopdracht.helpers.CheckerHelper.checkType(CheckerHelper.java:31)\n"+
"	at vb.eindopdracht.CrimsonCodeChecker.expression(CrimsonCodeChecker.java:872)\n"+
"	at vb.eindopdracht.CrimsonCodeChecker.expression(CrimsonCodeChecker.java:885)\n"+
"	at vb.eindopdracht.CrimsonCodeChecker.compExpr(CrimsonCodeChecker.java:434)\n"+
"	at vb.eindopdracht.CrimsonCodeChecker.expression(CrimsonCodeChecker.java:1422)\n"+
"	at vb.eindopdracht.CrimsonCodeChecker.expression(CrimsonCodeChecker.java:1243)\n"+
"	at vb.eindopdracht.CrimsonCodeChecker.compExpr(CrimsonCodeChecker.java:434)\n"+
"	at vb.eindopdracht.CrimsonCodeChecker.program(CrimsonCodeChecker.java:135)\n"+
"	at vb.eindopdracht.test.Tester.<init>(Tester.java:32)\n"+
"	at vb.eindopdracht.test.Testing.testStandard2(Testing.java:105)\n"+
"	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\n"+
"	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)\n"+
"	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\n"+
"	at java.lang.reflect.Method.invoke(Method.java:601)\n"+
"	at junit.framework.TestCase.runTest(TestCase.java:164)\n"+
"	at junit.framework.TestCase.runBare(TestCase.java:130)\n"+
"	at junit.framework.TestResult$1.protect(TestResult.java:106)\n"+
"	at junit.framework.TestResult.runProtected(TestResult.java:124)\n"+
"	at junit.framework.TestResult.run(TestResult.java:109)\n"+
"	at junit.framework.TestCase.run(TestCase.java:120)\n"+
"	at junit.framework.TestSuite.runTest(TestSuite.java:230)\n"+
"	at junit.framework.TestSuite.run(TestSuite.java:225)\n"+
"	at org.eclipse.jdt.internal.junit.runner.junit3.JUnit3TestReference.run(JUnit3TestReference.java:130)\n"+
"	at org.eclipse.jdt.internal.junit.runner.TestExecution.run(TestExecution.java:38)\n"+
"	at org.eclipse.jdt.internal.junit.runner.RemoteTestRunner.runTests(RemoteTestRunner.java:467)\n"+
"	at org.eclipse.jdt.internal.junit.runner.RemoteTestRunner.runTests(RemoteTestRunner.java:683)\n"+
"	at org.eclipse.jdt.internal.junit.runner.RemoteTestRunner.run(RemoteTestRunner.java:390)\n"+
"	at org.eclipse.jdt.internal.junit.runner.RemoteTestRunner.main(RemoteTestRunner.java:197)\n"+
"ERROR:\n"+
"java.lang.NullPointerException\n"+
"	at vb.eindopdracht.helpers.CheckerHelper.processAssignment(CheckerHelper.java:73)\n"+
"	at vb.eindopdracht.CrimsonCodeChecker.expression(CrimsonCodeChecker.java:893)\n"+
"	at vb.eindopdracht.CrimsonCodeChecker.compExpr(CrimsonCodeChecker.java:434)\n"+
"	at vb.eindopdracht.CrimsonCodeChecker.expression(CrimsonCodeChecker.java:1422)\n"+
"	at vb.eindopdracht.CrimsonCodeChecker.expression(CrimsonCodeChecker.java:1243)\n"+
"	at vb.eindopdracht.CrimsonCodeChecker.compExpr(CrimsonCodeChecker.java:434)\n"+
"	at vb.eindopdracht.CrimsonCodeChecker.program(CrimsonCodeChecker.java:135)\n"+
"	at vb.eindopdracht.test.Tester.<init>(Tester.java:32)\n"+
"	at vb.eindopdracht.test.Testing.testStandard2(Testing.java:105)\n"+
"	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\n"+
"	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)\n"+
"	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\n"+
"	at java.lang.reflect.Method.invoke(Method.java:601)\n"+
"	at junit.framework.TestCase.runTest(TestCase.java:164)\n"+
"	at junit.framework.TestCase.runBare(TestCase.java:130)\n"+
"	at junit.framework.TestResult$1.protect(TestResult.java:106)\n"+
"	at junit.framework.TestResult.runProtected(TestResult.java:124)\n"+
"	at junit.framework.TestResult.run(TestResult.java:109)\n"+
"	at junit.framework.TestCase.run(TestCase.java:120)\n"+
"	at junit.framework.TestSuite.runTest(TestSuite.java:230)\n"+
"	at junit.framework.TestSuite.run(TestSuite.java:225)\n"+
"	at org.eclipse.jdt.internal.junit.runner.junit3.JUnit3TestReference.run(JUnit3TestReference.java:130)\n"+
"	at org.eclipse.jdt.internal.junit.runner.TestExecution.run(TestExecution.java:38)\n"+
"	at org.eclipse.jdt.internal.junit.runner.RemoteTestRunner.runTests(RemoteTestRunner.java:467)\n"+
"	at org.eclipse.jdt.internal.junit.runner.RemoteTestRunner.runTests(RemoteTestRunner.java:683)\n"+
"	at org.eclipse.jdt.internal.junit.runner.RemoteTestRunner.run(RemoteTestRunner.java:390)\n"+
"	at org.eclipse.jdt.internal.junit.runner.RemoteTestRunner.main(RemoteTestRunner.java:197)\n"
,			errContent.toString());
		} catch (Exception e) {
			fail();
		}
	}

	public void tearDown() {
	    System.setOut(null);
	    System.setErr(null);
	}


}
