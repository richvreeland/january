package january
{
	import january.music.*;
	import january.snowflakes.*;
	
	import org.flixel.*;
	
		public class Text extends FlxText
		{
	        [Embed(source="../assets/frucade.ttf", fontFamily="frucade", embedAsCFF="false")] public static var font:String;
	
	        /** The number of seconds to hold the text before it starts to fade. */
	        private static var lifespan: Number;
			/** The gutter size, used to keep text off screen edges. */
			public static const GUTTER: int = 5;
			    
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
				
				// Store the number of the current place in the playback sequence when appropriate.
				if (Playback.mode == "Repeat" && SnowRef.type != "Vamp")
				{
					if (Playback.reverse == false)
					{
						if (Playback.index != 0)
							_text = Playback.index.toString();
						else
							_text = Playback.sequence.length.toString();
					}
					else
					{											
						var indexString: int = Playback.index + 2;
						
						if (indexString == Playback.sequence.length + 1)
							_text = "1";
						else
							_text = indexString.toString();					
					}
				}
				
				// Show the new text feedback.
				if (_text != "")
					show(_text, 5);			
			}
			
			public function show(newText: String, offset: int = 10):void
			{
				lifespan = 1;        
				text = newText;
				alpha = 1;	
				maxVelocity.y = 0;
				drag.y = 0;					
				x = Game.player.x
				y = Game.player.y - 10;
				
				if (Game.player.facing == LEFT)
				{
					x -= realWidth + offset;
					
					// Check Bounds on Left Side
					if (Game.player.x - realWidth < GUTTER)
						x = GUTTER;	
				}
				else // facing == RIGHT
				{
					x += offset;
					
					// Check Bounds on Right Side
					if (Game.player.x + realWidth > FlxG.width - GUTTER)
						x = FlxG.width - GUTTER - realWidth;
				}
			}
		
			override public function update():void
			{
				velocity.x = -1*(Math.cos(y / 4) * 8);
				maxVelocity.y = 20;
				drag.y = 5;
				acceleration.y -= drag.y;
				
				super.update();
				
				if (lifespan > 0)
					lifespan -= FlxG.elapsed;
				else
					alpha -= FlxG.elapsed;
					
				if (alpha < 0)
					alpha = 0;			
			}
	    }
}