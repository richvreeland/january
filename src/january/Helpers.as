package january
{
	import org.flixel.FlxG;
	
	final public class Helpers
	{		
		public static function flatten(arrays:Array):Array
		{
			var result:Array = [];
			for(var i:int = 0; i < arrays.length; i++)
			{
				result = result.concat(arrays[i]);
			}
			return result;
		}
		
		public static function removeItemArray(theArray:Array, theItem:*):Array
		{
			for(var i:int=0; i < theArray.length; i++)
			{
				if(theArray[i] == theItem)
				{
					theArray.splice(i,1);
					i-=1;
				}
			}
			
			return theArray;
		}
		
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
		
		/** Will pull a random object from an array and return it. */
		public static function randomPull(Objects:Array,StartIndex:uint=0,Length:uint=0):*
		{
			if(Objects != null)
			{
				var l:uint = Length;
				if((l == 0) || (l > Objects.length - StartIndex))
					l = Objects.length - StartIndex;
				if(l > 0)
					return Objects[StartIndex + uint(FlxG.random()*l)];
			}
			return null;
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