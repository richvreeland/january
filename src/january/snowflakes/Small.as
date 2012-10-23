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
			
			_windY = 10;
			_pointValue = 1;
			_volume = Helpers.rand(0.1, 0.25);
		}
		
		public override function onLick():void
		{							
			super.onLick();			
			
			playNote();
		}

	}
}