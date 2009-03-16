package at.klickverbot.takefive.model {
   import at.klickverbot.util.Enum;   
   
   /**
    * @author David Nadlinger
    */
   public class PlayerColor extends Enum {
   	public static const BLACK :PlayerColor = new PlayerColor();
   	public static const WHITE :PlayerColor = new PlayerColor();
   	
   	{ initEnum( PlayerColor ); }
   }
}
