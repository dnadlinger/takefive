package at.klickverbot.takefive.view {
   import at.klickverbot.takefive.supplementary.GameOverScreenEvent;   
   import at.klickverbot.takefive.supplementary.GameOverScreen;   
   import at.klickverbot.takefive.model.GameState;   
   import at.klickverbot.takefive.model.GameStateChangedEvent;   
   import at.klickverbot.takefive.model.GameModel;
   import at.klickverbot.takefive.model.PlayerColor;
   import at.klickverbot.util.DummyUtils;
   
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;      

   /**
    * The top-level game view.
    * 
    * @author David Nadlinger
    */
   public class GameView extends Sprite {
   	/**
   	 * Constructs a new GameView instance.
   	 * 
   	 * @param model The game model to operate on.
   	 * @param humanColor The color of the human player. null for two human players.  
   	 */
   	public function GameView( model :GameModel, humanColor :PlayerColor ) {
         m_gameModel = model;
         m_humanColor = humanColor;
   	  
   	  addEventListener( Event.ADDED_TO_STAGE, createUi );
      }
      
      private function createUi( event :Event ) :void {
      	m_boardView = new BoardView( m_gameModel, m_humanColor );
      	addChild( m_boardView );
         DummyUtils.fitToDummy( m_boardView, getChildByName( "board" ) );
         m_gameModel.addEventListener( GameStateChangedEvent.CHANGED, handleGameStateChange );
      }
      
      
      private function handleGameStateChange( event :GameStateChangedEvent ) :void {
      	if ( event.newState == GameState.GAME_OVER ) {
            m_gameOverScreen = new GameOverScreen( m_gameModel.lastWinner );
            m_gameOverScreen.addEventListener( GameOverScreenEvent.AGAIN, handleGameOverAgain );
            m_gameOverScreen.addEventListener( GameOverScreenEvent.MENU, handleGameOverMenu );
            addChild( m_gameOverScreen );
         } else if ( event.oldState == GameState.GAME_OVER ) {
         	removeChild( m_gameOverScreen );
         }
      }
      
      private function handleGameOverAgain( event :GameOverScreenEvent ) :void {
         m_gameModel.resetBoard();
      }
      
      private function handleGameOverMenu( event :GameOverScreenEvent ) :void {
      	dispatchEvent( new Event( Event.COMPLETE ) );
      }

      private var m_gameModel :GameModel;
      private var m_humanColor :PlayerColor;

      private var m_boardView :BoardView;
      private var m_gameOverScreen :GameOverScreen;
   }
}
