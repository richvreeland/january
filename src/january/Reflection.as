package january
{
	import org.flixel.*;
	
	public class Reflection extends Player
	{		
		public function Reflection()
		{			
			super();
			
			y = PlayState.player.y + 33;
			angle = 180;
			alpha = 0.1;

		}
		
		override public function onOverlap(SnowRef: Snowflake, PlayerRef: Player):void
		{
		}
		
		override protected function footsteps(Animation:String, FrameNumber:uint, FrameIndex:uint):void
		{
			
		}
		
		override public function update():void
		{							
			super.update();
			
			var pressedLeftKey:Boolean = FlxG.keys.LEFT || FlxG.keys.A;
			var pressedRightKey:Boolean = FlxG.keys.RIGHT || FlxG.keys.D;
			
			if (pressedLeftKey)
				facing = RIGHT;
			else if (pressedRightKey)
				facing = LEFT;
			
		}
		
	}
	
}