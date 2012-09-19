package january.snowflakes
{
	import january.*;
	
	public class Octave extends Snowflake
	{
		
		[Embed(source="../assets/art/flakes/octave.png")] private var sprite : Class;
		
		public function Octave()
		{
			super();
			
			loadGraphic(sprite);
		}
		
		public override function onLick():void
		{
			super.onLick();
			Audio.octave();	
		}
	}
}