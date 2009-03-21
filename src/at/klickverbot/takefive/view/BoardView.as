package at.klickverbot.takefive.view {
   import at.klickverbot.takefive.model.Board;
   import at.klickverbot.takefive.model.PlayerColor;
   import at.klickverbot.takefive.view.SegmentView;
   import at.klickverbot.util.DummyUtils;
   
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;      

   /**
    * Displays the game board and allows the user to make his moves.
    * 
    * @author David Nadlinger
    */
   public class BoardView extends Sprite {
   	/**
       * Constructs a new BoardView instance.
       * 
       * @param model The game model to operate on.
       * @param humanColor The color of the human player. null for two human players.  
       */
      public function BoardView( model :Board, humanColor :PlayerColor ) {
         m_model = model;
      	addEventListener( Event.ADDED_TO_STAGE, createUi );
      	
      	m_segmentViews = new Array();
         m_segmentViews.push( new SegmentView( model, m_model.segments[ 0 ], humanColor, Corner.TOP_LEFT ) );
         m_segmentViews.push( new SegmentView( model, m_model.segments[ 1 ], humanColor, Corner.TOP_RIGHT ) );
         m_segmentViews.push( new SegmentView( model, m_model.segments[ 2 ], humanColor, Corner.BOTTOM_LEFT ) );
         m_segmentViews.push( new SegmentView( model, m_model.segments[ 3 ], humanColor, Corner.BOTTOM_RIGHT ) );
      }
      
      public function reset() :void {
         m_segmentViews.forEach( function( v :SegmentView, ...a ) :void { v.reset(); } );
      }
      
      private function createUi( event :Event ) :void {
        	var currentView :SegmentView;
         for ( var i :int = 0; i < m_segmentViews.length; i++ ) {
         	currentView = m_segmentViews[ i ]; 
            addChild( currentView );
            DummyUtils.fitToDummy( currentView,
               DisplayObjectContainer( getChildByName( "segment" + i ) ) );
         }
      }
      
      private var m_model :Board;
      private var m_segmentViews :Array;
   }
}
