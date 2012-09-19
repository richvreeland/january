package january.snowflakes
{
	import january.*;
	
	public class Large extends Snowflake
	{
		public function Large()
		{
			super();
			
			makeGraphic(2, 2);
			noteVolume = Helpers.rand(0.25, 0.5);
		}

	}
}