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
			if (layerOn == false && FlxG.score == 2) //10
			{
				alphaUp(10, 0.85); //120
				layerOn = true;
			}

		}
		
	}
	
}