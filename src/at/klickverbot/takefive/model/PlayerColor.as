package at.klickverbot.takefive.model {
   import at.klickverbot.util.Enum;   
   
   /**
    * @author David Nadlinger
    */
   public class PlayerColor extends Enum {
   	public static const BLACK :PlayerColor = new PlayerColor();
   	public static const WHITE :PlayerColor = new PlayerColor();
   	
   	public static function other( color :PlayerColor ) :PlayerColor {
   		if ( color == BLACK ) {
   			return WHITE;
   		} else if ( color == WHITE ){
   			return BLACK;
   		} else {
   			return null;
   		}
   	}
   	
   	{ initEnum( PlayerColor ); }
   }
}
