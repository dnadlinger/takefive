package at.klickverbot.takefive.supplementary {
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;   

   /**
    * @author David Nadlinger
    */
   public class TitleScreen extends Sprite {
      public function TitleScreen() {
      	addEventListener( Event.ADDED_TO_STAGE, createUi );
      }
      
      private function createUi( event :Event ) :void {
         var onePlayerButton :DisplayObject = getChildByName( "onePlayerButton" );
         onePlayerButton.addEventListener( MouseEvent.CLICK, handleOnePlayerClick );
         
         var twoPlayersButton :DisplayObject = getChildByName( "twoPlayersButton" );
         twoPlayersButton.addEventListener( MouseEvent.CLICK, handleTwoPlayersClick );
      }
      
      private function handleOnePlayerClick( event :MouseEvent ) :void {
      	dispatchEvent( new TitleScreenEvent( TitleScreenEvent.ONE_PLAYER ) );
      }
      
      private function handleTwoPlayersClick( event :MouseEvent ) :void {
         dispatchEvent( new TitleScreenEvent( TitleScreenEvent.TWO_PLAYERS ) );
      }
   }
}
