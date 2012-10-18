package january.colorlayers
{
	import january.*;
	import org.flixel.*;
	
	public class Night extends ColorLayer
	{	
		public function Night():void
		{
			super();
			
			_fillColor = 0xFF544F63;
			blend = "multiply";
		}
		
		override public function onLick():void
		{			
			// What to show after the story is over.
			if (_layerOn == false && FlxG.score == 10)
			{
				alphaUp(120, 0.8);
				_layerOn = true;
			}

		}
		
	}
	
}