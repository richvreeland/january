package january.colorlayers
{
	import january.*;
	import january.music.*;
	import org.flixel.*;
	
	public class Night extends ColorLayer
	{	
		public function Night():void
		{
			super();
			
			fillColor = 0xFF544F63;
			blend = "multiply";
		}
		
		override public function onLick():void
		{			
			if (layerOn == false && Playback.mode == true) //10
			{
				alphaUp(45, 0.85); //120
				layerOn = true;
			}
		}
		
	}
	
}