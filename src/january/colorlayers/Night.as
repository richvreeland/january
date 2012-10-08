package january.colorlayers
{
	import january.*;
	import org.flixel.*;
	
	public class Night extends ColorLayer
	{	
		public function Night():void
		{
			super();
			
			_fillColor = 0xFF948DA6;
			blend = "multiply";
		}
		
		override public function onLick():void
		{			
			// What to show after the story is over.
			if (_layerOn == false && Text.storyOver == true)
			{
				alphaUp(60, 0.35);
				_layerOn == true;
			}
		}
		
	}
	
}