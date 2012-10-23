package january.snowflakes
{
	import january.*;
	import org.flixel.*;
	
	public class Large extends Snowflake
	{
		public function Large()
		{
			super();
					
			makeGraphic(2, 2);
			
			_windY = 15;
			_pointValue = 1;
			_volume = Helpers.rand(0.25, 0.4);
		}

		public override function onLick():void
		{
			if (FlxG.score == 0)
				_volume = 0.4;
			
			super.onLick();
			
			playNote();
		}
	}
}