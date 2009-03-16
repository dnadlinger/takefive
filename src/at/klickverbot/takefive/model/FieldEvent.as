package at.klickverbot.takefive.model {
   import flash.events.Event;
   
   /**
    * @author David Nadlinger
    */
   public class FieldEvent extends Event {
      public function FieldEvent( type :String, fieldIndex :int, newState :PlayerColor ) {
         super( type, false, false );
         m_fieldIndex = fieldIndex;
         m_newState = newState;
      }
      
      public function get fieldIndex() :int {
         return m_fieldIndex;
      }
      
      public function get newState() :PlayerColor {
         return m_newState;
      }

      public static const CHANGED :String = "changed";
      
      private var m_fieldIndex :int;
      private var m_newState :PlayerColor;
   }
}
