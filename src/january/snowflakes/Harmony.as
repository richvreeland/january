package january.snowflakes
{
	import january.*;
	
	public class Harmony extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/harmony.png")] private var sprite: Class;
		
		public function Harmony()
		{
			super();
			
			loadGraphic(sprite, true, false, 3, 3);
			
			_windY = 13;
			_pointValue = 1;
			_volume = Helpers.rand(0.1, 0.25);
			
			addAnimation("default", [0,0,0,0,0,0,0,0,1,0,1], 6, true);
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
			play("default");
		}
		
	}
	
}