package january
{	
	import flash.events.*;
	
	import january.*;
	
	import org.flixel.*;
	
	public class MenuState extends FlxState
	{
		[Embed(source="../assets/art/flakes/key.png")] private var mouse : Class;
		
		private var _soundText	:FlxText;
		private var _yesText	:FlxText;
		private var _noText		:FlxText;
		private var _yes		:FlxButton;
		private var _no			:FlxButton;
		
		private static var n : int = 0;
		
		override public function create():void
		{
			FlxG.bgColor = 0xFF000000;
			
			FlxG.mouse.load(mouse, 3);
			
			// Start off in windowed mode
            //toggleFullscreen(StageDisplayState.NORMAL);
			
				_soundText = new FlxText(0, 30, 320, "is your sound turned on?");
				_soundText.setFormat("frucade", 8, 0xFFFFFFFF, "center", 0);
			add(_soundText);
			
				_yes = new FlxButton(62, 78, "", yes);
				_yes.width  = 120;
				_yes.height = 15;
				_yes.color  = 0xFF000000;
			add(_yes);
			
				_yesText = new FlxText(66, 78, 100, "Yes.");
				_yesText.setFormat("frucade", 8, 0xFFFFFF);
			add(_yesText);
			
			
				_no = new FlxButton(210, 78, "", no);
				_no.width  = 120;
				_no.height = 15;
				_no.color  = 0xFF000000;
			add(_no);
			
				_noText = new FlxText(238, 78, 100, "No.");
				_noText.setFormat("frucade", 8, 0xFFFFFF);
			add(_noText);
			
			FlxG.mouse.show();
			
			FlxG.flash(0xFF000000, 1);
			
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
			n++;
			
			if (n == 1)
			{
				_yesText.text = "okay, i'm ready.";
				_soundText.text = "trust me, you want sound for this."
			}
			else if (n == 2)
			{		
				_yesText.text = "play the game.";
				_soundText.text = "fine. but don't complain when you're bored!";
			}
			else if (n == 3)
			{
				_yesText.text = "i've had my fun.";
				_soundText.text = "...";
			}
			else if (n == 4)
			{
				_yesText.text = "No.";
				_soundText.text = "No.";
			}
			else if (n == 5)
			{
				_yesText.text = "";
				_noText.text = "";
				_soundText.text = "ERROR";
				FlxG.bgColor = 0xFF0000FF;
				_yes.exists = false;
				_no.exists = false;
				FlxG.mouse.hide();
			}
		}
		
		override public function update():void
		{
			if (FlxG.keys.SPACE || FlxG.keys.ENTER)
				newState();
			
			super.update();
		}

	}
	
}