package at.klickverbot.takefive.model {
   import flash.events.EventDispatcher;      

   /**
    * @author David Nadlinger
    */
   public class Segment extends EventDispatcher {
      public function Segment( model :GameModel, segmentIndex :int ) {
      	m_gameModel = model;
         m_segmentIndex = segmentIndex;
      	
         m_fields = new Array();
   	   for ( var i :int = 0; i < Constants.FIELDS_PER_SEGMENT; ++i ) {
   	   	m_fields.push( null );	
   	   }
      }
      
      public function field( fieldIndex :int ) :PlayerColor {
         return m_fields[ fieldIndex ];
      }

      public function placeStone( fieldIndex :int, color :PlayerColor ) :Boolean {
      	if ( m_gameModel.gameState != GameState.PLACE ) {
            return false;
      	}
      	
      	if ( m_gameModel.activePlayer != color ) {
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
   	private var m_gameModel :GameModel;
   	private var m_segmentIndex :int;
   }
}
