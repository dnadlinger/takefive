package at.klickverbot.takefive.algorithm {
   import at.klickverbot.takefive.model.Constants;
   import at.klickverbot.takefive.model.GlobalCoords;
   import at.klickverbot.takefive.model.IBoard;
   import at.klickverbot.takefive.model.PlayerColor;      

   /**
    * @author David Nadlinger
    */
   public class LineSearcher {
   	public static function findLines( board :IBoard, minLength :int = 2 ) :Array {
   		if ( minLength < 2 ) {
   			throw new ArgumentError( "A line must be at least two fields long." );
   		}
   		
   		if ( minLength > Constants.BOARD_SIZE ) {
   			return new Array();
   		}
   		
   		var lines :Array = new Array();
   		
   		// Search for vertical lines.
   		var direction :GlobalCoords = Directions.DOWN;
         for ( var currentCol :int = 0; currentCol < Constants.BOARD_SIZE; ++currentCol ) {
   			lines = lines.concat( search( board, minLength,
   			   new GlobalCoords( currentCol, 0 ), direction ) );
   		}
   		
   		// Search for horizontal lines.
   		direction = Directions.RIGHT;
         for ( var currentRow :int = 0; currentRow < Constants.BOARD_SIZE; ++currentRow ) {
            lines = lines.concat( search( board, minLength,
               new GlobalCoords( 0, currentRow ), direction ) );
         }
         
         // Search for diagonal (down-right) lines.
         direction = Directions.DOWN_RIGHT;
         lines = lines.concat( search( board, minLength,
            new GlobalCoords( 0, 0 ), direction ) );
         for ( var i :int = 0; i < ( Constants.BOARD_SIZE - minLength ); ++i ) {
            lines = lines.concat( search( board, minLength,
               new GlobalCoords( ( i + 1 ), 0 ), direction ) );
            lines = lines.concat( search( board, minLength,
               new GlobalCoords( 0, ( i + 1 ) ), direction ) );   
         }
         
         // Search for diagonal (down-left) lines.
         direction = Directions.DOWN_LEFT;
         const LAST_COL :int = Constants.BOARD_SIZE - 1;
         lines = lines.concat( search( board, minLength,
            new GlobalCoords( LAST_COL, 0 ), direction ) );
         for ( var j :int = 0; j < ( Constants.BOARD_SIZE  - minLength ); ++j ) {
            lines = lines.concat( search( board, minLength,
               new GlobalCoords( ( LAST_COL - j - 1 ), 0 ), direction ) );
            lines = lines.concat( search( board, minLength,
               new GlobalCoords( LAST_COL, ( j + 1 ) ), direction ) );   
         }

         return lines;
   	}

      private static function search( board :IBoard, minLength :int, 
         startPos :GlobalCoords, direction :GlobalCoords ) :Array {
      	
      	var result :Array = new Array();
      	
      	var currentPos :GlobalCoords = startPos.clone();
      	var lastColor :PlayerColor = null;
      	var lineLength :int = 0;
      	while ( ( currentPos.x < Constants.BOARD_SIZE ) &&
            ( currentPos.y < Constants.BOARD_SIZE ) ) {
            	
            var currentColor :PlayerColor = board.readAtGlobal( currentPos );
         	if ( currentColor != lastColor ) {
         		if ( lineLength >= minLength ) {
                  result.push( new Line( currentPos, direction, lineLength, lastColor ) );
               }
               lineLength = 0;
         	}
         	
         	if ( currentColor != null ) {
         	  ++lineLength;
         	}
         	
         	lastColor = currentColor;
      	  	currentPos.addAssign( direction );
         }
         
         // Check for a line not yet terminated.
         if ( lineLength >= minLength ) {
            result.push( new Line( currentPos, direction, lineLength, lastColor ) );
         }

      	return result;
      }
   }
}
