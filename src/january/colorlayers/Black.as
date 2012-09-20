package january.colorlayers
{
	import january.*;
	
	import org.flixel.*;
	
	public class Black extends ColorLayer
	{	
		public function Black():void
		{
			super();
			
			_desiredAlpha = 0;
			flash(0xFF000000,15);
		}
		
	}
	
}