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
			super(320, 120, MenuState, 3, 60, 60);
			
			// Force the debugger
			forceDebugger = true;
		}
		
		/**
		 * Remove some listeners, add others. 
		 */		
//		 override protected function create(FlashEvent:Event):void
//        {
//            super.create(FlashEvent);
// 
//			// Full Screen Listeners
//			FlxG.stage.addEventListener(MouseEvent.CLICK, PlayState.fullscreen);
//			FlxG.stage.addEventListener(Event.RESIZE, PlayState.resize);
//        }
	}
}