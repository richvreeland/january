package january
{
	import january.snowflakes.*;
	import org.flixel.*;
	
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
				
				// When to show Play and Replay modes, and when to count the Replay notes.
				if (SnowRef.type == "Large")
				{
					if (Snowflake.replayMode == true)
						_text = "Replay"
					else
						_text = "Play"
				}
				else if (SnowRef.type == "Key" || SnowRef.type == "Chord" || FlxG.score == 2)
					_text = "Play";
				else if (Snowflake.replayMode == true)
				{
					if (Snowflake.replaySequenceIndex != 0)
						_text = Snowflake.replaySequenceIndex.toString();						
					else
						_text = Snowflake.replaySequence.length.toString();
				}
				
				if (Global.newGame == true)
					_text = "";
				else if (FlxG.score == 1)
					_text = "January";
				
				// Show the new text feedback.
				if (_text != "")
				{
					_lifespan = Global.textLifespan;        
					text = _text;
					alpha = 1;
					x = PlayState.player.x;
					y = PlayState.player.y - 25;
					
					if (PlayState.player.facing == LEFT)
					{
						x -= realWidth - 6;
						
						// Check Bounds on Left Side
						if (PlayState.player.x - realWidth < Global.textGutter + PlayState.camera.scroll.x)
							x = PlayState.camera.scroll.x + Global.textGutter;	
					}
					else // facing == RIGHT
					{
						x -= 4;
						
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