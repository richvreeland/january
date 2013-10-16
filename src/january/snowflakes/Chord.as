package january.snowflakes
{
	import january.*;
	import january.music.*;
	
	import org.flixel.*;
	
	public class Chord extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/chord.png")] private var sprite: Class;
		
		/** Default volume level for Chord Tones. */
		public static const VOLUME: Number = Note.MAX_VOLUME * 0.4;
		
		public function Chord()
		{
			super();
			
			loadGraphic(sprite, true);
			
			windY = 16;
			
			addAnimation("default", [0,1,2,3], 3, true);
			
			volume = Helper.rand(Note.MAX_VOLUME * 0.33, Note.MAX_VOLUME * 0.83);
		}
		
		public override function onLick():void
		{
			super.onLick();
			
			Mode.change();
			playNote();
			playChord();
		}
		
		public override function update():void
		{
			super.update();
			
			play("default");
		}
	}
}