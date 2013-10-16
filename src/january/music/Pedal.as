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
			mode = !mode;
				
			if (mode == true)
				Game.feedback.show("Pedal Point: On");
			else
				Game.feedback.show("Pedal Point: Off");
		}
	}
}