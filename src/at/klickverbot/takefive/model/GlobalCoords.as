package at.klickverbot.takefive.model {

   /**
    * @author David Nadlinger
    */
   public class GlobalCoords {
   	public function GlobalCoords( x :int, y :int ) {
   		m_x = x;
   		m_y = y;
   	}
   	
   	public function addAssign( rhs :GlobalCoords ) :void {
   		m_x += rhs.m_x;
   		m_y += rhs.m_y;
   	}

      public function get x() :int {
   		return m_x;
   	}
   	
   	public function set x( x :int ) :void {
   		m_x = x;
   	}
   	
   	public function get y() :int {
         return m_y;
      }
      
      public function set y( y :int ) :void {
         m_y = y;
      }
      
      public function clone() :GlobalCoords {
      	return new GlobalCoords( m_x, m_y );
      }
      
   	private var m_x :int;
   	private var m_y :int;
   }
}
