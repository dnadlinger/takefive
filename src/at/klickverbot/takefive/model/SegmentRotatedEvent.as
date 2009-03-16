package at.klickverbot.takefive.model {
   import flash.events.Event;
   
   /**
    * @author David Nadlinger
    */
   public class SegmentRotatedEvent extends Event {
   	/**
   	 * @param angle The rotation angle (1 = 90°).
   	 */
      public function SegmentRotatedEvent( angle :int ) {
         super( ROTATED, false, false );
         m_angle = angle;
      }
      
      public function get angle() :int {
      	return m_angle;
      }
      
      public static const ROTATED :String = "rotated";
      
      private var m_angle :int;
   }
}
