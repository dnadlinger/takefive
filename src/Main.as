package {
   import at.klickverbot.takefive.model.GameModel;
   import at.klickverbot.takefive.view.GameView;
   
   import flash.display.Sprite;   

   /**
    * @author David Nadlinger
    */
   public class Main extends Sprite {
      public function Main() {
      	var model :GameModel = new GameModel();
      	var view :GameView = new GameView( model );
      	addChild( view );
      }
   }
}
