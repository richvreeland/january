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
			
			_pointValue = 1;
		}
		
		public override function onLick():void
		{
			super.onLick();
			
			playChord();
		}
	}
}