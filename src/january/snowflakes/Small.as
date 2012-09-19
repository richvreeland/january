package january.snowflakes
{
	import january.*;
	import org.flixel.*;

	public class Small extends Snowflake
	{
		public function Small()
		{
			super();
			
			makeGraphic(1, 1);
			noteVolume = Helpers.rand(0.1, 0.5);
		}

	}
}