package january
{
	import org.flixel.*;
	import january.music.Playback;
	
	public class Controls extends FlxSprite
	{	
		[Embed(source="../assets/art/controls.png")] private static var sprite:Class;
		
		public function Controls()
		{
			x = 7; y = FlxG.height - 14;			
			
			super(x, y);
			loadGraphic(sprite, true);
			
			scrollFactor.x = 0;
			
			addAnimation("record", [0,0,0,0,0,2], 1, false);
			addAnimation("play", [1,1,1,1,1,2], 1, false);
			
			exists = false;
		}
		
		public function onLick():void
		{
			exists = true;
			
			if (Playback.mode == true)
				play("play");
			else
				play("record");
		}
	}
	
}