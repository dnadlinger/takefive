package at.klickverbot.takefive.model {
   import at.klickverbot.util.Enum;
   
   /**
    * @author David Nadlinger
    */
   public class TurnPhase extends Enum {
      public static const PLACE :TurnPhase = new TurnPhase();
      public static const ROTATE :TurnPhase = new TurnPhase();

      { initEnum( TurnPhase ); }
   }
}
