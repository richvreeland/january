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
			
			_pointValue = 1;
			noteVolume = Helpers.rand(0.1, 0.25);
		}
		
		public override function onLick():void
		{
			pedalPointMode = !pedalPointMode;
			Music.generate(noteVolume, x);
			
			super.onLick();
		}
		
	}
	
}