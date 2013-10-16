package january.music
{
	import january.*;
	
	public class Intervals
	{
		/** An array of the interval names, used as a reference for populating the intervals object. */ 
		public static const DATABASE: Array /* of String */ = ["one1", "two1", "thr1", "for1", "fiv1", "six1", "sev1", "one2", "two2", "thr2", "for2", "fiv2", "six2", "sev2", "one3", "two3", "thr3", "for3", "fiv3", "six3", "sev3", "one4"];
		/** Whether the Intervals.loadout object is up to date or not. */
		public static var updated: Boolean = false;
		/** The intervals object, populated with the notes of the current key, ordered by the current mode. */
		public static var loadout: Object = {};
		
		public static function populate():void
		{
			// If the Intervals.loadout object is not already populated with the current key,
			if (updated == false)
			{						
				var modeOffset: int;
				if (Key.current == "C Minor")
					modeOffset = Mode.DATABASE[Mode.index].minorPos;
				else
					modeOffset = Mode.DATABASE[Mode.index].majorPos;
				
				for (var i:int = 0; i <= DATABASE.length - 1; i++)
					loadout[DATABASE[i]] = Key.DATABASE[Key.index][i + modeOffset];
				
				updated = true;
			}	
		}
	}
}