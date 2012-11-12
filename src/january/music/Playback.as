package january.music
{	
	public class Playback
	{
		/** Used to instantiate Note.lastRecorded, and push to the playbackSequence. */
		public static var note	   : Class = null;	
		/** Current playbackSequence of notes being cycled through */
		public static var sequence : Array = [];		
		/** Current position in playbackSequence array */
		public static var index	   : int = 0;		
		/** Whether playbackSequence is being looped through */
		public static var mode	   : Boolean = false;
	}
}