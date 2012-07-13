package vb.eindopdracht.symboltable;

import java.util.ArrayList;

public class FuncEntry extends IdEntry {
	protected ArrayList<String> parameters;
	private String returnType;

	public String getReturnType() {
		return returnType;
	}

	public void setReturnType(String returnType) {
		this.returnType = returnType;
	}

	@Override
	public void setValue(Object o) {
		// TODO Auto-generated method stub
	}
	
	public FuncEntry(String str) {
		this.functional = true;
		this.setReturnType(str);
	}

	@Override
	public Object getValue() {
		// TODO Auto-generated method stub
		return null;
	}
	
	public String toString() {
		return null;
	}
	
	public void setParameters(ArrayList<String> parameters) {
		this.parameters = parameters;
	}
	
	public ArrayList<String> getParameters() {
		return this.parameters;
	}

}
