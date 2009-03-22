package at.klickverbot.takefive.ai {
   import at.klickverbot.takefive.algorithm.Line;   
   import at.klickverbot.takefive.algorithm.LineSearcher;   
   import at.klickverbot.takefive.model.GlobalCoords;   
   import at.klickverbot.takefive.model.Constants;   
   import at.klickverbot.takefive.model.Board;
   import at.klickverbot.takefive.model.PlayerColor;
   import at.klickverbot.takefive.model.SegmentCoords;
   import at.klickverbot.takefive.model.TurnPhase;
   import at.klickverbot.takefive.model.TurnPhaseEvent;   

   /**
    * @author David Nadlinger
    */
   public class AiPlayer {
   	public function AiPlayer( board :Board, color :PlayerColor, strength :int ) {
         m_board = board;
         m_color = color;
         m_strength = strength;
         board.addEventListener( TurnPhaseEvent.CHANGED, handleTurnPhaseChange );
      }
   	
   	private function handleTurnPhaseChange( event :TurnPhaseEvent ) :void {
   		if ( event.newPhase == TurnPhase.PLACE ) {
   			if ( m_board.activePlayer == m_color ) {
   				makeTurn();
   			}
   		}
   	}
   	
   	private function makeTurn() :void {
   		var turn :Turn = getBestTurn();
   		var segmentCoords :SegmentCoords = m_board.globalToSegment( turn.placePosition );
         m_board.segments[ segmentCoords.segment ].placeStone( segmentCoords.field, m_color );
         m_board.segments[ turn.rotateSegment ].rotate( turn.rotateDirection ); 
      }
      
      private function getBestTurn() :Turn {
      	var fields :Array = m_board.getFieldsArray();
      	var turns :Array = getPossibleTurns( fields );
      	
      	var turnScores :Array = new Array();
      	var bestScore :int = int.MIN_VALUE;
         for ( var i :int = 0; i < turns.length; i++ ) {
      		var currentScore :int = -alphaBeta( turns[ i ].applyTurn( fields, m_color ),
               m_strength, int.MIN_VALUE, int.MAX_VALUE );
      		turnScores.push( currentScore );
      		if ( currentScore > bestScore ) {
               bestScore = currentScore;
            }
      	}
      	
         for ( var turnIndex :int = 0; turnIndex < turnScores.length; turnIndex++ ) {
            if ( turnScores[ turnIndex ] == bestScore ) {
            	return turns[ turnIndex ]; 
            }
         }
         
         // This cannot happen, just here to satisfy the compiler.
         return null; 
      }
      
      private function getPossibleTurns( fields :Array ) :Array {
      	var result :Array = new Array();
      	
      	var asymSegs :Array = new Array();
      	if ( isSegmentAsymmetric( fields, 0, 0 ) ) {
      		asymSegs.push( 0 );
      	}
      	if ( isSegmentAsymmetric( fields, 0, 1 ) ) {
            asymSegs.push( 1 );
         }
         if ( isSegmentAsymmetric( fields, 1, 0 ) ) {
            asymSegs.push( 2 );
         }
         if ( isSegmentAsymmetric( fields, 1, 1 ) ) {
            asymSegs.push( 3 );
         }
      	
      	for ( var i :int = 0; i < Constants.BOARD_SIZE; ++i ) {
      		for ( var j :int = 0; j < Constants.BOARD_SIZE; ++j ) {
      			if ( !fields[ i ][ j ] ) {
      				var coords :GlobalCoords = new GlobalCoords( i, j );
                  if ( asymSegs.length > 0 ) {
                     for ( var k :int = 0; k < asymSegs.length; ++k ) {
                        result.push( new Turn( coords, asymSegs[ k ], -1 ) );
      				  	   result.push( new Turn( coords, asymSegs[ k ], 1 ) );
                     }
                     if ( asymSegs.length != Constants.SEGMENT_COUNT ) {
                     	result.push( new Turn( coords, 0, 0 ) );
                     }
      				} else {
      					result.push( new Turn( coords, 0, 0 ) );
      				}
      			}
      		}
      	}
      	
      	return result;
      }
      
      private function alphaBeta( fields :Array, remainingLevels: int, alpha :int, beta :int ) :int {
      	if ( remainingLevels == 0 ) {
      		return evaluateBoard( fields );
      	}
      	
         var turns :Array = getPossibleTurns( fields );
         // Stop recursion if there are no more possible turns.
         if ( turns.length == 0 ){
         	return evaluateBoard( fields );
         }
         
         // "Cheating" to get the active player.
         // In even levels (zero based), it is the opponent's turn (because we
         // already have made one turn when the alpha-beta search is started in
         // getBestTurn()), in uneven levels, it is our turn.
         // We are always the active player...
         var activePlayer :PlayerColor =
            ( ( m_strength - remainingLevels ) % 2 ) ? m_board.activePlayer : m_board.inactivePlayer;
         
         var best :int = int.MIN_VALUE;
         for ( var i :int = 0; i < turns.length; i++ ) {
         	if ( best > alpha ) {
         		alpha = best;
         	}
         	
         	var score :int = -alphaBeta( turns[ i ].applyTurn( fields, activePlayer ),
         	  remainingLevels-1, -beta, -alpha );
         	
         	if ( score > best ) {
         		best = score;
         	}
         	if ( score >= beta ) {
               break;
            }
         }
         return best;
      }      
      
      private function evaluateBoard( fields :Array ) :int {
      	var totalScore :int = 0;
         
         var lines :Array = LineSearcher.findLines( fields, 2 );
         // TODO: Sensible line rating.
         for ( var i :int = 0; i < lines.length; i++ ) {
         	var currentLine :Line = lines[ i ];
         	var lineScore :int = Math.pow( currentLine.length, 5 );
            if ( currentLine.color == m_color ) {
         		totalScore += lineScore;
            } else {
            	totalScore -= lineScore;
            }
         }
         
         // The segment centers are important positions.
         totalScore += scoreField( fields, 1, 1, 50 );
         totalScore += scoreField( fields, 4, 1, 50 );
         totalScore += scoreField( fields, 1, 4, 50 );
         totalScore += scoreField( fields, 4, 4, 50 );
         
         return totalScore;
      }
      
      private function scoreField( fields :Array, x :int, y :int, score :int ) :int {
      	if ( fields[ x ][ y ] != null ) {
            if ( fields[ x ][ y ] == m_color ) {
               return score;
            } else {
            	return -score;
            }
         } else {
         	return 0;
         }
      }
      
      private function isSegmentAsymmetric( fields :Array, segmentX :int, segmentY :int ) :Boolean {
      	var x :int = segmentX * Constants.SEGMENT_SIDE_FIELDS;
      	var y :int = segmentY * Constants.SEGMENT_SIDE_FIELDS;
      	return ( fields[ x ][ y ] != null ) || ( fields[ x + 1 ][ y ] != null ) || ( fields[ x + 2 ][ y ] != null ) ||
      	  ( fields[ x ][ y + 1 ] != null ) || ( fields[ x + 2 ][ y + 1 ] != null ) ||
      	  ( fields[ x ][ y + 2 ] != null ) || ( fields[ x + 1 ][ y + 2 ] != null ) || ( fields[ x + 2 ][ y + 2 ] != null );
      }

      private var m_board :Board;
   	private var m_color :PlayerColor;
   	private var m_strength :int;
   }
}
