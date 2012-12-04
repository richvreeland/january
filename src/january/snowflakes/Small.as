package january.snowflakes
{
	import january.*;
	import january.music.*;
	import org.flixel.*;

	public class Small extends Snowflake
	{
		[Embed(source="../assets/art/flakes/small.png")] private var sprite: Class;
		
		public function Small()
		{			
			super();
			
			loadGraphic(sprite, true, false, 3, 3);
			offset.y = 1;
			offset.x = 1;
			
			windY = 10;
			volume = Helper.rand(Note.MAX_VOLUME * 0.33, Note.MAX_VOLUME * 0.83);
			
			addAnimation("default",[0],0,false);
			addAnimation("firefly",[1],0,false);
			
			pedalAllowed = true;
		}
		
		public override function onLick():void
		{							
			super.onLick();
			
			playNote();
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