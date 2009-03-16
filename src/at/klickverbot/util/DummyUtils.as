package at.klickverbot.util {
   import flash.display.DisplayObject;   
   
   /**
    * @author David Nadlinger
    */
   public class DummyUtils {
   	public static function fitToDummy( target :DisplayObject, dummy :DisplayObject ) :void {
   		target.x = dummy.x;
   		target.y = dummy.y;
   		target.width = dummy.width;
   		target.height = dummy.height;
   	}
   }
}
