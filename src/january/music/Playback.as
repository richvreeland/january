package january.music
{	
	import january.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Playback
	{
		/** The current gameplay mode. */
		public static var mode: String = "Write";
		/** Current playbackSequence of notes being cycled through */
		public static var sequence : Array = [];		
		/** Current position in playbackSequence array */
		public static var index	   : int = 0;
		/** Whether or not Playback mode is in reverse. */
		public static var reverse: Boolean;
		/** The state of staccato mode. */
		public static var noteLength: String = "Full";

		/** Cycle through the playback modes. */
		public static function cycle(direction: String = "Left"):void
		{
			if (direction == "Left")
			{
				if (mode == "Detour")
					repeat();
				else
					write();
			}
			if (direction == "Right")
			{
				if (mode == "Write")
					repeat();
				else
					detour();
			}
		}
		
		public static function write():void
		{
			mode = "Write";
			sequence = [];
			index = 0;
			reverse = false;
			Game.feedback.show(mode);
		}
		
		public static function repeat():void
		{
			mode = "Repeat";
			Game.feedback.show(mode);
		}
		
		public static function detour():void
		{
			mode = "Detour";
			Game.feedback.show(mode);
		}
		
		/** Reset a sequence currently in writing, or restart a repeat sequence. */
		public static function resetRestart():void
		{
			if (mode != "Detour")
			{
				if (mode == "Write")
				{
					sequence = [];
					index = 0;
					Game.feedback.show("Reset");
				}
				else
				{
					index = 0;	
					Game.feedback.show("Restart");
				}	
			}
		}
		
		/** Reverse the note order of repeat sequence. */
		public static function polarity():void
		{
			if (mode == "Repeat")
			{			
				reverse = !reverse;
				
				if (reverse == true)
				{
					index -= 2;
					if (index < 0)
						index = index + sequence.length;
					
					Game.feedback.show("Backwards");
				}
				else
				{
					index += 2;
					if (index > sequence.length - 1)
						index = index - sequence.length;
					
					Game.feedback.show("Forwards");
				}
			}
		}
		
		public static function staccato():void
		{
			if (noteLength == "Full")
				noteLength = "Half";
			else if (noteLength == "Half")
				noteLength = "Random";
			else
				noteLength = "Full";
			
			Game.feedback.show("Note Length: " + noteLength);
		}
	}
}