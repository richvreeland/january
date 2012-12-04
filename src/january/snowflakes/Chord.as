package january.snowflakes
{
	import january.*;
	import january.music.*;
	import org.flixel.*;
	
	public class Chord extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/chord.png")] private var sprite: Class;
		
		/* Score to introduce this flake at. */
		public static const INTRODUCE_AT: int = 50;
		/** Default volume level for Chord Tones. */
		public static const VOLUME: Number = Note.MAX_VOLUME * 0.5;
		
		public function Chord()
		{
			super();
			
			loadGraphic(sprite, true, false, 7, 7);
			offset.x = 1;
			offset.y = 1;
			
			windY = 16;
			
			addAnimation("default", [0,1,2,3], 3, true);
			addAnimation("licked" , [7,6,5,4], 3, true);
			
			volume = Helper.rand(Note.MAX_VOLUME * 0.33, Note.MAX_VOLUME * 0.83);
		}
		
		public override function onLick():void
		{
			super.onLick();
			
			Mode.change();
			playNote();
			playChord();
		}
		
		protected override function spawn(flakeType: String, spawnX: Number = 0):void
		{
			// Spawn only in right two thirds of screen.
			spawnX = Helper.randInt(Camera.lens.scroll.x + headwayX + (FlxG.width/3), Camera.anchor.x);
			
			super.spawn(flakeType, spawnX);
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