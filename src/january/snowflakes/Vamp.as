package january.snowflakes
{
	import january.*;
	
	public class Vamp extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/vamp.png")] private var sprite: Class;
		
		public function Vamp()
		{
			super();
			
			loadGraphic(sprite, true, false, 5, 5);
			
			_windY = 16;
			_pointValue = 1;
			
			addAnimation("default", [0,0,0,0,0,0,0,0,0,0,1,2,1], 12, true);
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