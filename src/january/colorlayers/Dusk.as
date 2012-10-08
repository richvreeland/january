package january.colorlayers
{
	import january.*;
	import org.flixel.*;
	
	public class Dusk extends ColorLayer
	{	
		public function Dusk():void
		{
			super();
			
			_fillColor = 0xFFA799A3;
			blend = "multiply";
		}
		
		override public function onLick():void
		{			
			// What to show after the story is over.
			if (_layerOn == false && Text.newScore == 50)
			{				
				alphaUp(60, 1);
				_layerOn == true;
			}
		}
		
	}
	
}