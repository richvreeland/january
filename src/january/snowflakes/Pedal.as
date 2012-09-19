package january.snowflakes
{
	import january.*;
	
	public class Pedal extends Snowflake
	{
		
		[Embed(source="../assets/art/flakes/pedal.png")] private var sprite: Class;
		
		public function Pedal()
		{
			super();
			
			loadGraphic(sprite);
			noteVolume = Helpers.rand(0.1, 0.25);
		}
		
		public override function onLick():void
		{
			pedalPointMode = !pedalPointMode;
			super.onLick();
		}
		
	}
	
}