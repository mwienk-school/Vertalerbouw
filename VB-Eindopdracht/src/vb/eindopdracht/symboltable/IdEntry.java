package vb.eindopdracht.symboltable;

/**
 * VB prac week1 - SymbolTable.
 * class IdEntry.
 * @author   Theo Ruys
 * @version  2006.04.21
 */
public abstract class IdEntry {
	public enum Type {CONST, VAR};
    private int  level = -1;
    private String address;
    private Type type;
    protected boolean numeric = false;
    protected boolean functional = false;
    protected boolean varparam = false;
    protected boolean constant = false;
    
    public int   getLevel()				{ return level;			}
    public void  setLevel(int level)	{ this.level = level;	}
    public String getAddress() 			{ return address; 		}
    public void setAddress(String add)	{ this.address = add;  }
    public Type getType()				{ return type;			}
    public void setType(Type type)		{ this.type = type;		}
    public void setVarparam(boolean varparam)	{ this.varparam = varparam; }
    public boolean isNumeric() 			{ return this.numeric; }
    public boolean isFunctional()		{ return this.functional; }
    public boolean isVarparam()			{ return this.varparam; }
    public void setConstant(boolean constant)	{ this.constant = constant; }
    public boolean isConstant()			{ return this.constant; }
    
    public abstract void setValue(Object o);
    public abstract Object getValue();
}
