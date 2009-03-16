package at.klickverbot.takefive.algorithm {
   import at.klickverbot.takefive.model.GlobalCoords;   
   
   /**
    * @author David Nadlinger
    */
   public class Line {
   	public function Line( start :GlobalCoords, direction :GlobalCoords, length :int ) {
   		m_start = start;
   		m_direction = direction;
   		m_length = length;
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

      private var m_start :GlobalCoords;
   	private var m_direction :GlobalCoords;
   	private var m_length :int;
   }
}
