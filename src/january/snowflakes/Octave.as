package january.snowflakes
{
	import january.*;
	import org.flixel.*;
	
	public class Octave extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/octave.png")] private var sprite: Class;
		
		public function Octave():void
		{
			super();
			
			loadGraphic(sprite, false, false, 3, 3);
			
			_windY = 14;
			_pointValue = 1;
			_volume = Helpers.rand(0.1, 0.25);
		}
		
		public override function onLick():void
		{
			super.onLick();
			
			playNote();	
			playOctave();				
		}
	}
}