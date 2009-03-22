package at.klickverbot.takefive.model {

   /**
    * @author David Nadlinger
    */
   public class GlobalCoords {
      public function GlobalCoords( x :int, y :int ) {
         this.x = x;
         this.y = y;
      }
      
      public function addAssign( rhs :GlobalCoords ) :void {
         x += rhs.x;
         y += rhs.y;
      }
      
      public function clone() :GlobalCoords {
         return new GlobalCoords( x, y );
      }
      
      public var x :int;
      public var y :int;
   }
}
