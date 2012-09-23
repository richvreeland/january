package january.snowflakes
{
	import january.*;
	
	public class Incidental extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/incidental.png")] private var sprite: Class;
		
		public function Incidental()
		{
			super();
			
			loadGraphic(sprite);
			
			_pointValue = 1;
			_volume = Helpers.rand(0.1, 0.25);
		}
		
		public override function onLick():void
		{			
			super.onLick();
			
			incidentalMode = !incidentalMode;
			playNote();
		}
		
	}
	
}