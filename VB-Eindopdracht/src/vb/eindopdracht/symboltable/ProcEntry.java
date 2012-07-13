package vb.eindopdracht.symboltable;

import java.util.ArrayList;

public class ProcEntry extends IdEntry {
	protected ArrayList<String> parameters;
	
	@Override
	public void setValue(Object o) {
		// TODO Auto-generated method stub

	}
	
	public ProcEntry(String str) {
		this.functional = true;
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
