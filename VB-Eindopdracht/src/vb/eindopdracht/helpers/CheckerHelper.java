package vb.eindopdracht.helpers;

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
	 * Checkt of een variabele is gedeclareerd en van het juiste type is.
	 * @param type
	 * @param id
	 * @throws Exception
	 */
	public String checkDeclaredType(String type, String id) throws Exception {
		return checkType(type, getType(id));
	}
	
	/**
	 * Checkt of een variabele is gedeclareerd en returnt het type.
	 * @param id
	 * @throws Exception
	 */
	public String getType(String id) throws Exception {
		checkDeclared(id);
		String[] splitted = id
				.split("(?<!(^|[A-Z]))(?=[A-Z])|(?<!^)(?=[A-Z][a-z])");
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
	 * Constructor (instantieert de standaard types van CrimsonCode).
	 */
	public CheckerHelper() {
		super();
	}
}
