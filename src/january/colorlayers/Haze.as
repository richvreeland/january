package january.colorlayers
{
	import january.*;
	import org.flixel.*;
	
	public class Haze extends ColorLayer
	{	
		public function Haze():void
		{
			super();
			
			_fillColor = 0xFF999999;
		}
		
		override public function onLick():void
		{				
			// Start Haze Effect when score is 2.
			if ( _layerOn == false && FlxG.score == 2)
			{
				alphaUp(60, 0.24);
				_layerOn = true;
			}
		}
			
	}
	
}