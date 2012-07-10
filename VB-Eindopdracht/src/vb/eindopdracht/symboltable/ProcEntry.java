package vb.eindopdracht.symboltable;

public class ProcEntry extends IdEntry {
	protected int parameters;
	
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
	
	public void setParameters(int parameters) {
		this.parameters = parameters;
	}
	
	public int getParameters() {
		return this.parameters;
	}

}
