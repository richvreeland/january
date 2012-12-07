package january.music
{	
	import january.*;
	import org.flixel.*;
	
	public class Playback
	{
		/** Current playbackSequence of notes being cycled through */
		public static var sequence : Array = [];		
		/** Current position in playbackSequence array */
		public static var index	   : int = 0;		
		/** The text sprite used to display number feedback. */
		public static var numbers: Text;
		/** Whether or not Playback mode is in reverse. */
		public static var reverse: Boolean;

		/** Use the keyboard to cycle through musical modes. */
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
					Game.secretFeedback.show("Write");
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
		
		/** Use the keyboard to reset a sequence currently in writing, or restart a playback sequence. */
		public static function resetRestart():void
		{
			if (FlxG.keys.justPressed("BACKSLASH") && Snowflake.mode != "Interject")
			{
				if (Snowflake.mode == "Record")
				{
					sequence = [];
					index = 0;
					Game.secretFeedback.show("Reset");
				}
				else
				{
					index = 0;	
					Game.secretFeedback.show("Restart");
				}	
			}
		}
		
		/** Use the keyboard to reverse the note order of playback. */
		public static function polarity():void
		{
			if (FlxG.keys.justPressed("ENTER") && Snowflake.mode == "Playback")
			{			
				reverse = !reverse;
				
				if (reverse == true)
				{
					index -= 2;
					if (index < 0)
						index = index + sequence.length;
					
					Game.secretFeedback.show("Backwards");
				}
				else
				{
					index += 2;
					if (index > sequence.length - 1)
						index = index - sequence.length;
					
					Game.secretFeedback.show("Forwards");
				}
			}
		}
	}
}