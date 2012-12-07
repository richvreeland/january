package january
{
	import org.flixel.*;
	import flash.events.*;
	
	[SWF(width="960", height="360", backgroundColor="#000000")]
	[Frame(factoryClass = "january.Preloader")]
	
	public class January extends FlxGame
	{
		public static const INIT_WIDTH:		uint = 320;
		public static const INIT_HEIGHT:	uint = 120;
		public static const INIT_STATE:		Class = Menu;
		public static const INIT_ZOOM:		Number = 3;	
		
		public function January()
		{			
			// 2.66 : 1
			super(INIT_WIDTH, INIT_HEIGHT, INIT_STATE, INIT_ZOOM, 30, 30);
			
			// Force the debugger
			//forceDebugger = true;
		}
		
		/**
		 * Remove some listeners, add others. 
		 */		
		 override protected function create(FlashEvent:Event):void
        {
            super.create(FlashEvent);
 
			// Full Screen Listeners
			//FlxG.stage.addEventListener(Event.RESIZE, Game.resize);
        }
	}
}