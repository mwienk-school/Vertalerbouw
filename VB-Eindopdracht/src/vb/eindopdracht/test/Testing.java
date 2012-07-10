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
	
	public void testWhile02() {
		try {
			new Tester("src/vb/eindopdracht/test/while/while02");
			//Test moet falen, maar kan pas als checker goed werkt.
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void testProc1() {
		try {
			new Tester("src/vb/eindopdracht/test/proc/proc1");
		} catch (Exception e) {
			fail();
		}
	}

	public void tearDown() {
	    System.setOut(null);
	    System.setErr(null);
	}


}
