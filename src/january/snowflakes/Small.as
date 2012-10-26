package january.snowflakes
{
	import january.*;
	
	import org.flixel.*;

	public class Small extends Snowflake
	{
		[Embed(source="../assets/art/flakes/small.png")] private var sprite : Class;
		
		public function Small()
		{			
			super();
			
			loadGraphic(sprite, true, false, 3, 3);
			offset.y = 1;
			offset.x = 1;
			
			_windY = 10;
			_pointValue = 1;
			_volume = Helpers.rand(0.1, 0.25);
			
			addAnimation("default",[0],0,false);
			addAnimation("firefly",[1],0,false);
		}
		
		public override function onLick():void
		{							
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