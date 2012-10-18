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
		}
		
		public override function onLick():void
		{			
			super.onLick();
			
			var newKey:int = Helpers.randInt(0, keysLength - 1);
			
			// make sure that onLick, the Key flake always changes the key!
			while (newKey == keyIndex)
				newKey = Helpers.randInt(0, keysLength - 1);
			
			keyIndex = newKey;
			
			playChord();
		}
		
	}
	
}