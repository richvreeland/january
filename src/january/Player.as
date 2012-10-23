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
		
		public var scrollLeft: int;
		public var scrollRight: int;
		
		protected var stopped: Boolean;
		
		public function Player()
		{
			x = Global.PLAYER_X_INIT; y = 79;
			
			super(x, y);
			loadGraphic(sprite, false, true, 16, 33);
			
			width    = 8;
			height   = 2;
			offset.x = 5;
			offset.y = 8;
			
			// Set player's x position bounds
			boundsLeft = 2;
			
			// Add animations.
			addAnimation("idle", [19,16,18,17,15,14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], 6);
			addAnimation("tongueUp", [1, 2], 12, false);
			addAnimation("tongueDown", [1, 0], 12, false);
			addAnimation("walk", [6, 7, 8, 9, 10, 3, 4, 5], 7);
			addAnimation("walkTongue", [11, 12, 13, 20, 21, 22, 23, 24], 7);
			//addAnimationCallback(footsteps);
		}
		
		protected function footsteps(Animation:String, FrameNumber:uint, FrameIndex:uint):void
		{		
			var randomStep: Class = Helpers.pickFrom(step01, step02, step03, step04);
			var pan: Number = 2 * ((this.x - PlayState.camera.scroll.x) / FlxG.width) - 1;
			
			if (FrameIndex == 4 || FrameIndex == 8 || FrameIndex == 11 || FrameIndex == 21)
				FlxG.play(randomStep, 0.05, pan, false, true);
			
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
			scrollRight = PlayState.cameraRails.x - width;
		
			if (x < scrollLeft)
				x = scrollLeft;
			else if (x > scrollRight && Global.newGame == false)
				x = scrollRight;
			else if (x <= FlxG.worldBounds.x + 50)
				x = FlxG.worldBounds.x + 50;
			
		}
		
	}
	
}