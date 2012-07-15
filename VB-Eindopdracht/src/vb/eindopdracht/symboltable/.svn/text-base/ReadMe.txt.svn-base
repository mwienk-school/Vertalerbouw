Grammar
Vertalerbouw
2008/2009

Door:
Jeroen Meijer (S0166111)
Kevin Leuwerink (S0166081)

Deze ReadMe bevat beschrijvingen om de JavaDoc te openen, het programma uit te voeren 
en het testprogramma uit te voeren. Tevens bevat de CD-Rom het verslag in pdf formaat.

Het programma is gecompileerd in de nieuwste versie van Java 5.0.
De geschreven vertaler is alleen getest op een Windows systeem, dus wij garanderen niet dat deze werkt op een 
UNIX gebaseerd systeem.

Korte beschrijving:
- De JavaDoc bevindt zich in de map JavaDoc.
- De source bestanden bevinden zich in de map src
- De .g bestanden staan in de mag src\grammar
- De mainclass van het programma is grammar.Grammar
- Om de bestanden te compilen moet src\compile.bat worden aangeroepen. Wanneer handmatig gecompileerd moet worden
	moet in compile.bat gekeken worden hoe dit moet. Let op de de .tokens bestanden goed verplaatst worden.
- Om de correcte tests uit te voeren moet src\runtests.bat worden uitgevoerd.
	De compiler kan uitgevoerd worden, zoals in de practica is uitgelegd.
	dus het commando: java grammar.Grammar < test\testall.txt > obj.tasm
	voert het programma test\testall.txt uit en geeft TAM instructies
	Vervolgens kan java TAM.Assembler < obj.tasm > obj.tam aangeroepen worden om
	TAM machinetaal te genereren.
	Als laatste kan java TAM.Interpreter worden aangeroepen, deze verwerkt het obj.tam bestand.
- Het verslag bevindt zich in Verslag
- src\obj.tasm is een bestand met TAM instructies van test\CorrectTests\testall.txt
- src\obj.tam is TAM machine taal van test\CorrectTests\testall.txt
- De class files bevinden zich in dezelfde map als de java files, omdat dit makkelijker met het uitvoeren van de compiler
	
* U dient antlr als CLASSPATH te hebben ingesteld.