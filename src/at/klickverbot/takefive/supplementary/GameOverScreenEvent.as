package at.klickverbot.takefive.supplementary {
   import flash.events.Event;
   
   /**
    * @author David Nadlinger
    */
   public class GameOverScreenEvent extends Event {
      public function GameOverScreenEvent( type :String ) {
         super( type, false, false );
      }
      
      public static const AGAIN :String = "again";
      public static const MENU :String = "menu";
   }
}
