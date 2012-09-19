package january
{
	final public class Helpers
	{
		public static function rand(minNumber:Number, maxNumber:Number):Number
		{
			// Returns a random Number within a range.
			var result:Number = Math.random()*(maxNumber - minNumber) + minNumber;
			return result;
		}
		
		public static function randInt(minInt:int, maxInt:int):int
		{
			// Returns a random integer within a range.
			var result:int = Math.round(Math.random()*(maxInt - minInt) + minInt);
			return result;
		}
		
	}
	
}