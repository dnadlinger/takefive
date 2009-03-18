package at.klickverbot.takefive.view {
   import at.klickverbot.takefive.model.Constants;   
   import at.klickverbot.takefive.model.SegmentRotatedEvent;   
   import at.klickverbot.takefive.model.GameState;   
   import at.klickverbot.takefive.model.GameStateChangedEvent;   
   import at.klickverbot.takefive.model.FieldEvent;
   import at.klickverbot.takefive.model.PlayerColor;
   import at.klickverbot.takefive.model.GameModel;
   import at.klickverbot.takefive.model.Segment;
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
      public function SegmentView( game :GameModel, segment :Segment,
         humanColor :PlayerColor, freeCorner :Corner ) {
         m_gameModel = game;
      	m_segmentModel = segment;
      	m_humanColor = humanColor;
         m_freeCorner = freeCorner;

         addEventListener( Event.ADDED_TO_STAGE, createUi );
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
         
         // TODO: Synchronize with model state.

         m_segmentModel.addEventListener( FieldEvent.CHANGED, handleFieldChange );
         m_segmentModel.addEventListener( SegmentRotatedEvent.ROTATED, handleSegmentRotation );
         m_gameModel.addEventListener( GameStateChangedEvent.CHANGED, handleGameStateChange );
      }
      
      private function reset() :void {
      	for ( var i :int = 0; i < Constants.FIELDS_PER_SEGMENT; ++i ) {
            var currentField :DisplayObject = m_fieldClips[ i ];
            if ( currentField != null ) {
            	m_fieldsContainer.removeChild( currentField );
            }
            m_fieldClips[ i ] = null;
         }
         
         resetRotation();
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
      	if ( ( m_humanColor && ( m_gameModel.activePlayer != m_humanColor ) ) ||
            m_gameModel.gameState != GameState.PLACE ) {
            return;
         }
      	
      	var fieldIndex :int;
      	for ( var i :int = 0; i < m_fieldDummies.length; i++ ) {
      		if ( m_fieldDummies[ i ] == event.currentTarget ) {
               fieldIndex = i;
               break;
            }
      	}
      	
       	m_segmentModel.placeStone( fieldIndex, m_gameModel.activePlayer );
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

      private function handleGameStateChange( event :GameStateChangedEvent ) :void {
      	// Show/hide rotation arrows.
      	if ( event.newState == GameState.ROTATE ) {
      		addChild( m_arrowCcw );
            DummyUtils.fitToDummy( m_arrowCcw, getChildByName( "arrowCcw" ) );
            
            addChild( m_arrowCw );
            DummyUtils.fitToDummy( m_arrowCw, getChildByName( "arrowCw" ) );
      	} else if ( event.oldState == GameState.ROTATE ) {
      		removeChild( m_arrowCcw );
            removeChild( m_arrowCw );
      	}
      	
      	if ( event.oldState == GameState.GAME_OVER ) {
      		reset();
      	}
      }

      private var m_gameModel :GameModel;
      private var m_segmentModel :Segment;
      private var m_humanColor :PlayerColor;
      private var m_freeCorner :Corner;

      private var m_rotatingContainer :DisplayObjectContainer;
      private var m_fieldsContainer :DisplayObjectContainer;
      private var m_fieldDummies :Array;
      private var m_fieldClips :Array;
      
      private var m_arrowCw :DisplayObject;
      private var m_arrowCcw :DisplayObject;
   }
}
