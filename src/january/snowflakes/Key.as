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
			
			_pointValue = 1;
			noteVolume = 0.5;
		}
		
		public override function onLick():void
		{			
			super.onLick();
			
			var _newKey:int = Helpers.randInt(0, Music.keys.length - 1);
			
			// make sure that onLick, the Key flake always changes the key!
			if (_newKey == Music.keyID)
			{
				Music.keyID = _newKey + 1;
				if (Music.keyID > Music.keys.length - 1)
					Music.keyID -= 2;
			}
			else
				Music.keyID = _newKey;
			
			Music.chord(true);
		}
		
	}
	
}