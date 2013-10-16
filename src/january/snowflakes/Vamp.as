package january.snowflakes
{
	import january.*;
	import january.music.*;
	import org.flixel.*;
	
	public class Vamp extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/vamp.png")] private var sprite: Class;
		
		public function Vamp()
		{
			super();
			
			loadGraphic(sprite, true, false, 5, 5);
			
			windY = 16;
			
			addAnimation("default", [0,0,0,0,0,0,0,0,0,0,1,2,1], 12, true);
			
			volume = Helper.rand(Note.MAX_VOLUME * 0.33, Note.MAX_VOLUME * 0.83);
		}
		
		public override function onLick():void
		{
			super.onLick();
			
			playChord();
		}
		
		public override function update():void
		{
			super.update();
			
			play("default");
		}
	}
}