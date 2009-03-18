package at.klickverbot.takefive.algorithm {
   import at.klickverbot.takefive.model.PlayerColor;   
   import at.klickverbot.takefive.model.GlobalCoords;   
   
   /**
    * @author David Nadlinger
    */
   public class Line {
   	public function Line( start :GlobalCoords, direction :GlobalCoords, length :int, color :PlayerColor ) {
         m_start = start;
   		m_direction = direction;
   		m_length = length;
   		m_color = color;
   	}
   	
   	public function get start() :GlobalCoords {
   		return m_start;
   	}
   	
   	public function set start( start :GlobalCoords ) :void {
         m_start = start;
      }
      
      public function get direction() :GlobalCoords {
         return m_direction;
      }
      
      public function set direction( direction :GlobalCoords ) :void {
         m_direction = direction;
      }
      
      public function get length() :int {
         return m_length;
      }
      
      public function set length( length :int ) :void {
         m_length = length;
      }
      
      public function get color() :PlayerColor {
         return m_color;
      }
      
      public function set color( color :PlayerColor ) :void {
         m_color = color;
      }

      private var m_start :GlobalCoords;
   	private var m_direction :GlobalCoords;
   	private var m_length :int;
   	private var m_color :PlayerColor;
   }
}
