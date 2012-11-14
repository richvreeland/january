package january.music
{
	import org.flixel.*;
	import january.*;
	
	public class Pedal
	{
		/** Whether or not we're in Pedal Point Mode. */
		public static var mode: Boolean = false;
		
		public static function toggle():void
		{
			if (FlxG.keys.justPressed("P"))
			{
				mode = !mode;
				
				if (mode == true)
					Game.secretFeedback.show("Pedal Point: On");
				else
					Game.secretFeedback.show("Pedal Point: Off");
			}
		}
	}
}