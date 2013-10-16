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
		private static var yes: FlxButton;
		
		override public function create():void
		{
			FlxG.bgColor = 0xFF75899C;
			
			FlxG.mouse.load(mouse, 3);
			
				yes = new FlxButton(0, 0, "", onYes);
				yes.x = (FlxG.width - yes.width)/2;
				yes.height = 15;
				yes.y = (FlxG.height - yes.height)/2;
				yes.alpha = 0;
			add(yes);
			
				yesText = new FlxText(0, 0, 320, "Click to Play");
				yesText.setFormat("frucade", 8, 0xFFFFFF);
				yesText.x = (FlxG.width - yesText.realWidth)/2;
				yesText.y = (FlxG.height - yesText.height)/2;
			add(yesText);
			
			FlxG.mouse.show();
			
			super.create();
		}
		
		private function onYes():void
		{			
			//Game.fullScreen();
			FlxG.mouse.hide();
			newState();
		}
		
		private function newState():void
		{
			FlxG.switchState(new Game());
			
			mouse = null;
			soundText = yesText = null;
			yes = null;
		}
		
		override public function update():void
		{			
			if (FlxG.keys.SPACE || FlxG.keys.ENTER)
				newState();
			
			super.update();
		}

	}
	
}