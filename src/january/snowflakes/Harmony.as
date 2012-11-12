package january.snowflakes
{
	import january.*;
	
	public class Harmony extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/harmony.png")] private var sprite: Class;
		
		/* Score to introduce this flake at. */
		public static const INTRODUCE_AT: int = 25;
		
		public function Harmony()
		{
			super();
			
			loadGraphic(sprite, true, false, 5, 5);
			offset.x = 1;
			offset.y = 1;
			
			windY = 13;
			volume = Helpers.rand(Global.NOTE_MAX_VOLUME * 0.33, Global.NOTE_MAX_VOLUME * 0.83);
			
			addAnimation("default", [0,0,0,0,0,0,0,0,1,0,1], 6, true);
			addAnimation("firefly", [3,2,3,2,2,2,2,2,2,2,2], 6, true);
		}
		
		public override function onLick():void
		{			
			super.onLick();
			
			playNote();
			playHarmonyTone();
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