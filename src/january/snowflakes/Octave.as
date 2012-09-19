package january.snowflakes
{
	import january.*;
	import org.flixel.*;
	
	public class Octave extends Snowflake
	{
		
		[Embed(source="../assets/art/flakes/octave.png")] private var sprite : Class;
		
		public function Octave()
		{
			super();
			
			loadGraphic(sprite);
			noteVolume = Helpers.rand(0.1, 0.25);
		}
		
		public override function onLick():void
		{
			Music.generate(noteVolume, 3*(FlxG.width/4));
			super.kill();
			Music.octave();	
		}
	}
}