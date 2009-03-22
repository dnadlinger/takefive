package at.klickverbot.takefive.ai {
   import at.klickverbot.takefive.model.PlayerColor;   
   import at.klickverbot.takefive.model.Constants;   
   import at.klickverbot.takefive.model.GlobalCoords;   
   
   /**
    * @author David Nadlinger
    */
   public class Turn {
      public function Turn( placePosition :GlobalCoords, rotateSegment :int,
         rotateDirection :int ) {
         
         m_placePosition = placePosition;
         m_rotateSegment = rotateSegment;
         m_rotateDirection = rotateDirection;
      }
      
      public function applyTurn( fields :Array, color :PlayerColor ) :Array {
      	var result :Array = new Array();
      	
      	// Temporarily set the field in the source array. This enables us to
      	// compute the rotation a lot more easily.
      	var oldFieldColor :PlayerColor = fields[ m_placePosition.x ][ m_placePosition.y ];
      	fields[ m_placePosition.x ][ m_placePosition.y ] = color;
      	
      	for ( var currentCol :int = 0; currentCol < Constants.BOARD_SIZE; ++currentCol ) {
      		result.push( fields[ currentCol ].slice() );
         }
         
         var startX :int;
         var startY :int;
         
         switch ( m_rotateSegment ) {
         	case 0:
               startX = 0;
               startY = 0;
               break;
            case 1:
               startX = Constants.SEGMENT_SIDE_FIELDS;
               startY = 0;
               break;
            case 2:
               startX = 0;
               startY = Constants.SEGMENT_SIDE_FIELDS;
               break;
            case 3:
               startX = Constants.SEGMENT_SIDE_FIELDS;
               startY = Constants.SEGMENT_SIDE_FIELDS;
               break;
            default:
               throw new Error( "Invalid segment to rotate" );
         }
         
         // We have to decleare them outside the loops because otherwise there
         // would be duplicate definitions. The ActionScript scope rules are
         // just plain stupid when it comes to for loops.
         var i :int;
         var j :int;
         if ( rotateDirection < 0 ) {
         	// Counter-clockwise rotation.
         	for ( i = startX; i < Constants.SEGMENT_SIDE_FIELDS; ++i ) {
         		for ( j = startY; j < Constants.SEGMENT_SIDE_FIELDS; ++j ) {
         			result[ startX + i ][ startY + j ] = fields[ startX + 2 - j ][ startY + i ];
         		}
         	}
         } else if ( rotateDirection > 0 ) {
         	// Clockwise rotation.
         	for ( i = startX; i < Constants.SEGMENT_SIDE_FIELDS; ++i ) {
               for ( j = startY; j < Constants.SEGMENT_SIDE_FIELDS; ++j ) {
                  result[ startX + i ][ startY + j ] = fields[ startX + 2 + j ][ startY + i ];
               }
            }
         }
      	
      	// Restore the old field in the source array.
      	fields[ m_placePosition.x ][ m_placePosition.y ] = oldFieldColor;
      	
         return result;
      }
      
      public function get placePosition() :GlobalCoords {
         return m_placePosition;
      }
      
      public function get rotateSegment() :int {
         return m_rotateSegment;
      }
      
      public function get rotateDirection() :int {
         return m_rotateDirection;
      }
   	
      private var m_placePosition :GlobalCoords;
      private var m_rotateSegment :int;
      private var m_rotateDirection :int;
   }
}
