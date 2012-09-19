package january.snowflakes
{
	import january.*;
	
	public class Chord extends Snowflake
	{
		
		[Embed(source="../assets/art/flakes/chord.png")] private var sprite : Class;
		
		public function Chord()
		{
			super();
			
			loadGraphic(sprite);
		}
		
		public override function onLick():void
		{
			Music.chord();
			super.kill();
		}
	}
}