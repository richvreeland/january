package january
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{	
		[Embed(source="../assets/art/player1.png")] private var sprite: Class;
		
		/** Initial Player X Position. */
		public static const X_INIT: int = Camera.X_INIT + 25;
		/** Size of the player's boundary on the left side of the screen, in pixels. */
		private var boundsLeft: int = 0;
		/** Scrolling X position of the left side of the screen, in pixels. */
		private var scrollLeft: int = 0;
		/** Scrolling X position of the right side of the screen, in pixels. */
		private var scrollRight: int = 0;
		/** Whether the player has stopped moving. */
		private var stopped: Boolean = true;
		/** Whether the player's tongue is up. */
		public var tongueUp: Boolean = false;
		
		public function Player()
		{
			x = X_INIT; y = 79;
			
			super(x, y);
			loadGraphic(sprite, false, true, 16, 33);
			
			width    = 8;
			height   = 2;
			offset.x = 5;
			offset.y = 9;
			
			// Set player's x position bounds
			boundsLeft = 2;
			
			// Add animations.
			addAnimation("idle", [78,79,80,81,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0], 6, false);			
			addAnimation("tongueUpStopped", [73,74,75,76,5,5,5,5,5,6,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,5], 6, false);
			addAnimation("tongueUp", [2,3,4,5], 18, false);
			addAnimation("tongueDown", [4,3,2,0], 18, false);
			addAnimation("walk", [33,35,37,7,9,11,13,15,17,19,21,23,25,27,29,31], 12);
			addAnimation("walkTongue", [66,68,70,40,42,44,46,48,50,52,54,56,58,60,62,64], 12);
			
//			addAnimation("idle", [19,16,18,17,15,14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], 6);			
//			addAnimation("tongueUpStopped", [2,27,26,25,28], 6, false);
//			addAnimation("tongueUp", [1,28], 12, false);
//			addAnimation("tongueDown", [1,0], 12, false);
//			addAnimation("walk", [6, 7, 8, 9, 10, 3, 4, 5], 6);
//			addAnimation("walkTongue", [12, 13, 20, 21, 22, 23, 24, 11], 6);
		}
		
		override public function update():void
		{						
			//////////////
			// MOVEMENT //
			//////////////
			
			acceleration.x = 0;
			
			if ( (frame >= 11 && frame <= 14) || (frame >= 27 && frame <= 31) || (frame >= 44 && frame <= 47) || (frame >= 60 && frame <= 64) )
				maxVelocity.x = 15;
			else
				maxVelocity.x = 35;
			
			if (FlxG.keys.CONTROL)
				maxVelocity.x = 68;
			
			if (FlxG.keys.LEFT || FlxG.keys.A)
			{	
				facing = LEFT;
				Snowflake.timbre = "Secondary";
				velocity.x = -maxVelocity.x;
//				drag.x = 50000;
//				acceleration.x -= drag.x;
			}
			else if (FlxG.keys.RIGHT || FlxG.keys.D)
			{
				facing = RIGHT;
				Snowflake.timbre = "Primary";
				velocity.x = maxVelocity.x;
//				drag.x = 50000;
//				acceleration.x += drag.x;
			}
			else if (FlxG.keys.justReleased("LEFT") || FlxG.keys.justReleased("RIGHT") || FlxG.keys.justReleased("A") || FlxG.keys.justReleased("D"))
			{
				drag.x = 100;
				stopped = true;
			}
			
			///////////////
			// ANIMATION //
			///////////////
			
			if (velocity.x != 0)	
			{								
				if (tongueUp == false)
					play("walk");
				else
					play("walkTongue");
				
				if (FlxG.keys.UP || FlxG.keys.W)
					tongueUp = true;
				else if (FlxG.keys.DOWN || FlxG.keys.S)	
					tongueUp = false;				
			}				
			else	// if player velocity is 0			
			{       				
				if (tongueUp == false && (FlxG.keys.UP || FlxG.keys.W))	// and still looking up					
				{					
					play("tongueUp");
					tongueUp = true;
				}	
				else if (tongueUp == true && (FlxG.keys.DOWN || FlxG.keys.S))
				{
					play("tongueDown");
					tongueUp = false;
				}
				
				if (stopped == true)
				{					
					if (tongueUp == false)
						play("idle");
					else
						play("tongueUpStopped");
				}
				
				stopped = false;
			}			
			
			super.update();
			
			////////////////
			// COLLISIONS //
			////////////////
			
			// Update scrolling boundaries.
			scrollLeft	= Camera.lens.scroll.x + boundsLeft;
			scrollRight = Camera.anchor.x - width;
		
			if (x < scrollLeft)
				x = scrollLeft;
			else if (x > scrollRight && Game.end == false)
				x = scrollRight;
			else if (x <= FlxG.worldBounds.x + 50)
				x = FlxG.worldBounds.x + 50;		
		}
		
	}
	
}