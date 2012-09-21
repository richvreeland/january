package january.colorlayers
{
	import january.*;
	
	import org.flixel.*;
	
	public class Night extends ColorLayer
	{	
		public function Night():void
		{
			_desiredAlpha = 0.35;
			super();
		}
		
		override public function onLick():void
		{			
			// What to show after the story is over.
			if (Text.storyOver == true)
				fade(0xFF948DA6, 45, "multiply");
		}
		
	}
	
}