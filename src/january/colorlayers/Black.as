package january.colorlayers
{
	import january.*;
	
	import org.flixel.*;
	
	public class Black extends ColorLayer
	{	
		public function Black():void
		{
			super();
			
			_fillColor = 0xFF000000;
			
			alpha = 1;
			alphaDown(5, 0);
		}
		
	}
	
}