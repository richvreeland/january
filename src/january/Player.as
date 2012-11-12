package january
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{	
		[Embed(source="../assets/art/player.png")] private static var sprite:Class;
		
		public var boundsLeft : int;
		
		public var scrollLeft: int;
		public var scrollRight: int;
		
		protected var stopped: Boolean;
		public var tongueUp: Boolean;
		
		public function Player()
		{
			x = Global.PLAYER_X_INIT; y = 79;
			
			super(x, y);
			loadGraphic(sprite, false, true, 16, 33);
			
			width    = 8;
			height   = 2;
			offset.x = 5;
			offset.y = 9;
			
			// Set player's x position bounds
			boundsLeft = 2;
			
			// Add animations.
			addAnimation("idle", [19,16,18,17,15,14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], 6);
			addAnimation("tongueUp", [1,2], 12, false);//12, false);
			addAnimation("tongueDown", [1,0], 12, false);//12, false);
			addAnimation("walk", [6, 7, 8, 9, 10, 3, 4, 5], 7);
			addAnimation("walkTongue", [11, 12, 13, 20, 21, 22, 23, 24], 7);
		}
		
		override public function update():void
		{						
			//////////////
			// MOVEMENT //
			//////////////
			
			maxVelocity.x = 27;
			acceleration.x = 0;
			
			if (FlxG.keys.LEFT || FlxG.keys.A)
			{	
				facing = LEFT;
				drag.x = 5000;
				acceleration.x -= drag.x;
			}
			else if (FlxG.keys.RIGHT || FlxG.keys.D)
			{
				facing = RIGHT;
				drag.x = 5000;
				acceleration.x += drag.x;
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
						frame = 2;
				}
				
				stopped = false;
			}			
			
			super.update();
			
			////////////////
			// COLLISIONS //
			////////////////
			
			// Update scrolling boundaries.
			scrollLeft	= Camera.lens.scroll.x + boundsLeft;
			scrollRight = Camera.rails.x - width;
		
			if (x < scrollLeft)
				x = scrollLeft;
			else if (x > scrollRight && Global.newGame == false)
				x = scrollRight;
			else if (x <= FlxG.worldBounds.x + 50)
				x = FlxG.worldBounds.x + 50;		
		}
		
	}
	
}