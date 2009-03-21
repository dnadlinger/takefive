package at.klickverbot.takefive.model {
   import flash.events.Event;
   
   /**
    * @author David Nadlinger
    */
   public class TurnPhaseEvent extends Event {
      public function TurnPhaseEvent( oldState :TurnPhase, newState :TurnPhase ) {
         super( CHANGED, false, false );
         m_oldState = oldState;
         m_newState = newState;
      }
      
      public function get oldPhase() :TurnPhase {
      	return m_oldState;
      }
      
      public function get newPhase() :TurnPhase {
      	return m_newState;
      }
      
      public static const CHANGED :String = "gameStateChanged";
      
      private var m_oldState :TurnPhase;
      private var m_newState :TurnPhase;
   }
}
