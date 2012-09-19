package january
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		
		[Embed(source="../assets/art/player.png")] private var sprite:Class;
		
		private var boundsLeft : int;
		private var boundsRight : int;
		
		public function Player()
		{
			x = 25; y = 79;
			
			super(x, y);
			loadGraphic(sprite, false, true, 16, 33);
			maxVelocity.x = 25;
			
			// Focus bounding box on head for collision purposes.
			width = 6;
			height = 1;
			offset.x = 6;
			offset.y = 6;
			
			// Set player's x position bounds
			boundsLeft = 0;
			boundsRight = FlxG.width - frameWidth;
			
			// Add animations.
			addAnimation("idle", [19,16,18,17,15,14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], 6);
			addAnimation("tongueUp", [1, 2], 12, false);
			addAnimation("tongueDown", [1, 0], 12, false);
			addAnimation("walk", [6, 7, 8, 9, 10, 3, 4, 5], 6);
			addAnimation("walkTongue", [11, 12, 13, 20, 21, 22, 23, 24], 6);
		}
		
		override public function update():void
		{			
			//////////////
			// MOVEMENT //
			//////////////
			
			if (FlxG.keys.LEFT || FlxG.keys.A)
			{	
				facing = LEFT;
				velocity.x = -maxVelocity.x;
			}
			else if (FlxG.keys.RIGHT || FlxG.keys.D)
			{
				facing = RIGHT;
				velocity.x = maxVelocity.x;
			}
			else if ((FlxG.keys.justReleased("D") || FlxG.keys.justReleased("A")) || (FlxG.keys.justReleased("RIGHT") || FlxG.keys.justReleased("LEFT")))
				velocity.x = 0;
			else
				velocity.x = 0;
			
			///////////////
			// ANIMATION //
			///////////////
			
			if (velocity.x != 0)
			{
				if (FlxG.keys.UP || FlxG.keys.W)
					play("walkTongue");
				else
					play("walk");
			}
			else
			{	
				if (FlxG.keys.UP || FlxG.keys.W)
				{
					// Skip to frame to smooth out the transition.
					if (FlxG.keys.justReleased("LEFT") || FlxG.keys.justReleased("RIGHT") || FlxG.keys.justReleased("A") || FlxG.keys.justReleased("D"))
						frame = 2;
					else if (frame != 2)
						play("tongueUp");
				}
				else if (FlxG.keys.justReleased("UP") || FlxG.keys.justReleased("W"))
				{
					// Chain together two animations.
					play("tongueDown");
					if (finished) play("idle");
				}
				else if (FlxG.keys.justReleased("LEFT") || FlxG.keys.justReleased("RIGHT") || FlxG.keys.justReleased("A") || FlxG.keys.justReleased("D"))
					play("idle");
			}
			
			super.update();
			
			/////////////////////////
			// BOUNDARY COLLISIONS //
			/////////////////////////
			
			if (x <= boundsLeft)  x = boundsLeft;
			if (x >= boundsRight) x = boundsRight;
		}
		
		public function onCollision(SnowRef: Snowflake, PlayerRef: Player):void
		{			
			if (FlxG.keys.UP || FlxG.keys.W)
			{
				FlxG.score += 1;
				SnowRef.onLick();
			}		
			
		}
		
	}
	
}