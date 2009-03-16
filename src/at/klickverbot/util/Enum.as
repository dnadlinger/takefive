package at.klickverbot.util {
   import flash.errors.IllegalOperationError;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;   

   /**
    * An abstract base class to aid in creating "fake" enumerations.
    * Adapted from http://blog.petermolgaard.com/2008/11/02/actionscript-3-enums/.
    * 
    * @author David Nadlinger
    */
   public class Enum {
      public function Enum() {
         var className :String = getQualifiedClassName( this );
         if ( m_sLocks[ className ] ) {
            throw new IllegalOperationError( "Cannot instantiate anymore: " + className );
         }
      }

      public function get label() :String {
         return m_label;
      }
      
      /**
       * Records all initialized Enums classes to prohibit initialization after
       * the constants are created. 
       */
      protected static var m_sLocks :Dictionary = new Dictionary();

      /**
       * Initializes the enum, should be called in the static constructor.
       */
      protected static function initEnum( enumType :Class ) :void {
         var className :String = getQualifiedClassName( enumType );
         var typeXML :XML = describeType( enumType );
         for each ( var constant :XML in typeXML[ "constant" ] ) {
            enumType[ constant.@name ].m_label = constant.@name;
         }
         m_sLocks[ className ] = true;
      }

      /**
       * Enum label.
       */
      private var m_label :String;
   }
}