package january
{
	import flash.display.*;
	import flash.events.MouseEvent;
	
	import january.music.*;
	
	import org.flixel.*;
	
	public class Button extends FlxButton
	{
		[Embed(source="../assets/art/midi_button.png")] private static var sprite: Class;
		
		public function Button()
		{
			super(0,0,"");
			
			loadGraphic(sprite, true, false, 97, 16);
			addAnimation("default",[0,1],3);
			scrollFactor.x = 0;
			exists = false;
		}
		
		override protected function updateButton():void
		{
			super.updateButton();
			
			play("default");
		}
	}
}