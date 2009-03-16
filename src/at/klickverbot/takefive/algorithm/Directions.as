package at.klickverbot.takefive.algorithm {
   import at.klickverbot.takefive.model.GlobalCoords;      

   /**
    * @author David Nadlinger
    */
   public class Directions {
   	public static const RIGHT :GlobalCoords = new GlobalCoords( 1, 0 );
   	public static const DOWN :GlobalCoords = new GlobalCoords( 0, 1 );
   	public static const DOWN_LEFT :GlobalCoords = new GlobalCoords( -1, 1 );
   	public static const DOWN_RIGHT :GlobalCoords = new GlobalCoords( 1, 1 );
   }
}
