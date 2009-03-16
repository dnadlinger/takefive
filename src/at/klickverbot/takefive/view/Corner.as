package at.klickverbot.takefive.view {
   import at.klickverbot.util.Enum;
   
   /**
    * @author David Nadlinger
    */
   public class Corner extends Enum {
   	public static const TOP_LEFT :Corner = new Corner();
      public static const TOP_RIGHT :Corner = new Corner();
      public static const BOTTOM_RIGHT :Corner = new Corner();
      public static const BOTTOM_LEFT :Corner = new Corner();
      
      { initEnum( Corner ); }
   }
}
