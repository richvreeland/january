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
			if (layerOn == false && Snowflake.mode == "Playback") //10
			{
				alphaUp(45, 0.5); //45, 0.85
				layerOn = true;
			}
		}
		
	}
	
}