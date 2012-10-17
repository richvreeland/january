package january
{	
	import org.flixel.*;
	
	/** Class for the tongue collision box. Used to determine if player has licked snowflakes. */
	public class Tongue extends FlxSprite
	{			
		public function Tongue()
		{			
			super(x, y);
			makeGraphic(8,5);
			y = PlayState.player.y + 3;
			visible = false;
		}
		
		override public function update():void
		{									
			super.update();
			
			////////////////
			// MOVEMENT //
			////////////////	
			
			if (PlayState.player.facing == RIGHT)
				x = PlayState.player.x + 1;	
			else // facing == LEFT
				x = PlayState.player.x - 3;
			
		}
		
	}
	
}