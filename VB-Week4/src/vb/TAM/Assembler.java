package vb.TAM;

/**
 * TAM Assembler. 
 *
 * (C) Univerity of Twente, 
 *     Department of Computer Science, 
 *     Formal Methods & Tools Group,
 *     Enschede, The Netherlands.
 *
 * contact: Theo C. Ruys (email: ruys@cs.utwente.nl)
 *                          
 * @author  Matthijs Bomhoff (initial design and implementation)
 *          Theo Ruys (minor tweaking)
 * @version 2003.04.13
 */

/* CHANGES
 *  o  2003.04.07  bomhoff  Initial version.
 *  o  2003.04.13  ruys     - Changed package name from triangle.assembler 
 *                            to TAM.
 *                          - Relative addresses can be negative:
 *                            added -? in the front of group 6 (d).
 *                          - Added optional line-comments to a label and
 *                            assembler line.
 *                          - Added toString() to class Instruction for
 *                            debugging the Assembler.
 */
 
import java.util.*;
import java.io.*;
import java.util.regex.*;

public class Assembler {

	protected static final Matcher commandMatcher = Pattern.compile(
			"^\\s*" + //whitespace
			"(([A-Za-z0-9_]+):)?" + //optional line number or label (group 2)
			"\\s*" + //whitespace
			"([A-Z]+)" + //opcode mnemonic (group 3)
			"\\s*" + //whitespace
			"(\\(([a-zA-Z0-9]+)\\))?" + //n  (group 5)
			"\\s*" + //whitespace
			"(-?[a-zA-Z0-9]+)?" + //d (group 6)
			"\\s*" + //whitespace
			"(\\[([a-zA-Z0-9]+)\\])?" + //r (group 8)
			"\\s*" + //whitespace
			"(;.*)?" + // optional comment (group 10)            
			"\\s*$" //whitespace
			).matcher("");

	protected static final Matcher labelMatcher = Pattern.compile(
			"^\\s*" + //whitespace
			"([A-Za-z0-9_]+)" + //labels (group 1)
			":" + //colon
			"\\s*" + //whitespace
			"(;.*)?" + // optional comment (group 2)            
			"\\s*$" //whitespace
			).matcher("");

	protected static final Map<String,Integer> labelMap = new HashMap<String,Integer>();

	public static void main(String[] args) throws Exception {
		InputStream in = null;
		OutputStream out = null;
		if (args.length == 0) {
			in = System.in;
			out = System.out;
		} else if (args.length == 2) {
			in = new FileInputStream(args[0]);
			out = new FileOutputStream(args[1]);
		} else {
			System.err.println("usage: Assemble [infile outfile]");
			System.exit(1);
		}
		assert in != null && out != null;
		assemble(in, out);
		in.close();
		out.close();
		System.exit(0);
	}

	public static void assemble(InputStream in, OutputStream out) throws IOException {
		final BufferedReader buf = new BufferedReader(new InputStreamReader(in));
		final DataOutputStream dataOut = new DataOutputStream(out);
		final List<String> lines = new ArrayList<String>();
		String line = null;
		//read file into buffer
		while ( (line = buf.readLine()) != null) {
			lines.add(line);
		}
		final int totalLineCount = lines.size();

		int labelLineCount = 0;
		//first pass, extract labels
		int codeLineNumber = 0;
		Iterator<String> iter = lines.iterator();
		while ( iter.hasNext() ) {
			line = iter.next();
			labelMatcher.reset(line);
			commandMatcher.reset(line);

			if (labelMatcher.matches()) {
				labelMap.put(labelMatcher.group(1), new Integer(codeLineNumber));
				labelLineCount++;
				iter.remove();	//remove labels after adding them to the label map
			}
			else if (commandMatcher.matches()) {
				if (commandMatcher.group(2) != null) {
					labelMap.put(commandMatcher.group(2), new Integer(codeLineNumber));
				}
				codeLineNumber++;
			}
			else {
				//neither label, nor code, simply remove the line
				iter.remove();
			}
		}
		//only _real_ code lines should be left in lines now
		final int codeLineCount = lines.size();
			
		//second pass, emit code
		iter = lines.iterator();
		while ( iter.hasNext() ) {
			line = iter.next();
			Instruction instruction = instructionFromString(line);
			if (instruction != null) {
				instruction.write(dataOut);
			}
		}
		System.err.println("Assembly results:\n" +
				"lines in file: " + totalLineCount + "\n" +
				"lines of code: " + codeLineCount + "\n" +
				"label lines  : " + labelLineCount + "\n" +
				"lines ignored: " + (totalLineCount - codeLineCount - labelLineCount) + "\n"
				);
	}

