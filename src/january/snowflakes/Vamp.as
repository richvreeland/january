package january.snowflakes
{
	import january.*;
	import january.music.*;
	import org.flixel.*;
	
	public class Vamp extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/vamp.png")] private var sprite: Class;
		
		public static const INTRODUCE_AT: int = 20;
		
		public function Vamp()
		{
			super();
			
			loadGraphic(sprite, true, false, 7, 7);
			offset.x = 1;
			offset.y = 1;
			
			windY = 16;
			
			addAnimation("default", [0,0,0,0,0,0,0,0,0,0,1,2,1], 12, true);
			addAnimation("firefly", [3,3,3,3,3,3,3,3,3,3,4,5,4], 12, true);
			
			volume = Helper.rand(Note.MAX_VOLUME * 0.33, Note.MAX_VOLUME * 0.83);
		}
		
		public override function onLick():void
		{
			super.onLick();
			
			playChord();
		}
		
		protected override function spawn(flakeType: String, spawnX: Number = 0):void
		{
			// Spawn only on left half of screen.
			spawnX = Helper.randInt(Camera.lens.scroll.x + headwayX, Camera.anchor.x - (FlxG.width / 2));
			
			super.spawn(flakeType, spawnX);
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