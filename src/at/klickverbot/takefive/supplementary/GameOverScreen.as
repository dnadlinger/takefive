package at.klickverbot.takefive.supplementary {
   import at.klickverbot.takefive.model.PlayerColor;
   
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;      

   /**
    * @author David Nadlinger
    */
   public class GameOverScreen extends Sprite {
      public function GameOverScreen( winningPlayer :PlayerColor ) {
         m_winningPlayer = winningPlayer;
      	
      	addEventListener( Event.ADDED_TO_STAGE, createUi );
      }
      
      private function createUi( event :Event ) :void {
      	var winningMessage :String;
      	if ( m_winningPlayer == PlayerColor.BLACK ) {
            winningMessage = "Black";
      	} else if ( m_winningPlayer == PlayerColor.WHITE ) {
      		winningMessage = "White";
      	}
      	winningMessage += " wins!";
      	
         TextField( getChildByName( "winningText" ) ).text = winningMessage;
         getChildByName( "againButton" ).addEventListener( MouseEvent.CLICK, handleAgainClick );
         getChildByName( "menuButton" ).addEventListener( MouseEvent.CLICK, handleMenuClick );
      }
      
      private function handleAgainClick( event :MouseEvent ) :void {
      	dispatchEvent( new GameOverScreenEvent( GameOverScreenEvent.AGAIN ) );
      }
      
      private function handleMenuClick( event :MouseEvent ) :void {
      	dispatchEvent( new GameOverScreenEvent( GameOverScreenEvent.MENU ) );
      }
      
      private var m_winningPlayer :PlayerColor;
   }
}
