package january
{	
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
			FlxG.fade(0xFF000000, 0.05, newState);
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

	}
	
}