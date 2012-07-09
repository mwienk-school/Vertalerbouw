package vb.eindopdracht.helpers;

import java.lang.reflect.Constructor;
import java.util.HashMap;

import vb.eindopdracht.symboltable.*;

/**
 * Dit is een helper klasse die voor zowel de Checker als de Generator belangijke 
 * info bevat (zoals de Suffixes en andere code afspraken).
 *
 */
public abstract class CrimsonCodeHelper {
	// De types die in CrimsonCode bestaan
	protected static HashMap<String, String> tokenSuffix;
	public SymbolTable<IdEntry> symbolTable;

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
				@SuppressWarnings("rawtypes")
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
	
		
	public CrimsonCodeHelper() {
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
