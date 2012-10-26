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
			if (layerOn == false && FlxG.score == 10) //10
			{
				alphaUp(120, 0.85); //120
				layerOn = true;
			}
		}
		
	}
	
}