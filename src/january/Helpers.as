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
		
		/**
		 * Takes an array of weights, and returns a random index based on the weights
		 */
		public static function weightedChoice(weights:Array):int
		{
			// add weights
			var weightsTotal:Number = 0;
			
			for( var i:int = 0; i < weights.length; i++ )
				weightsTotal += weights[i];
			
			var rand:Number = Math.random() * weightsTotal;
			
			weightsTotal = 0;
			
			for (i = 0; i < weights.length; i++ )
			{
				weightsTotal += weights[i];
				
				if( rand < weightsTotal )
					return i;
			}
			
			// if random num is exactly = weightsTotal
			return weights.length - 1;
		}
		
	}
	
}