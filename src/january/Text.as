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
			/** The gutter size, used to keep text off screen edges. */
			public static const GUTTER: int = 1;
			    
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
				// Prevent numbers from showing up after entering the house.
				if (Global.newGame == true)
					kill();
				
				var _text: String = "";
				
				// Store the number of the current place in the playback sequence when appropriate.
				if (Playback.mode == true && SnowRef.type != "Vamp")
				{
					if (Playback.index != 0)
						_text = Playback.index.toString();						
					else
						_text = Playback.sequence.length.toString();
				}
				
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
					
					if (Game.player.facing == LEFT)
					{
						x -= realWidth + 5;
						
						// Check Bounds on Left Side
						if (Game.player.x - realWidth < GUTTER + Camera.lens.scroll.x)
							x = Camera.lens.scroll.x + GUTTER;	
					}
					else // facing == RIGHT
					{
						x += 5;
						
						// Check Bounds on Right Side
						if (Game.player.x + realWidth > Camera.rails.x - GUTTER)
							x = Camera.rails.x - GUTTER - realWidth;
						
						if (Game.player.x + realWidth > Game.houseRight.x)
							x = Game.houseRight.x - GUTTER - realWidth;
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