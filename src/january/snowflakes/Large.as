package january.snowflakes
{
	import january.*;
	
	public class Large extends Snowflake
	{
		public function Large()
		{
			super();
					
			makeGraphic(2, 2);
			
			_pointValue = 1;
			noteVolume = Helpers.rand(0.25, 0.5);
		}

		public override function onLick():void
		{
			super.onLick();
			
			Music.generate(noteVolume, x);
		}
	}
}