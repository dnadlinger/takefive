package {
   import at.klickverbot.takefive.ai.AiPlayer;   
   import at.klickverbot.takefive.model.PlayerColor;   
   import at.klickverbot.takefive.supplementary.TitleScreenEvent;   
   import at.klickverbot.takefive.supplementary.TitleScreen;   
   import at.klickverbot.takefive.model.GameModel;
   import at.klickverbot.takefive.view.GameView;
   
   import flash.display.Sprite;
   import flash.events.Event;   

   /**
    * @author David Nadlinger
    */
   public class Main extends Sprite {
      public function Main() {
      	m_titlescreen = new TitleScreen();
      	m_titlescreen.addEventListener( TitleScreenEvent.ONE_PLAYER, handleOnePlayer );
      	m_titlescreen.addEventListener( TitleScreenEvent.TWO_PLAYERS, handleTwoPlayers );
         addChild( m_titlescreen );
      }
      
      private function handleOnePlayer( event :Event ) :void {
      	removeChild( m_titlescreen );
      	
      	var model :GameModel = new GameModel();
      	var opponent :AiPlayer = new AiPlayer( model.board, PlayerColor.BLACK, 1 );
      	
         m_gameView = new GameView( model, PlayerColor.WHITE );
         m_gameView.addEventListener( Event.COMPLETE, handleGameComplete );
         addChild( m_gameView );
      }
      
      private function handleTwoPlayers( event :Event ) :void {
      	removeChild( m_titlescreen );
      	
         var model :GameModel = new GameModel();
         
         m_gameView = new GameView( model, null );
         m_gameView.addEventListener( Event.COMPLETE, handleGameComplete );
         addChild( m_gameView );
      }
      
      private function handleGameComplete( event :Event ) :void {
      	removeChild( m_gameView );
         addChild( m_titlescreen );
      }
      
      private var m_titlescreen :TitleScreen;
      private var m_gameView :GameView;
   }
}
