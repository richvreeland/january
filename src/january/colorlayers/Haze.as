package january.colorlayers
{
	import january.*;
	import org.flixel.*;
	
	public class Haze extends ColorLayer
	{	
		public function Haze():void
		{
			super();
			
			fillColor = 0xFF999999;
		}
		
		override public function onLick():void
		{				
			// Start Haze Effect whenever first snowflake is licked.
			if (layerOn == false)
			{
				alphaUp(15, 0.24);
				layerOn = true;
			}
		}
			
	}
	
}