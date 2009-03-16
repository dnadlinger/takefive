package at.klickverbot.takefive.model {
   import at.klickverbot.takefive.model.IBoard;   

   /**
    * @author David Nadlinger
    */
   public class BoardSegmentAdapter implements IBoard {
   	public function BoardSegmentAdapter( segments :Array ) {
         if ( segments.length != Constants.SEGMENT_COUNT ) {
            throw new ArgumentError( "Invalid number of segments supplied." );
         }
         m_segments = segments;
      }

      public function readAtGlobal( globalCoords :GlobalCoords ) :PlayerColor {
         var coords :SegmentCoords = globalToSegment( globalCoords );
//         trace( globalCoords.x + ", " + globalCoords.y + " -> " + coords.segment + ", " + coords.field );
         return m_segments[ coords.segment ].field( coords.field );
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
       
      private var m_segments :Array;
   }
}
