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
			noteVolume = 0.5;
		}
		
		public override function onLick():void
		{			
			var newKey:int = Helpers.randInt(0, Audio.keys.length - 1);
			
			// make sure that onLick, the Key flake always changes the key!
			if (newKey == Audio.keyID)
			{
				Audio.keyID = newKey + 1;
				if (Audio.keyID > Audio.keys.length - 1)
					Audio.keyID -= 2;
			}
			else
				Audio.keyID = newKey;
			
			Audio.octave();
			super.onLick();
		}
		
	}
	
}