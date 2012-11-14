package january.snowflakes
{
	import january.*;
	import january.music.*;
	import org.flixel.*;
	
	public class Large extends Snowflake
	{
		[Embed(source="../assets/art/flakes/large.png")] private var sprite: Class;
		
		/** The probability weight for spawning this flake type. */
		public static const WEIGHT: Number = 10;
		
		public function Large()
		{
			super();
					
			loadGraphic(sprite, true, false, 4, 4);
			offset.x = 1;
			offset.y = 1;
			
			windY = 15;
			volume = Helper.rand(Note.MAX_VOLUME * 0.5, Note.MAX_VOLUME * 0.75);
			
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
			
			if (licked == false)
				play("default");
			else
				play("firefly");
		}
	}
}