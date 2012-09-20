package january.colorlayers
{
	import january.*;
	
	import org.flixel.*;
	
	public class Haze extends ColorLayer
	{	
		public function Haze():void
		{
			super();
			
			_desiredAlpha = 0.24;
		}
		
		override public function onLick():void
		{				
			// Day/Night Cycle
			if (FlxG.score == 2)
				_layerOn = true;
			
			if (_layerOn == true)
				fade(0xFF999999, 30);
		}
			
	}
	
}