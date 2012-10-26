package january
{
	import january.snowflakes.*;
	import org.flixel.*;
	import january.music.*;
	
		public class Text extends FlxText
		{
	        [Embed(source="../assets/frucade.ttf", fontFamily="frucade", embedAsCFF="false")] public static var font:String;
	
	        /** The number of seconds to hold the text before it starts to fade. */
	        private static var _lifespan: Number;
			    
	        public function Text():void
			{
				x = -15;
				y = -15;
				width = 200;
				
	            super(x,y,width);
	
				velocity.y = -8;	
	            font = "frucade";
	            alpha = 0;
	        }
	
			/**
			 * onLick() - Figures out what text to display next, and where to display it so it looks nice.
			 *  
			 * @param flakeType
			 * 
			 */			
			public function onLick(SnowRef: Snowflake):void
			{											
				var _text: String = "";
				
				if (Playback.mode == true && SnowRef.type != "Vamp")
				{
					if (Playback.index != 0)
						_text = Playback.index.toString();						
					else
						_text = Playback.sequence.length.toString();
				}
				
				if (Global.newGame == true)
					_text = "";
				else if (FlxG.score == 1)
					_text = "January";
				
				// Show the new text feedback.
				if (_text != "")
				{
					_lifespan = Global.ALPHA_LIFESPAN;        
					text = _text;
					alpha = 1;
					
					maxVelocity.y = 0;
					drag.y = 0;	
					
					x = SnowRef.x
					y = SnowRef.y - 10;
					
					if (PlayState.player.facing == LEFT)
					{
						x -= realWidth + 5;
						
						// Check Bounds on Left Side
						if (PlayState.player.x - realWidth < Global.textGutter + PlayState.camera.scroll.x)
							x = PlayState.camera.scroll.x + Global.textGutter;	
					}
					else // facing == RIGHT
					{
						x += 5;
						
						// Check Bounds on Right Side
						if (PlayState.player.x + realWidth > PlayState.cameraRails.x - Global.textGutter)
							x = PlayState.cameraRails.x - Global.textGutter - realWidth;
						
						if (PlayState.player.x + realWidth > PlayState.houseRight.x)
							x = PlayState.houseRight.x - Global.textGutter - realWidth;
					}
				}				
			}
		
			override public function update():void
			{
				velocity.x = -1*(Math.cos(y / 4) * 8);
				maxVelocity.y = 20;
				drag.y = 5;
				acceleration.y -= drag.y;
				
				super.update();
				
				if (_lifespan > 0)
					_lifespan -= FlxG.elapsed;
				else
					alpha -= FlxG.elapsed;
					
				if (alpha < 0)
					alpha = 0;			
			}
	    }
}