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
		
		/*
		* Pick a random choice from a series of options
		*/
		public static function pickFrom(... options:Array):*
		{
			return options[Math.round(Math.random()*(options.length - 1))];
		}
		
		/**
		 * Generate a random boolean result based on the chance value.
		 */
		public static function chanceRoll(chance:int = 50):Boolean
		{
			if (chance <= 0)
				return false;
			else if (chance >= 100)
				return true;
			else
			{
				if (Math.random() * 100 >= chance)
					return false;
				else
					return true;
			}
		}
		
	}
	
}