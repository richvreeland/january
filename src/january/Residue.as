package january
{
	import org.flixel.*;
	
	public class Residue extends FlxSprite
	{	
		[Embed(source="../assets/art/flakes/licked.png")] private static var sprite:Class;
		
		public function Residue()
		{
			x = -15; y = -15;
			
			super(x, y);
			loadGraphic(sprite, true, false, 5, 5);
			
			addAnimation("default", [0,1,2], 15, false);
		}
		
		public function onLick(SnowRef: Snowflake):void
		{
			if (SnowRef.type != "Small")
			{				
				x = SnowRef.x; y = SnowRef.y - + SnowRef.height;
				play("default");
				flicker(1);
			}
		}
	}
	
}