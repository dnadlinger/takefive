package at.klickverbot.takefive.model {
   import flash.events.Event;
   
   /**
    * @author David Nadlinger
    */
   public class GameStateChangedEvent extends Event {
      public function GameStateChangedEvent( oldState :GameState, newState :GameState ) {
         super( CHANGED, false, false );
         m_oldState = oldState;
         m_newState = newState;
      }
      
      public function get oldState() :GameState {
      	return m_oldState;
      }
      
      public function get newState() :GameState {
      	return m_newState;
      }
      
      public static const CHANGED :String = "gameStateChanged";
      
      private var m_oldState :GameState;
      private var m_newState :GameState;
   }
}