	public static Instruction instructionFromString(String str) {
		Instruction result = null;
		commandMatcher.reset(str);
		//process command
		if (commandMatcher.matches()) {
			try {
				final String opString = commandMatcher.group(3);
				final String nString = commandMatcher.group(5);
				final String dString = commandMatcher.group(6);
				final String rString = commandMatcher.group(8);

				final int op = getOpcode(opString);
				int n = 0;
				int d = 0;
				int r = 0;
				switch (op) {
					case 0:	//LOAD
						n = Integer.parseInt(nString);
						d = Integer.parseInt(dString);
						r = getRegister(rString);
						result = new Instruction(op, r, n, d);
						break;
					case 1:	//LOADA
						d = Integer.parseInt(dString);
						r = getRegister(rString);
						result = new Instruction(op, r, n, d);
						break;
					case 2:	//LOADI
						n = Integer.parseInt(nString);
						result = new Instruction(op, r, n, d);
						break;
					case 3:	//LOADL
						d = Integer.parseInt(dString);
						result = new Instruction(op, r, n, d);
						break;
					case 4:	//STORE
						n = Integer.parseInt(nString);
						d = Integer.parseInt(dString);
						r = getRegister(rString);
						result = new Instruction(op, r, n, d);
						break;
					case 5:	//STOREI
						n = Integer.parseInt(nString);
						result = new Instruction(op, r, n, d);
						break;
					case 6:	//CALL
						if (isSubroutine(dString)) {
							n = getRegister("SB");
							d = getSubroutine(dString);
							r = getRegister("PB");
						}
						else {
							n = getRegister(nString);
							final Integer labelLocation = labelMap.get(dString);
							if (labelLocation != null) {
								d = labelLocation.intValue();
							}
							else {
								d = Integer.parseInt(dString);
							}
							r = getRegister(rString);
						}
						result = new Instruction(op, r, n, d);
						break;
					case 7:	//CALLI
						result = new Instruction(op, r, n, d);
						break;
					case 8:	//RETURN
						n = Integer.parseInt(nString);
						d = Integer.parseInt(dString);
						result = new Instruction(op, r, n, d);
						break;
					case 10:	//PUSH
						d = Integer.parseInt(dString);
						result = new Instruction(op, r, n, d);
						break;
					case 11:	//POP
						n = Integer.parseInt(nString);
						d = Integer.parseInt(dString);
						result = new Instruction(op, r, n, d);
						break;
					case 12:	//JUMP
						{
							final Integer labelLocation = labelMap.get(dString);
							if (labelLocation != null) {
								d = labelLocation.intValue();
							}
							else {
								d = Integer.parseInt(dString);
							}
						}
						r = getRegister(rString);
						result = new Instruction(op, r, n, d);
						break;
					case 13:	//JUMPI
						result = new Instruction(op, r, n, d);
						break;
					case 14:	//JUMPIF
						n = Integer.parseInt(nString);
						{
							final Integer labelLocation = labelMap.get(dString);
							if (labelLocation != null) {
								d = labelLocation.intValue();
							}
							else {
								d = Integer.parseInt(dString);
							}
						}
						r = getRegister(rString);
						result = new Instruction(op, r, n, d);
						break;
					case 15:	//HALT
						result = new Instruction(op, r, n, d);
						break;

					default:
						System.err.println("ERROR: opcode number " + op + "(\"" + opString + "\") unknown"); break;
				}
			}
			catch (Exception e) {
				System.err.println("ERROR: an " + e.getClass().toString().substring(6) + " occured, while parsing the line \"" + str + "\"... skipping...");
			}
		}
		else {
			System.err.println("ERROR: line \"" + str + "\" does not match the (dis)assembler format... skipping...");
		}
		return result;
	}

	/**
	 * An inner class used to represent a single opcode
	 */
	public static final class Instruction {
		public int op;
		public int r;
		public int n;
		public int d;

		public Instruction(int op, int r, int n, int d) {
			this.op = op;
			this.r = r;
			this.n = n;
			this.d = d;
		}

		public void write(DataOutputStream out) throws IOException {
			out.writeInt(op);
			out.writeInt(r);
			out.writeInt(n);
			out.writeInt(d);
		}
        
		public String toString() { 
			return "" + op + "(" + n + ") " + d + "[" + r + "]";
		}
	}

