package january.snowflakes
{
	import january.*;
	import january.music.*;
	
	import org.flixel.*;
	
	public class Octave extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/octave.png")] private var sprite: Class;
		
		/* Score to introduce this flake at. */
		public static const INTRODUCE_AT: int = 10;
		/** Default volume level for the octave tone (not the default note). */
		public static const VOLUME: Number = Note.MAX_VOLUME * 0.33;
		/** The probability weight for spawning this flake type. */
		public static const WEIGHT: Number = 3.5;
		
		public function Octave():void
		{
			super();
			
			loadGraphic(sprite, false, false, 5, 5);
			offset.x = 1;
			offset.y = 1;
			
			windY = 14;
			volume = Helper.rand(Note.MAX_VOLUME * 0.33, Note.MAX_VOLUME * 0.83);
			
			addAnimation("default", [0],0,false);
			addAnimation("firefly", [1],0,false);
		}
		
		public override function onLick():void
		{
			super.onLick();
			
			playNote();	
			playOctave();				
		}
		
		public override function update():void
		{
			super.update();
			
			if (licked == false)
				play("default");
			else
				play("firefly");
		}
	}
}