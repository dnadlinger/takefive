package at.klickverbot.takefive.model {
   import at.klickverbot.takefive.algorithm.Line;
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
         
         m_lastWinner = null;
         
         m_blackScore = 0;
         m_whiteScore = 0;
         
         resetBoard();
      }
      
      public function resetBoard() :void {
      	m_segments.forEach( function ( s :Segment, ...a ) :void { s.reset(); } );
      	
      	m_activePlayer = PlayerColor.WHITE;
         m_inactivePlayer = PlayerColor.BLACK;
         changeGameState( GameState.PLACE );
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
   	
   	public function get inactivePlayer() :PlayerColor {
         return m_inactivePlayer;
      }
   	
   	public function get gameState() :GameState {
   		return m_gameState;
   	}
   	
   	public function get lastWinner() :PlayerColor {
   		return m_lastWinner;
   	}

      private function handleStonePlaced( event :FieldEvent ) :void {
      	changeGameState( GameState.ROTATE );
      }
      
      private function handleSegmentRotated( event :SegmentRotatedEvent ) :void {
      	endTurn();
      }
      
      private function endTurn() :void {
      	// Check if any player has managed to get a winning line.
      	// We have to check also the non-active player because the active player
      	// could deliberately loose...
     	
      	var lines :Array = LineSearcher.findLines( m_board, Constants.WIN_LENGTH ); 
         if ( lines.some( function( l :Line, ...a ) :Boolean { return l.color == m_activePlayer; } ) ) {
         	win( m_activePlayer );
            return;
         }
         if ( lines.some( function( l :Line, ...a ) :Boolean { return l.color == m_inactivePlayer; } ) ) {
            win( m_inactivePlayer ); 
            return;
         }
         
         var oldActivePlayer :PlayerColor = m_activePlayer;
         m_activePlayer = m_inactivePlayer;
         m_inactivePlayer = oldActivePlayer;
         
         changeGameState( GameState.PLACE );
      }
      
      private function win( winner :PlayerColor ) :void {
      	if ( winner == PlayerColor.BLACK ) {
            ++m_blackScore;
         } else if ( winner == PlayerColor.WHITE ) {
         	++m_whiteScore;
         }
         
         m_lastWinner = winner;
         changeGameState( GameState.GAME_OVER );
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
   	private var m_inactivePlayer :PlayerColor;
      private var m_lastWinner :PlayerColor;
   	private var m_gameState :GameState;
   	private var m_blackScore :int;
   	private var m_whiteScore :int;
   }
}
