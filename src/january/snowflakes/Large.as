package january.snowflakes
{
	import january.*;
	import org.flixel.*;
	
	public class Large extends Snowflake
	{
		[Embed(source="../assets/art/flakes/large.png")] private var sprite : Class;
		
		public function Large()
		{
			super();
					
			loadGraphic(sprite, true, false, 4, 4);
			offset.x = 1;
			offset.y = 1;
			
			_windY = 15;
			_pointValue = 1;
			_volume = Helpers.rand(0.15, 0.3);
			
			addAnimation("default",[0],0,false);
			addAnimation("firefly",[1],0,false);
		}

		public override function onLick():void
		{
			if (FlxG.score == 0)
				_volume = 0.25;
			
			super.onLick();
			
			playNote();
		}
		
		public override function update():void
		{
			super.update();
			
			if (_licked == false)
				play("default");
			else
				play("firefly");
		}
	}
}