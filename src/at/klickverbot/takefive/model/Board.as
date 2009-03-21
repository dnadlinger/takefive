package at.klickverbot.takefive.model {
   import at.klickverbot.takefive.algorithm.Line;
   import at.klickverbot.takefive.algorithm.LineSearcher;
   
   import flash.events.EventDispatcher;   

   /**
    * @author David Nadlinger
    */
   public class Board extends EventDispatcher {
   	public function Board() {
   		m_segments = new Array();
         for ( var i :int = 0; i < Constants.SEGMENT_COUNT; ++i ) {
            var segment :Segment = new Segment( this, i );
            m_segments.push( segment );
            segment.addEventListener( FieldEvent.CHANGED, handleStonePlaced );
            segment.addEventListener( SegmentRotatedEvent.ROTATED, handleSegmentRotated );
         }
         
         reset();
   	}
   	
   	public function reset() :void {
   		m_segments.forEach( function ( s :Segment, ...a ) :void { s.reset(); } );
   		m_activePlayer = PlayerColor.WHITE;
         m_inactivePlayer = PlayerColor.BLACK;
         
         setCurrentPhase( TurnPhase.PLACE );
      }
      
      public function getFieldsArray() :Array {
      	var fields :Array = new Array();
      	
      	for ( var currentCol :int = 0; currentCol < Constants.BOARD_SIZE; ++currentCol ) {
      		var colArray :Array = new Array();
      		
      		for ( var currentRow :int = 0; currentRow < Constants.BOARD_SIZE; ++currentRow ) {
      			var coords :SegmentCoords = globalToSegment( new GlobalCoords( currentCol, currentRow ) );
               colArray.push( m_segments[ coords.segment ].field( coords.field ) );
      		}
      		
      		fields.push( colArray );
      	}
      	
      	return fields;
      }
      
      public function globalToSegment( coords :GlobalCoords ) :SegmentCoords {
         var segmentX :int = coords.x / Constants.SEGMENT_SIDE_FIELDS;
         var segmentY :int = coords.y / Constants.SEGMENT_SIDE_FIELDS;
         var segmentIndex :int = segmentY * Constants.BOARD_SIDE_SEGMENTS + segmentX;
         
         var fieldX :int = coords.x % Constants.SEGMENT_SIDE_FIELDS;
         var fieldY :int = coords.y % Constants.SEGMENT_SIDE_FIELDS;
         
         var fieldIndex :int;
         switch ( m_segments[ segmentIndex ].rotation ) {
            case 0:
               fieldIndex = fieldY * Constants.SEGMENT_SIDE_FIELDS + fieldX;
               break;
            case 1:
               fieldIndex = ( 2 - fieldX ) * Constants.SEGMENT_SIDE_FIELDS + fieldY;
               break;
            case 2:
               fieldIndex = ( 2 - fieldY ) * Constants.SEGMENT_SIDE_FIELDS + ( 2 - fieldX );
               break;
            case 3:
               fieldIndex = fieldX * Constants.SEGMENT_SIDE_FIELDS + ( 2 - fieldY );
               break;
            default:
               throw new Error( "Invalid segment rotation: " + m_segments[ segmentIndex ].rotation );
               break;
         }
         
         return new SegmentCoords( segmentIndex, fieldIndex );
      }
      
      public function segmentToGlobal( coords :SegmentCoords ) :GlobalCoords {
         var segmentX :int = coords.segment % Constants.BOARD_SIDE_SEGMENTS;
         var segmentY :int = coords.segment / Constants.BOARD_SIDE_SEGMENTS;
         
         var x :int = segmentX * Constants.BOARD_SIDE_SEGMENTS;
         var y :int = segmentY * Constants.BOARD_SIDE_SEGMENTS;
         
         switch ( m_segments[ coords.segment ].rotation ) {
            case 0:
               x += coords.field % Constants.SEGMENT_SIDE_FIELDS;
               y += coords.field / Constants.SEGMENT_SIDE_FIELDS;
               break;
            case 1:
               x += 2 - ( coords.field / Constants.SEGMENT_SIDE_FIELDS );
               y += coords.field % Constants.SEGMENT_SIDE_FIELDS;
               break;
            case 2:
               x += 2 - ( coords.field % Constants.SEGMENT_SIDE_FIELDS );
               y += 2 - ( coords.field / Constants.SEGMENT_SIDE_FIELDS );
               break;
            case 3:
               x += coords.field / Constants.SEGMENT_SIDE_FIELDS;
               y += 2 - ( coords.field % Constants.SEGMENT_SIDE_FIELDS );
               break;
            default:
               throw new Error( "Invalid segment rotation: " + m_segments[ coords.segment ].rotation );
               break;
         }
         
         return new GlobalCoords( x, y );
      }
   	
   	public function get segments() :Array {
         return m_segments;
      }
      
      public function get activePlayer() :PlayerColor {
         return m_activePlayer;
      }
      
      public function get inactivePlayer() :PlayerColor {
         return m_inactivePlayer;
      }
      
      public function get currentPhase() :TurnPhase {
         return m_currentPhase;
      }

      private function handleStonePlaced( event :FieldEvent ) :void {
         setCurrentPhase( TurnPhase.ROTATE );
      }
      
      private function handleSegmentRotated( event :SegmentRotatedEvent ) :void {
         endTurn();
      }
      
      private function endTurn() :void {
         // Check if any player has managed to get a winning line.
         // We have to check also the non-active player because the active player
         // could deliberately loose...
      
         var lines :Array = LineSearcher.findLines( this, Constants.WIN_LENGTH ); 
         if ( lines.some( function( l :Line, ...a ) :Boolean { return l.color == m_activePlayer; } ) ) {
            dispatchEvent( new GameOverEvent( m_activePlayer ) );
            return;
         }
         if ( lines.some( function( l :Line, ...a ) :Boolean { return l.color == m_inactivePlayer; } ) ) {
            dispatchEvent( new GameOverEvent( m_inactivePlayer ) );
            return;
         }
         
         var oldActivePlayer :PlayerColor = m_activePlayer;
         m_activePlayer = m_inactivePlayer;
         m_inactivePlayer = oldActivePlayer;
         
         setCurrentPhase( TurnPhase.PLACE );
      }
      
      private function setCurrentPhase( newState :TurnPhase ) :void {
         if ( m_currentPhase == newState ) {
            return;
         }
         
         var event :TurnPhaseEvent = new TurnPhaseEvent( m_currentPhase, newState );
         m_currentPhase = newState;
         dispatchEvent( event );
      }
      
      private var m_segments :Array;
      private var m_activePlayer :PlayerColor;
      private var m_inactivePlayer :PlayerColor;  
      private var m_currentPhase :TurnPhase;    
   }
}
