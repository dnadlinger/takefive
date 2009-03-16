package at.klickverbot.takefive.model {

   /**
    * @author David Nadlinger
    */
   public interface IBoard {
   	function readAtGlobal( coords :GlobalCoords ) :PlayerColor;
   	function globalToSegment( globalCoords :GlobalCoords ) :SegmentCoords;
   	function segmentToGlobal( segmentCoords :SegmentCoords ) :GlobalCoords;
   }
}
