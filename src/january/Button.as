package january
{
	import org.flixel.*;
	import january.music.*;
	
	public class Button extends FlxButton
	{
		[Embed(source="../assets/art/midi_button.png")] private static var sprite: Class;
		
		public function Button()
		{
			super(0,0,"",MIDI.generate);
			
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