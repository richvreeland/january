package january.snowflakes
{
	import january.*;
	
	import org.flixel.*;

	public class Small extends Snowflake
	{
		public function Small()
		{			
			super();
			
			makeGraphic(1, 1);

			noteVolume = Helpers.rand(0.1, 0.25);
		}
		
		public override function onLick():void
		{	
			if (FlxG.score < 2 || PlayState.textOutput.storyOver == true)
				_pointValue = 1;
			else
				_pointValue = 0;
			
			super.onLick();			
			
			Music.generate(noteVolume, x);
		}

	}
}