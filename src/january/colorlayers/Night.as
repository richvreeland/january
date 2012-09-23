package january.colorlayers
{
	import january.*;
	import org.flixel.*;
	
	public class Night extends ColorLayer
	{	
		public function Night():void
		{
			super();
			
			_desiredAlpha = 0.35;
		}
		
		override public function onLick():void
		{			
			// What to show after the story is over.
			if (_layerOn == false && Text.storyOver == true)
			{
				fade(0xFF948DA6, 60, "multiply");
				_layerOn == true;
			}
		}
		
	}
	
}