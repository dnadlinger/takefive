package at.klickverbot.takefive.view {
   import flash.display.DisplayObjectContainer;   
   
   import at.klickverbot.takefive.model.GameModel;
   import at.klickverbot.takefive.view.SegmentView;
   import at.klickverbot.util.DummyUtils;
   
   import flash.display.Sprite;
   import flash.events.Event;      

   /**
    * @author David Nadlinger
    */
   public class BoardView extends Sprite {
      public function BoardView( model :GameModel ) {
      	m_gameModel = model;
      	addEventListener( Event.ADDED_TO_STAGE, createUi );
      	
      	m_segmentViews = new Array();
         m_segmentViews.push( new SegmentView( model, m_gameModel.segments[ 0 ], Corner.TOP_LEFT ) );
         m_segmentViews.push( new SegmentView( model, m_gameModel.segments[ 1 ], Corner.TOP_RIGHT ) );
         m_segmentViews.push( new SegmentView( model, m_gameModel.segments[ 2 ], Corner.BOTTOM_LEFT ) );
         m_segmentViews.push( new SegmentView( model, m_gameModel.segments[ 3 ], Corner.BOTTOM_RIGHT ) );
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
      
      private var m_gameModel :GameModel;
      private var m_segmentViews :Array;
   }
}
