package vb.eindopdracht.helpers;

import vb.eindopdracht.symboltable.ArrayEntry;

/**
 * CheckerHelper is een helper class voor de CrimsonCode Checker 
 */
public class CheckerHelper extends CrimsonCodeHelper {
	
	/**
	 * Bekijkt of een variabele (ex) van een bepaalde type is
	 * @param type
	 * @param ex
	 * @return
	 * @throws Exception
	 */
	public String checkType(String type, String ex) throws Exception {
		
		String[] splitType = CrimsonCodeHelper.splitString(type);
		String[] splitEx   = CrimsonCodeHelper.splitString(ex);
		
		if(ex.equals(type))
	          return type;
	    else if(splitType[splitType.length - 1].equals(splitEx[splitEx.length - 1])
	    		&& splitType[splitType.length - 2].equals(splitEx[splitEx.length - 2]))
	    	//Dynamic Type (last 2 parts are equal).
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
	 * Checkt of een variabele is gedeclareerd en returnt het type.
	 * @param id
	 * @throws Exception
	 */
	public String getType(String id) throws Exception {
		checkDeclared(id);
		String[] splitted = CrimsonCodeHelper.splitString(id);
		String lastPart = "";
		for (int i = 1; i < splitted.length; i++) {
			lastPart = splitted[splitted.length - i] + lastPart;
			if (tokenSuffix.containsKey(lastPart.toString())) {
				return lastPart;
			}
		}
		// Type isn't found.
		throw new Exception("The declared type of " + id + "("
				+ lastPart + ") is an unknown type.");
	}
	
	/**
	 * 
	 * @param identifier
	 * @throws Exception 
	 */
	public void processArray(String identifier, String size) throws Exception {
		ArrayEntry entry = (ArrayEntry) processEntry(identifier);
		int arraySize = entry.getEndDimension() - entry.getStartDimension();
		if(arraySize != Integer.parseInt(size)) {
			throw new Exception("The declared array " + identifier + " does not have the right size (" + arraySize + ")");
		}
	}
	
	/**
	 * Constructor (instantieert de standaard types van CrimsonCode).
	 */
	public CheckerHelper() {
		super();
	}
}
