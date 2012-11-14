package january.snowflakes
{
	import january.*;
	import january.music.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Transpose extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/transpose.png")] private var sprite : Class;
		
		/* Score to introduce this flake at. */
		public static const INTRODUCE_AT: int = 100;
		
		public function Transpose()
		{
			super();
			
			loadGraphic(sprite, true, false, 5, 8);
			offset.y = 1;
			
			windY = 15;
			
			addAnimation("default", [0,1,2,3,4,3,2,1], 3, true);
			
			volume = Helper.rand(Note.MAX_VOLUME * 0.33, Note.MAX_VOLUME * 0.83);
		}
		
		public override function onLick():void
		{			
			super.onLick();
			
			Mode.change();
			Key.change();
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