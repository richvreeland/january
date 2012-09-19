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
			var newKey:int = Helpers.randInt(0, Music.keys.length - 1);
			
			// make sure that onLick, the Key flake always changes the key!
			if (newKey == Music.keyID)
			{
				Music.keyID = newKey + 1;
				if (Music.keyID > Music.keys.length - 1)
					Music.keyID -= 2;
			}
			else
				Music.keyID = newKey;
			
			Music.chord();
			super.kill();
		}
		
	}
	
}