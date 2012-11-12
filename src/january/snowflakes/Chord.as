package january.snowflakes
{
	import january.*;
	import january.music.*;
	
	public class Chord extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/chord.png")] private var sprite: Class;
		
		/* Score to introduce this flake at. */
		public static const INTRODUCE_AT: int = 50;
		/** Default volume level for Chord Tones. */
		public static const VOLUME: Number = Global.NOTE_MAX_VOLUME * 0.5;
		
		public function Chord()
		{
			super();
			
			loadGraphic(sprite, true, false, 7, 7);
			offset.x = 1;
			offset.y = 1;
			
			windY = 16;
			
			addAnimation("default", [0,1,2,3], 3, true);
			addAnimation("licked" , [7,6,5,4], 3, true);
			
			volume = Helpers.rand(Global.NOTE_MAX_VOLUME * 0.33, Global.NOTE_MAX_VOLUME * 0.83);
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
			
			if (licked == false)
				play("default");
			else
				play("licked");
		}
	}
}