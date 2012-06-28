package vb.eindopdracht.symboltable;

/**
 * Variable can be used to store metadata about declared variables and constants.
 * In case of a constant, the value field is supposed to hold the value of the constant
 * In case of a variable, the value field is supposed to hold the address of the variable
 * @author Mark Wienk
 *
 */
public class Variable {
	public enum Types {CONST, VAR};
	private Types type;
	private String value;
	
	public Types getType() {
		return type;
	}
	public void setType(Types type) {
		this.type = type;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	
	public boolean isConstant() {
		if(type == Types.CONST) {
			return true;
		}
		return false;
	}
	
	/**
	 * Instantiate a var
	 * @param value
	 */
	public Variable(String value) {
		this(value,false);
	}
	
	/***
	 * Instantiate a variable type (constant or real variable).
	 * @param value the content (or address)
	 * @param isConstant true if const, false if var
	 */
	public Variable(String value, boolean isConstant) {
		if(isConstant) { 
			this.type = Types.CONST;
		} else {
			this.type = Types.VAR;
		}
		this.value = value;
	}
	
}