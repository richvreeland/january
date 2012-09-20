package january.colorlayers
{
	import january.*;
	
	import org.flixel.*;
	
	public class Dusk extends ColorLayer
	{	
		public function Dusk():void
		{
			_desiredAlpha = 1;
			super();
		}
		
		override public function onLick():void
		{			
			// What to show after the story is over.
			if (PlayState.textOutput.storyOver == true)
			{				
				if (FlxG.score >= 50)
					fade(0xFFA799A3, 60, "multiply");
			}
		}
		
	}
	
}