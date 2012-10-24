package january.snowflakes
{
	import january.*;
	import january.music.*;
	
	import org.flixel.plugin.photonstorm.*;
	
	public class Transpose extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/key.png")] private var sprite : Class;
		
		public function Transpose()
		{
			super();
			
			loadGraphic(sprite, true, false, 5, 6);
			
			_windY = 15;
			_pointValue = 1;
			
			addAnimation("default", [0,1,2,3,4,3,2,1], 3, true);
		}
		
		public override function onLick():void
		{			
			super.onLick();
			
			Mode.change();
			Key.change();
			playChord();
		}
		
		public override function update():void
		{
			super.update();
			
			play("default");
		}
		
	}
	
}