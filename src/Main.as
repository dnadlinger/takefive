package {
   import at.klickverbot.takefive.supplementary.TitlescreenEvent;   
   import at.klickverbot.takefive.supplementary.Titlescreen;   
   import at.klickverbot.takefive.model.GameModel;
   import at.klickverbot.takefive.view.GameView;
   
   import flash.display.Sprite;
   import flash.events.Event;   

   /**
    * @author David Nadlinger
    */
   public class Main extends Sprite {
      public function Main() {
      	m_titlescreen = new Titlescreen();
      	m_titlescreen.addEventListener( TitlescreenEvent.ONE_PLAYER, handleOnePlayer );
      	m_titlescreen.addEventListener( TitlescreenEvent.TWO_PLAYERS, handleTwoPlayers );
         addChild( m_titlescreen );
      }
      
      private function handleOnePlayer( event :Event ) :void {
      	removeChild( m_titlescreen );
      	var model :GameModel = new GameModel();
         var view :GameView = new GameView( model );
         addChild( view );
      }
      
      private function handleTwoPlayers( event :Event ) :void {
      	removeChild( m_titlescreen );
         var model :GameModel = new GameModel();
         var view :GameView = new GameView( model );
         addChild( view );
      }
      
      private var m_titlescreen :Titlescreen;
   }
}
