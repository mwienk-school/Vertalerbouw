package vb.eindopdracht.symboltable;

/**
 * VB prac week1 - SymbolTable.
 * class IdEntry.
 * @author   Theo Ruys
 * @version  2006.04.21
 */
public abstract class IdEntry {
    private int  level = -1;
    
    public int   getLevel()			{ return level;			}
    public void  setLevel(int level)	{ this.level = level;	}
    
    public abstract void setValue(Object o);
}
