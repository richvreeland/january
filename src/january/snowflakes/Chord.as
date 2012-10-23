package january.snowflakes
{
	import january.*;
	
	public class Chord extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/chord.png")] private var sprite : Class;
		
		public function Chord()
		{
			super();
			
			loadGraphic(sprite);
			
			_windY = 16;
			_pointValue = 1;
		}
		
		public override function onLick():void
		{
			super.onLick();
			
			var newIndex:int = Helpers.randInt(0, modes.length - 1);
			
			// make sure that onLick, the Key flake always changes the key!
			while (newIndex == modeIndex)
				newIndex = Helpers.randInt(0, modes.length - 1);
			
			modeIndex = newIndex;
			
			//Update Current Key
			previousMode = currentMode;
			currentMode = modes[modeIndex].name;
			PlayState.HUDevent.text = "Mode: " + currentMode as String;
			
			playChord();
		}
	}
}