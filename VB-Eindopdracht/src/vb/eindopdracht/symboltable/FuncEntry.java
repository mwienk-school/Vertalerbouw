package vb.eindopdracht.symboltable;

public class FuncEntry extends IdEntry {
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

}
