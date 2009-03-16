package at.klickverbot.takefive.model {
   import at.klickverbot.takefive.algorithm.LineSearcher;   
   
   import flash.events.EventDispatcher;      

   /**
    * @author David Nadlinger
    */
   public class GameModel extends EventDispatcher {
      public function GameModel() {
   		m_segments = new Array();
   		for ( var i :int = 0; i < SEGMENT_COUNT; ++i ) {
   			var segment :Segment = new Segment( this, i );
            m_segments.push( segment );
   			segment.addEventListener( FieldEvent.CHANGED, handleStonePlaced );
   			segment.addEventListener( SegmentRotatedEvent.ROTATED, handleSegmentRotated );
   		}
   		
   		m_board = new BoardSegmentAdapter( m_segments );
   		
         m_activePlayer = PlayerColor.WHITE;
         m_gameState = GameState.PLACE;
      }

      public function get segments() :Array {
   		return m_segments;
   	}
   	
   	public function get board() :IBoard {
   		return m_board;
   	}

      public function get activePlayer() :PlayerColor {
   		return m_activePlayer;
   	}
   	
   	public function get gameState() :GameState {
   		return m_gameState;
   	}
   	   	
      private function handleStonePlaced( event :FieldEvent ) :void {
      	changeGameState( GameState.ROTATE );
      }
      
      private function handleSegmentRotated( event :SegmentRotatedEvent ) :void {
      	endTurn();
      }
      
      private function endTurn() :void {
      	// Check if the active player has managed to get a winning line.
         if ( LineSearcher.findLines( m_board, m_activePlayer, Constants.WIN_LENGTH ).length > 0 ) {
         	changeGameState( GameState.GAME_OVER );
         	return;
         }
         
         if ( m_activePlayer == PlayerColor.BLACK ) {
            m_activePlayer = PlayerColor.WHITE;
         } else if ( m_activePlayer == PlayerColor.WHITE ) {
            m_activePlayer = PlayerColor.BLACK;
         }
         
         changeGameState( GameState.PLACE );
      }
      
      private function changeGameState( newState :GameState ) :void {
      	if ( m_gameState == newState ) {
      		return;
      	}
      	
      	var event :GameStateChangedEvent = new GameStateChangedEvent( m_gameState, newState );
         m_gameState = newState;
         dispatchEvent( event );
      }

      public static const SEGMENT_COUNT :int = 4;
   	
   	private var m_segments :Array;
   	private var m_board :IBoard;
   	private var m_activePlayer :PlayerColor;
   	private var m_gameState :GameState;
   }
}
