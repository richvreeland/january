package january
{
	import flash.display.*;
	import flash.events.*;
	
	import january.*;
	
	import org.flixel.*;
	
	public class MenuState extends FlxState
	{
		private var _soundText	:FlxText;
		private var _yesText	:FlxText;
		private var _noText		:FlxText;
		private var _yes		:FlxButton;
		private var _no			:FlxButton;
		
		override public function create():void
		{
			FlxG.bgColor = 0xFF000000;
			
			// Start off in windowed mode
            //toggleFullscreen(StageDisplayState.NORMAL);
 
            // Create a listener for when the window is resized (by escape)
            //FlxG.stage.addEventListener(Event.RESIZE, windowResized);
			FlxG.stage.addEventListener(MouseEvent.CLICK, toggleFullscreen);
			
				_soundText = new FlxText(50, 30, 200, "is your sound turned on?");
				_soundText.setFormat("frucade", 8, 0xFFFFFFFF, "center", 0);
			add(_soundText);
			
				_yes = new FlxButton(0, 80, "", yes);
				_yes.width  = 120;
				_yes.height = 15;
				_yes.color  = 0xFF000000;
			add(_yes);
			
				_yesText = new FlxText(64, 78, 100, "Yes.");
				_yesText.setFormat("frucade", 8, 0xFFFFFF);
			add(_yesText);
			
			
				_no = new FlxButton(160, 80, "", no);
				_no.width  = 120;
				_no.height = 15;
				_no.color  = 0xFF000000;
			add(_no);
			
				_noText = new FlxText(228, 78, 100, "No.");
				_noText.setFormat("frucade", 8, 0xFFFFFF);
			add(_noText);
			
			FlxG.mouse.show();
			
			super.create();
		}
		
		private function yes():void
		{			
			FlxG.mouse.hide();
			FlxG.fade(0xFF000000, 5, newState);
			//toggleFullscreen();
		}
		
		private function newState():void
		{
			FlxG.switchState(new PlayState());
		}
		
		private function no():void
		{
			_soundText.text = "come back when you've got sound."
			_yesText.text = "okay, i'm ready.";
		}
		
		/**
		 * This is called when the user clicks the button.
		 * By default, it will go to fullscreen if windowed, and windowed if fullscreen. 
		 * Use the Force parameter to force it to go to a specific mode 	
		 * 
		 * @param ForceDisplayState
		 * 
		 */		
        public static function toggleFullscreen(e:Event = null):void
		{	 
	            // 1. Change the size of the Flash window to fullscreen/windowed
	            //    This is easily done by checking stage.displayState and then setting it accordingly
	            if (FlxG.stage.displayState == StageDisplayState.NORMAL)
	                FlxG.stage.displayState = StageDisplayState.FULL_SCREEN;
                else
	                FlxG.stage.displayState = StageDisplayState.NORMAL;
	 
	            windowResized();
        }
		 
	        
		/**
		 * This is called every time the window is resized.
		 * 
		 * @param e
		 * 
		 */		  
      public static function windowResized(e:Event = null):void
		{    
			FlxG.stage.align = ""; // Align the stage to the absolute center.
			
			if (FlxG.stage.stageWidth == 1280 || FlxG.stage.stageWidth == 1600 || FlxG.stage.stageWidth == 1920)
				FlxG.stage.scaleMode = StageScaleMode.SHOW_ALL; // Scale the stage to the window size, but preserve aspect ratio.
		}

	}
	
}