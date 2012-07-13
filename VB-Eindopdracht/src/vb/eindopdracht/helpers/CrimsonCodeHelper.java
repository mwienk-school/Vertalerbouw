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
	protected static HashMap<String, IdEntry> dynamicTypes;
	
	public SymbolTable<IdEntry> symbolTable;

	/**
	 * Split camelCase items into Strings
	 * @param str
	 * @return
	 */
	public static String[] splitString(String str) {
		return str.split("(?<!(^|[A-Z]))(?=[A-Z])|(?<!^)(?=[A-Z][a-z])");
	}
	
	/**
	 * In processEntry wordt het type van de entry bepaald en daarna wordt deze
	 * in de symbolTable opgeslagen als een getypeerde IdEntry.
	 * 
	 * @param identifier
	 * @return
	 * @throws Exception
	 */
	public IdEntry processEntry(String identifier) throws Exception {
		String[] splitted = CrimsonCodeHelper.splitString(identifier);
		String lastPart = "";
		for (int i = 1; i < splitted.length; i++) {
			lastPart = splitted[splitted.length - i] + lastPart;
			if (tokenSuffix.containsKey(lastPart.toString())) {
				@SuppressWarnings("rawtypes")
				Constructor constructor = null;
				IdEntry entry = null;
				
				String type = tokenSuffix.get(lastPart.toString());
				if(type.equals("dynamic")) {
					// Type is een dynamisch type
					IdEntry dynamicType = dynamicTypes.get(lastPart.toString());
					if(dynamicType instanceof ArrayEntry) {
						entry = ((ArrayEntry) dynamicType).generateArray(identifier);
					}
					
				} else {
					// Type is een basis type
					constructor = Class.forName(type).getConstructor(String.class);
					entry = (IdEntry) constructor.newInstance(splitted[splitted.length - (i + 1)]);
				}
				
				symbolTable.enter(identifier, entry);
				return entry;
			}
		}
		// Type isn't found.
		throw new Exception("The declared type of " + identifier + "("
				+ lastPart + ") is an unknown type.");
	}
	
	/**
	 * In processConstantEntry wordt het type van de entry bepaald en daarna wordt deze
	 * in de symbolTable opgeslagen als een getypeerde IdEntry.
	 * 
	 * @param identifier
	 * @return
	 * @throws Exception
	 */
	public IdEntry processConstantEntry(String identifier, String type) throws Exception {
		if(type.endsWith("Read"))
			throw new Exception("Cannot initiate a constant with a read");
		IdEntry idEntry = processEntry(identifier);
		idEntry.setConstant(true);
		return idEntry;
	}
	
	/**
	 * Verwerkt een dynamisch type (voegt nieuwe token types toe aan de
	 * CrimsonCode taal).
	 * 
	 * @param identifier
	 * @throws Exception
	 */
	public void processDynamicType(String identifier, String start, String end) throws Exception {
		String[] str = splitString(identifier);
		
		// Uppercase the first letter so it can be seen as a type
		identifier = identifier.substring(0, 1).toUpperCase()
				+ identifier.substring(1);
		if ("Array".equals(str[str.length - 1])) {
			tokenSuffix.put(identifier,	"dynamic");
			ArrayEntry entry = new ArrayEntry(identifier);
			entry.setDimensions(Integer.parseInt(start), Integer.parseInt(end));
			dynamicTypes.put(identifier, entry);
			symbolTable.enter(identifier, entry);
		}
			
		
		// TODO: record nog niet goed (kan maar 1 type aan).
		if ("Record".equals(str[str.length - 1]))
			tokenSuffix.put(identifier,
					"vb.eindopdracht.symboltable.ArrayEntry");
	}
		
	public CrimsonCodeHelper() {
		symbolTable = new SymbolTable<IdEntry>();
		symbolTable.openScope();
		dynamicTypes = new HashMap<String, IdEntry>();
		tokenSuffix = new HashMap<String, String>();
		tokenSuffix.put("Pill", "vb.eindopdracht.symboltable.BooleanEntry");
		tokenSuffix.put("Int", "vb.eindopdracht.symboltable.IntEntry");
		tokenSuffix.put("Char", "vb.eindopdracht.symboltable.CharEntry");
		tokenSuffix.put("Proc", "vb.eindopdracht.symboltable.ProcEntry");
		tokenSuffix.put("Func", "vb.eindopdracht.symboltable.FuncEntry");
	}

}
