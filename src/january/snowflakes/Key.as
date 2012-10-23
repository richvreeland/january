package january.snowflakes
{
	import january.*;
	
	import org.flixel.plugin.photonstorm.*;
	
	public class Key extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/key.png")] private var sprite : Class;
		
		public function Key()
		{
			super();
			
			loadGraphic(sprite);
			
			_windY = 15;
			_pointValue = 1;
		}
		
		public override function onLick():void
		{			
			super.onLick();
			
			var newIndex:int = Helpers.randInt(0, keys.length - 1);
			
			// make sure that onLick, the Key flake always changes the key!
			while (newIndex == keyIndex)
				newIndex = Helpers.randInt(0, keys.length - 1);
			
			keyIndex = newIndex;
			
			//Update Current Key
			currentKey = keys[keyIndex][0];
			PlayState.HUDkey.text = "Key: " + currentKey;
			
			playChord();
		}
		
	}
	
}