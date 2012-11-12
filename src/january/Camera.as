package january
{
	import org.flixel.*;
	
	public class Camera
	{
		public static var lens	: FlxCamera;
		public static var rails : FlxSprite;
		
		public static function init():void
		{
			rails = new FlxSprite(Global.CAMERA_X_INIT + FlxG.width + 1, FlxG.height - 1);		
			rails.makeGraphic(1,1,0xFFFF0000);		
			rails.maxVelocity.x = 9;
			rails.visible = false;	
		
			lens = new FlxCamera(0, 0, FlxG.width + 1, FlxG.height);
			lens.setBounds(FlxG.worldBounds.x, 0, FlxG.worldBounds.width, FlxG.height);
			lens.deadzone = new FlxRect(0, 0, FlxG.width + 1, FlxG.height);
			lens.target = rails;
		}
		
		public static function logic():void
		{	
			if (FlxG.score > 0)
			{
				if (Game.player.x <= lens.scroll.x + 25)
				{					
					rails.acceleration.x = 0;								
					rails.drag.x = 10;	
					
					if (rails.velocity.x <= 0)											
					{														
						rails.velocity.x = 0;														
						rails.drag.x = 0;														
					}										
				}								
				else if (lens.scroll.x > Game.ground.width - FlxG.width - 25)										
				{																				
					rails.x -= (rails.x - Game.ground.width)/100;										
					rails.velocity.x *= -2;	
					
					// Prevent the very last (super delayed) pixel movement of the camera lerp from happening.
					if (rails.x > Game.ground.width - 1)
						rails.x = Game.ground.width - 1;
					
					if (rails.velocity.x <= 0)
						rails.velocity.x = 0;										
				}	
				else	
				{
					rails.acceleration.x = 10;
					
					if (rails.velocity.x >= 10)
						rails.acceleration.x = 0;
				}				
			}
		}
	}
}