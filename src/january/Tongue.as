package january
{	
	import org.flixel.*;
	
	public class Tongue extends FlxSprite
	{			
		public function Tongue()
		{			
			super(x, y);
			makeGraphic(8,5);
			visible = false;
		}
		
		override public function update():void
		{									
			super.update();
			
			////////////////
			// MOVEMENT //
			////////////////
			
			// Update tongue collision box position
			if (facing == RIGHT)
			{
				x = PlayState.player.x + 1;
				y = PlayState.player.y + 3;
			}	
			else // facing == LEFT
			{
				x = PlayState.player.x - 1;
				y = PlayState.player.y + 3;
			}
			
		}
		
	}
	
}