package at.klickverbot.takefive.model {

   /**
    * @author David Nadlinger
    */
   public class SegmentCoords {
   	public function SegmentCoords( segment :int, field :int ) {
   		m_segment = segment;
   		m_field = field;
   	}
   	
   	public function get segment() :int {
   		return m_segment;
   	}
   	
   	public function set segment( segment :int ) :void {
   		m_segment = segment;
   	}
   	
   	public function get field() :int {
         return m_field;
      }
      
      public function set field( field :int ) :void {
         m_field = field;
      }
   	
   	private var m_segment :int;
   	private var m_field :int;
   }
}
