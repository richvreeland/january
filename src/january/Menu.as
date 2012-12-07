package january
{	
	import flash.events.Event;
	import flash.display.StageDisplayState;
	import org.flixel.*;
	
	public class Menu extends FlxState
	{
		[Embed(source="../assets/art/cursor.png")] private static var mouse: Class;
		
		private static var soundText: FlxText;
		private static var yesText: FlxText;
		private static var noText: FlxText;
		private static var yes: FlxButton;
		private static var no: FlxButton;
		private static var n: int = 0;
		
		override public function create():void
		{
			FlxG.bgColor = 0xFF75899C;
			
			FlxG.mouse.load(mouse, 3);
			
				soundText = new FlxText(0, 30, 320, "is your sound turned on?");
				soundText.setFormat("frucade", 8, 0xFFFFFFFF, "center", 0);
			add(soundText);
			
				yes = new FlxButton(62, 78, "", onYes);
				yes.width  = 120;
				yes.height = 15;
				yes.alpha = 0;
			add(yes);
			
				yesText = new FlxText(66, 78, 100, "Yes.");
				yesText.setFormat("frucade", 8, 0xFFFFFF);
			add(yesText);
			
			
				no = new FlxButton(210, 78, "", onNo);
				no.width  = 120;
				no.height = 15;
				no.alpha = 0;
			add(no);
			
				noText = new FlxText(238, 78, 100, "No.");
				noText.setFormat("frucade", 8, 0xFFFFFF);
			add(noText);
			
			FlxG.mouse.show();
			
			FlxG.flash(0xFF000000, 1);
			
			super.create();
		}
		
		private function onYes():void
		{			
			//Game.fullScreen();
			FlxG.mouse.hide();
			FlxG.fade(0xFF000000, 1, newState);
		}
		
		private function newState():void
		{
			FlxG.switchState(new Game());
			
			mouse = null;
			soundText = yesText = noText = null;
			yes = no = null;
			n = 0;
		}
		
		private function onNo():void
		{			
			n++;
			
			if (n == 1)
			{
				yesText.text = "okay, i'm ready.";
				soundText.text = "trust me, you want sound for this."
			}
			else if (n == 2)
			{		
				yesText.text = "play the game.";
				soundText.text = "fine. but don't complain when you're bored!";
			}
			else if (n == 3)
			{
				yesText.text = "i've had my fun.";
				soundText.text = "...";
			}
			else if (n == 4)
			{
				yesText.text = "No.";
				soundText.text = "No.";
			}
			else if (n == 5)
			{
				yesText.text = "";
				noText.text = "";
				soundText.text = "ERROR";
				FlxG.bgColor = 0xFF0000FF;
				yes.exists = false;
				no.exists = false;
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