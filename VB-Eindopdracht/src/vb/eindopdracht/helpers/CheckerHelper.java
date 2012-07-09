package vb.eindopdracht.helpers;

import java.lang.reflect.Constructor;
import java.util.HashMap;
import vb.eindopdracht.symboltable.*;

/**
 * CheckerHelper is een helper class voor de CrimsonCode Checker 
 */
public class CheckerHelper {
	// SymbolTable om bij te houden wat er gedefinieerd is
	public SymbolTable<IdEntry> symbolTable; 
	// De types die in CrimsonCode bestaan
	private HashMap<String, String> tokenSuffix; 

	/**
	 * In processEntry wordt het type van de entry bepaald en daarna wordt deze
	 * in de symbolTable opgeslagen als een getypeerde IdEntry.
	 * 
	 * @param identifier
	 * @return
	 * @throws Exception
	 */
	public IdEntry processEntry(String identifier) throws Exception {
		String[] splitted = identifier
				.split("(?<!(^|[A-Z]))(?=[A-Z])|(?<!^)(?=[A-Z][a-z])");
		String lastPart = "";
		for (int i = 1; i < splitted.length; i++) {
			lastPart = splitted[splitted.length - i] + lastPart;
			if (tokenSuffix.containsKey(lastPart.toString())) {
				Constructor constructor = Class.forName(
						tokenSuffix.get(lastPart.toString())).getConstructor(
						String.class);
				IdEntry entry = (IdEntry) constructor
						.newInstance(splitted[splitted.length - (i + 1)]);
				symbolTable.enter(identifier, entry);
				return entry;
			}
		}
		// Type isn't found.
		throw new Exception("The declared type of " + identifier + "("
				+ lastPart + ") is an unknown type.");
	}

	/**
	 * Verwerkt een dynamisch type (voegt nieuwe token types toe aan de
	 * CrimsonCode taal).
	 * 
	 * @param identifier
	 * @throws Exception
	 */
	public void processDynamicType(String identifier) throws Exception {
		String[] str = identifier
				.split("(?<!(^|[A-Z]))(?=[A-Z])|(?<!^)(?=[A-Z][a-z])");
		// Uppercase the first letter so it can be seen as a type
		identifier = identifier.substring(0, 1).toUpperCase()
				+ identifier.substring(1);
		if ("Array".equals(str[str.length - 1]))
			tokenSuffix.put(identifier,
					"vb.eindopdracht.symboltable.ArrayEntry");
		// TODO: record nog niet goed (kan maar 1 type aan).
		if ("Record".equals(str[str.length - 1]))
			tokenSuffix.put(identifier,
					"vb.eindopdracht.symboltable.ArrayEntry");
	}
	
	/**
	 * Bekijkt of een variabele (ex) van een bepaalde type is
	 * @param type
	 * @param ex
	 * @return
	 * @throws Exception
	 */
	public String checkType(String type, String ex) throws Exception {
		if(ex.equals(type))
	          return type;
	    else 
	    	  throw new Exception(type + " expression expected, " + ex + " expression found.");
	}
	
	/**
	 * Checkt of een variabele is gedeclareerd.
	 * @param id
	 * @throws Exception
	 */
	public void checkDeclared(String id) throws Exception {
		if(symbolTable.retrieve(id) == null)
	          throw new Exception(id + " is not declared.");
	}
	
	/**
	 * Constructor (instantieert de standaard types van CrimsonCode).
	 */
	public CheckerHelper() {
		symbolTable = new SymbolTable<IdEntry>();
		symbolTable.openScope();
		tokenSuffix = new HashMap<String, String>();
		tokenSuffix.put("Pill", "vb.eindopdracht.symboltable.BooleanEntry");
		tokenSuffix.put("Int", "vb.eindopdracht.symboltable.IntEntry");
		tokenSuffix.put("Char", "vb.eindopdracht.symboltable.CharEntry");
		tokenSuffix.put("Proc", "vb.eindopdracht.symboltable.ProcEntry");
		tokenSuffix.put("Func", "vb.eindopdracht.symboltable.FuncEntry");
	}
}
