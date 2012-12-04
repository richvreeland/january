package january.music
{	
	import january.*;
	
	import org.flixel.*;
	
	public class Playback
	{
		/** Used to instantiate Note.lastRecorded, and push to the playbackSequence. */
		public static var note	   : Class;	
		/** Current playbackSequence of notes being cycled through */
		public static var sequence : Array = [];		
		/** Current position in playbackSequence array */
		public static var index	   : int = 0;		
		/** The text sprite used to display number feedback. */
		public static var numbers: Text;
		/** Whether or not Playback mode is in reverse. */
		public static var reverse: Boolean;

		public static function modes():void
		{
			if (FlxG.keys.justPressed("LBRACKET"))
			{
				if (Snowflake.mode == "Interject")
				{
					Snowflake.mode = "Playback";
					Game.secretFeedback.show("Repeat");
				}
				else
				{
					Snowflake.mode = "Record";
					sequence = [];
					index = 0;
					reverse = false;
					Game.secretFeedback.show("Create");
				}
			}
			if (FlxG.keys.justPressed("RBRACKET"))
			{
				if (Snowflake.mode == "Record")
				{
					Snowflake.mode = "Playback";
					Game.secretFeedback.show("Repeat");
				}
				else
				{
					Snowflake.mode = "Interject";
					Game.secretFeedback.show("Detour");
				}
			}
		}
		
		public static function reversal():void
		{
			if (FlxG.keys.justPressed("R") && Snowflake.mode == "Playback")
			{			
				reverse = !reverse;
				
				if (reverse == true)
				{
					index -= 2;
					if (index < 0)
						index = index + sequence.length;
					
					// play "1", out of "4". reverse. 0 - 2 = -2. -2 + 5 = [3] plays "4", shows "3"
				}
				else
				{
					index += 2;
					if (index > sequence.length - 1)
						index = index - sequence.length;
					
					// i[4] is max, just played "5". index = 6. if index > 4, index = 6 - 5 = 1;
				}
				
				Game.secretFeedback.show("Reverse");
			}
		}
	}
}