package at.klickverbot.takefive.model {
   import flash.events.Event;
   
   /**
    * @author David Nadlinger
    */
   public class GameOverEvent extends Event {
      public function GameOverEvent( winner :PlayerColor ) {
         super( GAME_OVER, false, false );
         m_winner = winner;
      }
      
      public function get winner() :PlayerColor {
         return m_winner;
      }
      
      public static const GAME_OVER :String = "gameOver";
      
      private var m_winner :PlayerColor;
   }
}
