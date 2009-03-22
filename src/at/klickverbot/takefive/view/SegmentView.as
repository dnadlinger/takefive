package at.klickverbot.takefive.view {
   import at.klickverbot.takefive.model.Board;
   import at.klickverbot.takefive.model.Constants;
   import at.klickverbot.takefive.model.FieldEvent;
   import at.klickverbot.takefive.model.PlayerColor;
   import at.klickverbot.takefive.model.Segment;
   import at.klickverbot.takefive.model.SegmentRotatedEvent;
   import at.klickverbot.takefive.model.TurnPhase;
   import at.klickverbot.takefive.model.TurnPhaseEvent;
   import at.klickverbot.util.DummyUtils;
   
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;   

   /**
    * Displays a segment of the game board and allows the user to place stones
    * and rotate it. 
    * 
    * @author David Nadlinger
    */
   public class SegmentView extends Sprite {
   	/**
   	 * Constructs a new SegmentView instance.
   	 * 
   	 * @param game The game model to operate on.
   	 * @param segment The segment model to operate on.
   	 * @param humanColor The color of the human player. null for two human players.
   	 * @param freeCorner The corner of the segment which points outwards
   	 *                   (the animations are played in this direction).
   	 */
      public function SegmentView( board :Board, segment :Segment,
         humanColor :PlayerColor, freeCorner :Corner ) {
         m_boardModel = board;
      	m_segmentModel = segment;
      	m_humanColor = humanColor;
         m_freeCorner = freeCorner;

         addEventListener( Event.ADDED_TO_STAGE, createUi );
      }
      
      public function reset() :void {
         for ( var i :int = 0; i < Constants.FIELDS_PER_SEGMENT; ++i ) {
            var currentField :DisplayObject = m_fieldClips[ i ];
            if ( currentField != null ) {
               m_fieldsContainer.removeChild( currentField );
            }
            m_fieldClips[ i ] = null;
         }
         
         resetRotation();
      }
      
      private function createUi( event :Event ) :void {
      	m_rotatingContainer = DisplayObjectContainer( getChildByName( "rotating" ) ); 
      	m_fieldsContainer = DisplayObjectContainer( m_rotatingContainer.getChildByName( "fields" ) );
      	
      	resetRotation();
      	
      	m_fieldDummies = new Array();
      	m_fieldClips = new Array();
      	var currentDummy :DisplayObject;
         for ( var i :int = 0; i < Constants.FIELDS_PER_SEGMENT; ++i ) {
         	currentDummy = m_fieldsContainer.getChildByName( "field" + i );
            m_fieldDummies.push( currentDummy );
            currentDummy.addEventListener( MouseEvent.CLICK, handleFieldClick );
         }
         
         // Don't add them to the display list yet, since they are needed only
         // in the rotation state.
         m_arrowCcw = new ArrowCcw();
         m_arrowCcw.addEventListener( MouseEvent.CLICK, handleArrowCcwClick );
         
         m_arrowCw = new ArrowCw();
         m_arrowCw.addEventListener( MouseEvent.CLICK, handleArrowCwClick );
         
         m_arrowsVisible = false;
         
         // TODO: Synchronize with model state.

         m_segmentModel.addEventListener( FieldEvent.CHANGED, handleFieldChange );
         m_segmentModel.addEventListener( SegmentRotatedEvent.ROTATED, handleSegmentRotation );
         m_boardModel.addEventListener( TurnPhaseEvent.CHANGED, handleTurnPhaseChange );
      }
      
      private function resetRotation() :void {
      	switch ( m_freeCorner ) {
            case Corner.TOP_LEFT:
               this.rotation = 0;
               m_fieldsContainer.rotation = 0;
               break;
            case Corner.TOP_RIGHT:
               this.rotation = 90;
               m_fieldsContainer.rotation = -90;
               break;
            case Corner.BOTTOM_LEFT:
               this.rotation = -90;
               m_fieldsContainer.rotation = 90;
               break;
            case Corner.BOTTOM_RIGHT:
               this.rotation = 180;
               m_fieldsContainer.rotation = -180;
               break;
         }
      }
      
      private function handleFieldClick( event :MouseEvent ) :void {
      	if ( ( m_humanColor && ( m_boardModel.activePlayer != m_humanColor ) ) ||
            m_boardModel.currentPhase != TurnPhase.PLACE ) {
            return;
         }
      	
      	var fieldIndex :int;
      	for ( var i :int = 0; i < m_fieldDummies.length; i++ ) {
      		if ( m_fieldDummies[ i ] == event.currentTarget ) {
               fieldIndex = i;
               break;
            }
      	}
      	
       	m_segmentModel.placeStone( fieldIndex, m_boardModel.activePlayer );
      }
      
      private function handleArrowCcwClick( event :MouseEvent ) :void {
         m_segmentModel.rotateCcw();
      }
      
      private function handleArrowCwClick( event :MouseEvent ) :void {
         m_segmentModel.rotateCw();
      }
      
      private function handleFieldChange( event :FieldEvent ) :void {
      	if ( m_fieldClips[ event.fieldIndex ] != null ) {
      		removeChild( m_fieldClips[ event.fieldIndex ] );
      	}
      	
         var stone :Sprite;
         if ( event.newState == PlayerColor.BLACK ) {
         	stone = new BlackStone();
         } else if ( event.newState == PlayerColor.WHITE ) {
         	stone = new WhiteStone();
         }
         
         m_fieldsContainer.addChild( stone );
         DummyUtils.fitToDummy( stone, m_fieldDummies[ event.fieldIndex ] );
         
         m_fieldClips[ event.fieldIndex ] = stone;
      }
      
      private function handleSegmentRotation( event :SegmentRotatedEvent ) :void {
      	m_rotatingContainer.rotation += event.angle * 90;
      }

      private function handleTurnPhaseChange( event :TurnPhaseEvent ) :void {      	
      	// Show/hide rotation arrows.
      	if ( ( event.newPhase == TurnPhase.ROTATE ) && humanPlayerActive() ) {
      		addChild( m_arrowCcw );
            DummyUtils.fitToDummy( m_arrowCcw, getChildByName( "arrowCcw" ) );
            
            addChild( m_arrowCw );
            DummyUtils.fitToDummy( m_arrowCw, getChildByName( "arrowCw" ) );
            
            m_arrowsVisible = true;
         } else if ( ( event.oldPhase == TurnPhase.ROTATE ) && m_arrowsVisible ) {
      		removeChild( m_arrowCcw );
            removeChild( m_arrowCw );
            m_arrowsVisible = false;
      	}
      }
      
      private function humanPlayerActive() :Boolean {
      	return ( m_humanColor == null ) || ( m_boardModel.activePlayer == m_humanColor );
      }

      private var m_boardModel :Board;
      private var m_segmentModel :Segment;
      private var m_humanColor :PlayerColor;
      private var m_freeCorner :Corner;

      private var m_rotatingContainer :DisplayObjectContainer;
      private var m_fieldsContainer :DisplayObjectContainer;
      private var m_fieldDummies :Array;
      private var m_fieldClips :Array;
      
      private var m_arrowCw :DisplayObject;
      private var m_arrowCcw :DisplayObject;
      private var m_arrowsVisible :Boolean;
   }
}
