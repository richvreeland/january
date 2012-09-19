package january.snowflakes
{
	import january.*;
	
	public class Wind extends Snowflake
	{
		
		[Embed(source="../assets/art/flakes/wind.png")] private var sprite : Class;
		
		public function Wind()
		{
			super();
			
			loadGraphic(sprite);
		}
		
		public override function onLick():void
		{
			// call octave before superclass to create staggered harmonies
			Audio.octave();
			super.onLick();
		}
	}
	
	
}