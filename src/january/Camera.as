package january
{
	import org.flixel.*;
	
	public class Camera
	{
		public static var lens: FlxCamera;
		public static var anchor: FlxSprite;
		
		/** Initial Camera X Position. */
		public static const X_INIT: int = 420;	//420 for Start. //2480 for End of Level.
		
		public static function init():void
		{
			anchor = new FlxSprite(X_INIT + FlxG.width + 1, FlxG.height - 1);		
			anchor.makeGraphic(1,1,0xFFFF0000);		
			anchor.maxVelocity.x = 9;
			anchor.visible = false;	
		
			lens = new FlxCamera(0, 0, FlxG.width + 1, FlxG.height);
			lens.setBounds(FlxG.worldBounds.x, 0, FlxG.worldBounds.width, FlxG.height);
			lens.deadzone = new FlxRect(0, 0, FlxG.width + 1, FlxG.height);
			lens.target = anchor;
		}
		
		public static function logic():void
		{	
			if (FlxG.score > 0)
			{
				if (Game.player.x <= lens.scroll.x + 25)
				{					
					anchor.acceleration.x = 0;								
					anchor.drag.x = 10;	
					
					if (anchor.velocity.x <= 0)											
					{														
						anchor.velocity.x = 0;														
						anchor.drag.x = 0;														
					}										
				}								
				else if (lens.scroll.x > Game.ground.width - FlxG.width - 25)										
				{																				
					anchor.x -= (anchor.x - Game.ground.width)/100;										
					anchor.velocity.x *= -2;	
					
					// Prevent the very last (super delayed) pixel movement of the camera lerp from happening.
					if (anchor.x > Game.ground.width - 1)
						anchor.x = Game.ground.width - 1;
					
					if (anchor.velocity.x <= 0)
						anchor.velocity.x = 0;										
				}	
				else	
				{
					anchor.acceleration.x = 10;
					
					if (anchor.velocity.x >= 10)
						anchor.acceleration.x = 0;
				}				
			}
		}
	}
}