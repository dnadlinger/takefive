package at.klickverbot.takefive.view {
   import at.klickverbot.takefive.model.GameModel;
   import at.klickverbot.util.DummyUtils;
   
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;      

   /**
    * @author David Nadlinger
    */
   public class GameView extends Sprite {
   	public function GameView( model :GameModel ) {
   	  m_gameModel = model;
   	  
   	  addEventListener( Event.ADDED_TO_STAGE, createUi );
      }
      
      private function createUi( event :Event ) :void {
      	m_boardView = new BoardView( m_gameModel );
      	addChild( m_boardView );
         DummyUtils.fitToDummy( m_boardView, getChildByName( "board" ) );
      }


      private var m_gameModel :GameModel;
      private var m_boardView :BoardView;
   }
}
