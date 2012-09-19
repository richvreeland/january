package january
{
	import org.flixel.*;
	
	[SWF(width="960", height="360", backgroundColor="#000000")]
	
	public class January extends FlxGame
	{
		public function January()
		{
			super(320, 120, PlayState, 3);
			
			// Force the debugger
			forceDebugger = true;
		}
	}
}