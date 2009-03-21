package at.klickverbot.takefive.model {
   import flash.events.EventDispatcher;         

   /**
    * @author David Nadlinger
    */
   public class GameModel extends EventDispatcher {
      public function GameModel() {
      	m_board = new Board();
      	m_board.addEventListener( GameOverEvent.GAME_OVER, handleGameOver );
      	         
         m_lastWinner = null;
         m_blackScore = 0;
         m_whiteScore = 0;
      }
      
      public function nextRound() :void {
      	m_board.reset();
      }
      
   	public function get board() :Board {
   		return m_board;
   	}
   	
   	public function get lastWinner() :PlayerColor {
   		return m_lastWinner;
   	}
   	
   	private function handleGameOver( event :GameOverEvent ) :void {
   		if ( event.winner == PlayerColor.BLACK ) {
            ++m_blackScore;
         } else if ( event.winner == PlayerColor.WHITE ) {
            ++m_whiteScore;
         }
         
         m_lastWinner = event.winner;
         dispatchEvent( new GameOverEvent( event.winner ) );
      }
   	
   	private var m_board :Board;
      private var m_lastWinner :PlayerColor;
   	private var m_blackScore :int;
   	private var m_whiteScore :int;
   }
}
