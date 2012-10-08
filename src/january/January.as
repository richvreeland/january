package january
{
	import org.flixel.*;
	import flash.events.*;
	
	[SWF(width="960", height="360", backgroundColor="#000000")]
	
	public class January extends FlxGame
	{
		public function January()
		{
			// 2.66 : 1
			super(320, 120, PlayState, 3);
			
			// Force the debugger
			forceDebugger = true;
		}
		
		/**
		 * Disable auto-pause by removing focus event listeners. 
		 */		
		 override protected function create(FlashEvent:Event):void
        {
            super.create(FlashEvent);
            stage.removeEventListener(Event.DEACTIVATE, onFocusLost);
            stage.removeEventListener(Event.ACTIVATE, onFocus);
        }
	}
}