package january.snowflakes
{
	import january.*;
	
	public class Harmony extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/pedal.png")] private var sprite: Class;
		
		public function Harmony()
		{
			super();
			
			loadGraphic(sprite);
			
			_pointValue = 1;
			_volume = Helpers.rand(0.1, 0.25);
		}
		
		public override function onLick():void
		{			
			super.onLick();
			
			playNote();
			playHarmonyTone();
		}
		
	}
	
}