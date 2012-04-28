package vb.week1.symtab;

public class SymbolTable<Entry extends IdEntry> {

    /** 
     * Constructor. 
     * @ensures  this.currentLevel() == -1 
     */
    public SymbolTable() { 
        // body nog toe te voegen
    }

    /** 
     * Opens a new scope. 
     * @ensures this.currentLevel() == old.currentLevel()+1;
     */
    public void openScope()  {
        // body nog toe te voegen
    }

    /** 
     * Closes the current scope. All identifiers in 
     * the current scope will be removed from the SymbolTable.
     * @requires old.currentLevel() > -1;
     * @ensures  this.currentLevel() == old.currentLevel()-1;
     */
    public void closeScope() {
        // body nog toe te voegen
    }

    /** Returns the current scope level. */
    public int currentLevel() {
        return 0; // body nog toe te voegen
    }    

    /** 
     * Enters an id together with an entry into this SymbolTable 
     * using the current scope level. The entry's level is set to 
     * currentLevel().
     * @requires id != null && id.length() > 0 && entry != null;
     * @ensures  this.retrieve(id).getLevel() == currentLevel();
     * @throws SymbolTableException when there is no valid 
     *    current scope level, or when the id is already declared 
     *    on the current level. 
     */
    public void enter(String id, Entry entry)
                                    throws SymbolTableException { 
        // body nog toe te voegen
    }

    /** 
     * Get the Entry corresponding with id whose level is
     * the highest; in other words, that is defined last.
     * @return  Entry of this id on the highest level
     *          null if this SymbolTable does not contain id 
     */
    public Entry retrieve(String id) {
        return null; // body nog toe te voegen
    }    
}
    
/** Exception class to signal problems with the SymbolTable */
class SymbolTableException extends Exception {
    /** {@link serialVersionUID} is required for Serializable */
    public static final long serialVersionUID = 24362462L;
    public SymbolTableException(String msg) { super(msg); }
}
