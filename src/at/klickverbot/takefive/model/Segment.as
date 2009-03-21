package at.klickverbot.takefive.model {
   import flash.events.EventDispatcher;         

   /**
    * @author David Nadlinger
    */
   public class Segment extends EventDispatcher {
      public function Segment( model :Board, segmentIndex :int ) {
      	m_board = model;
         m_segmentIndex = segmentIndex;
      	
         reset();
      }
      
      public function reset() :void {
      	// All fields are set to null by creating a new array, so no additional
      	// actions are needed.
      	m_fields = new Array();
      	m_rotation = 0;
      }
      
      public function field( fieldIndex :int ) :PlayerColor {
         return m_fields[ fieldIndex ];
      }

      public function placeStone( fieldIndex :int, color :PlayerColor ) :Boolean {
      	if ( m_board.currentPhase != TurnPhase.PLACE ) {
            return false;
      	}
      	
      	if ( m_board.activePlayer != color ) {
            return false;
         }
         
         if ( m_fields[ fieldIndex ] != null ) {
         	return false;
         }
      	  
         m_fields[ fieldIndex ] = color;
         dispatchEvent( new FieldEvent( FieldEvent.CHANGED, fieldIndex, color ) );
         
         return true;
      }
      
      public function get rotation() :int {
         return m_rotation;
      }
      
      public function rotateCcw() :void {
      	rotate( -1 );
      }
      
      public function rotateCw() :void {
         rotate( 1 );
      }

      private function rotate( angle :int ) :void {
      	m_rotation = ( m_rotation + angle ) % 4;
      	if ( m_rotation < 0 ) {
      		m_rotation += 4;
      	} else if ( m_rotation >= 4 ) {
      		m_rotation -= 4;
      	}
      	
         dispatchEvent( new SegmentRotatedEvent( angle ) );
      }
   	
   	private var m_fields :Array;
   	private var m_rotation :int;
   	private var m_board :Board;
   	private var m_segmentIndex :int;
   }
}
