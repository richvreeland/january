package january.colorlayers
{
	import january.*;
	import org.flixel.*;
	
	public class Dusk extends ColorLayer
	{	
		public function Dusk():void
		{
			super();
			
			_desiredAlpha = 1;
		}
		
		override public function onLick():void
		{			
			// What to show after the story is over.
			if (_layerOn == false && Text.newScore == 50)
			{				
				fade(0xFFA799A3, 60, "multiply");
				_layerOn == true;
			}
		}
		
	}
	
}