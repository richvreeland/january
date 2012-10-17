package january
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{	
		[Embed(source="../assets/art/player.png")] private static var sprite:Class;
		
		[Embed(source="../assets/audio/footsteps/01.mp3")]	private static var step01:Class;
		[Embed(source="../assets/audio/footsteps/02.mp3")]	private static var step02:Class;
		[Embed(source="../assets/audio/footsteps/03.mp3")]	private static var step03:Class;
		[Embed(source="../assets/audio/footsteps/04.mp3")]	private static var step04:Class;
		
		private static var footsteps: Array = [step01, step02, step03, step04];
		private static var footstepsLength: uint = footsteps.length;
		
		public var boundsLeft : int;
		public var boundsRight : int;
		
		public var scrollLeft: int;
		public var scrollRight: int;
		
		public var defaultX: Number;
		
//		public var tongueBox: FlxSprite;
		
		protected var stopped: Boolean;
		
		/** locally stored copy of the world bounds x position. */
		protected var _worldBoundsX: Number = FlxG.worldBounds.x;
		
		public function Player()
		{
			defaultX = PlayState.startingX + 25;
			x = defaultX; y = 79;
			
			super(x, y);
			loadGraphic(sprite, false, true, 16, 33);
			maxVelocity.x = 25;
			
			width    = 6;
			height   = 30;
			offset.x = 4;
			offset.y = 3;
			
//			tongueBox = new FlxSprite().makeGraphic(8,5);
//			tongueBox.visible = false;
			
			// Set player's x position bounds
			boundsLeft = 2;
			boundsRight = FlxG.width - frameWidth;
			
			// Add animations.
			addAnimation("idle", [19,16,18,17,15,14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], 6);
			addAnimation("tongueUp", [1, 2], 12, false);
			addAnimation("tongueDown", [1, 0], 12, false);
			addAnimation("walk", [6, 7, 8, 9, 10, 3, 4, 5], 6);
			addAnimation("walkTongue", [11, 12, 13, 20, 21, 22, 23, 24], 6);
			addAnimationCallback(footsteps);
		}
		
		protected function footsteps(Animation:String, FrameNumber:uint, FrameIndex:uint):void
		{		
			var randomStep: Class = Helpers.pickFrom(step01, step02, step03, step04);
			var pan: Number = 2 * ((this.x - PlayState.camera.scroll.x) / FlxG.width) - 1;
			
			if (FrameIndex == 4 || FrameIndex == 8 || FrameIndex == 11 || FrameIndex == 21)
				FlxG.play(randomStep, 0.05, pan);
			
		}
		
		override public function update():void
		{						
			//////////////
			// MOVEMENT //
			//////////////
			
			acceleration.x = 0;
			
			if (FlxG.keys.LEFT || FlxG.keys.A)
			{	
				facing = LEFT;
				offset.x = 6;
				drag.x = 5000;
				acceleration.x -= drag.x;
			}
			else if (FlxG.keys.RIGHT || FlxG.keys.D)
			{
				facing = RIGHT;
				offset.x = 4;
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
				if (FlxG.keys.UP || FlxG.keys.W)					
					play("walkTongue");					
				else					
					play("walk");				
			}				
			else	// if player velocity is 0			
			{       				
				if (FlxG.keys.UP || FlxG.keys.W)	// and still looking up					
				{					
					// Skip to frame to smooth out the transition.			
					if (stopped == true)
					{
						frame = 2;
						stopped = false;
					}
					else if (frame != 2)
						play("tongueUp");
				}					
				else if (FlxG.keys.justReleased("UP") || FlxG.keys.justReleased("W"))					
				{					
					// Chain together two animations.					
					play("tongueDown");				
				}
				
				if (stopped == true)					
					play("idle");
				
				stopped = false;
			}			
			
			super.update();
			
			////////////////
			// COLLISIONS //
			////////////////
			
			// Update scrolling boundaries.
			scrollLeft	= PlayState.camera.scroll.x + boundsLeft;
			scrollRight = PlayState.camera.scroll.x + boundsRight;
		
			if (x < scrollLeft)
				x = scrollLeft;
			else if (x > scrollRight)
				x = scrollRight;
			else if (x <= _worldBoundsX + 50)
				x = _worldBoundsX + 50;
			
			// Update tongue collision box position
//			if (facing == RIGHT)
//			{
//				tongueBox.x = this.x + 1;
//				tongueBox.y = this.y + 3;
//			}	
//			else // facing == LEFT
//			{
//				tongueBox.x = this.x - 1;
//				tongueBox.y = this.y + 3;
//			}
			
		}
		
	}
	
}