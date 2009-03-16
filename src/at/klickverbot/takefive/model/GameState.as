package at.klickverbot.takefive.model {
   import at.klickverbot.util.Enum;
   
   /**
    * @author David Nadlinger
    */
   public class GameState extends Enum {
      public static const PLACE :GameState = new GameState();
      public static const ROTATE :GameState = new GameState();
      public static const GAME_OVER :GameState = new GameState(); 

      { initEnum( GameState ); }
   }
}
