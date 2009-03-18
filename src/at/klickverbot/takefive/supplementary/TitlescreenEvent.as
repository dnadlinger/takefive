package at.klickverbot.takefive.supplementary {
   import flash.events.Event;
   
   /**
    * @author David Nadlinger
    */
   public class TitleScreenEvent extends Event {
      public function TitleScreenEvent( type :String ) {
         super( type, false, false );
      }
      
      public static const ONE_PLAYER :String = "onePlayer";
      public static const TWO_PLAYERS :String = "twoPlayers";
   }
}