	/*
	 * Some functions to map strings to numbers
	 */

	public static int getOpcode(String mnemonic) throws IllegalArgumentException {
		Integer integer = opcodeMap.get(mnemonic);
		if (integer == null) throw new IllegalArgumentException("Opcode \"" + mnemonic + "\" unknown");
		return integer.intValue();
	}

	public static int getRegister(String name) throws IllegalArgumentException {
		Integer integer = registerMap.get(name);
		if (integer == null) throw new IllegalArgumentException("Register \"" + name + "\" unknown");
		return integer.intValue();
	}
		
	public static boolean isSubroutine(String identifier) {
		return subroutineMap.containsKey(identifier);
	}
	
	public static int getSubroutine(String identifier) throws IllegalArgumentException {
		Integer integer = subroutineMap.get(identifier);
		if (integer == null) throw new IllegalArgumentException("Subroutine \"" + identifier + "\" unknown");
		return integer.intValue();
	}

	/*
	 * Here comes the ugly part:
	 */
	private static final Map<String,Integer> opcodeMap = new LinkedHashMap<String,Integer>();
	private static final Map<String,Integer> registerMap = new LinkedHashMap<String,Integer>();
	private static final Map<String,Integer> subroutineMap = new LinkedHashMap<String,Integer>();

	static {
		opcodeMap.put("LOAD", new Integer(0));
		opcodeMap.put("LOADA", new Integer(1));
		opcodeMap.put("LOADI", new Integer(2));
		opcodeMap.put("LOADL", new Integer(3));
		opcodeMap.put("STORE", new Integer(4));
		opcodeMap.put("STOREI", new Integer(5));
		opcodeMap.put("CALL", new Integer(6));
		opcodeMap.put("CALLI", new Integer(7));
		opcodeMap.put("RETURN", new Integer(8));
		opcodeMap.put("PUSH", new Integer(10));
		opcodeMap.put("POP", new Integer(11));
		opcodeMap.put("JUMP", new Integer(12));
		opcodeMap.put("JUMPI", new Integer(13));
		opcodeMap.put("JUMPIF", new Integer(14));
		opcodeMap.put("HALT", new Integer(15));

		registerMap.put("CB", new Integer(0));
		registerMap.put("CT", new Integer(1));
		registerMap.put("PB", new Integer(2));
		registerMap.put("PT", new Integer(3));
		registerMap.put("SB", new Integer(4));
		registerMap.put("ST", new Integer(5));
		registerMap.put("HB", new Integer(6));
		registerMap.put("HT", new Integer(7));
		registerMap.put("LB", new Integer(8));
		registerMap.put("L1", new Integer(8 + 1));
		registerMap.put("L2", new Integer(8 + 2));
		registerMap.put("L3", new Integer(8 + 3));
		registerMap.put("L4", new Integer(8 + 4));
		registerMap.put("L5", new Integer(8 + 5));
		registerMap.put("L6", new Integer(8 + 6));
		registerMap.put("CP", new Integer(15));

		subroutineMap.put("id", new Integer(1));
		subroutineMap.put("not", new Integer(2));
		subroutineMap.put("and", new Integer(3));
		subroutineMap.put("or", new Integer(4));
		subroutineMap.put("succ", new Integer(5));
		subroutineMap.put("pred", new Integer(6));
		subroutineMap.put("neg", new Integer(7));
		subroutineMap.put("add", new Integer(8));
		subroutineMap.put("sub", new Integer(9));
		subroutineMap.put("mult", new Integer(10));
		subroutineMap.put("div", new Integer(11));
		subroutineMap.put("mod", new Integer(12));
		subroutineMap.put("lt", new Integer(13));
		subroutineMap.put("le", new Integer(14));
		subroutineMap.put("ge", new Integer(15));
		subroutineMap.put("gt", new Integer(16));
		subroutineMap.put("eq", new Integer(17));
		subroutineMap.put("ne", new Integer(18));
		subroutineMap.put("eol", new Integer(19));
		subroutineMap.put("eof", new Integer(20));
		subroutineMap.put("get", new Integer(21));
		subroutineMap.put("put", new Integer(22));
		subroutineMap.put("geteol", new Integer(23));
		subroutineMap.put("puteol", new Integer(24));
		subroutineMap.put("getint", new Integer(25));
		subroutineMap.put("putint", new Integer(26));
		subroutineMap.put("new", new Integer(27));
		subroutineMap.put("dispose", new Integer(28));
	}
}
