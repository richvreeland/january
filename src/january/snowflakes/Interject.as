package january.snowflakes
{
	import january.*;
	import january.music.*;
	import org.flixel.*;
	
	public class Interject extends Snowflake
	{
		[Embed(source="../assets/art/flakes/interject.png")] private var sprite: Class;
		
		public static const INTRODUCE_AT: int = 25;
		
		public function Interject()
		{
			super();
					
			loadGraphic(sprite, true, false, 5, 5);
			offset.x = 1;
			offset.y = 1;
			
			windY = 15;
			volume = Helper.rand(Note.MAX_VOLUME * 0.5, Note.MAX_VOLUME * 0.75);
			
			addAnimation("default",[0],0,false);
			addAnimation("firefly",[1],0,false);
			
			pedalAllowed = true;
		}

		public override function onLick():void
		{			
			super.onLick();
		
			// DETERMINE WHETHER TO USE INTERJECT/PLAYBACK MODE
			if (FlxG.score > 1)
			{
				if (mode == "Interject")
					mode = "Playback";
				else
					mode = "Interject";
			}
			
			playNote();
		}
		
		protected override function spawn(flakeType: String, spawnX: Number = 0):void
		{
			// Spawn only on left half of screen.
			if (mode == "Playback")
				spawnX = Helper.randInt(Camera.lens.scroll.x + headwayX, Camera.anchor.x - (FlxG.width / 2));
			
			super.spawn(flakeType, spawnX);
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