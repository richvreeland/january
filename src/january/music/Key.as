package january.music
{
	import january.HUD;
	import january.Helpers;
	import org.flixel.plugin.photonstorm.FlxMath;

	public class Key
	{		
		/* Musical keys, stored in Arrays. */
		public static const C_MAJOR		: Array = ["C Major", Note.C1, Note.D1, Note.E1, Note.F1, Note.G1, Note.A1, Note.B1, Note.C2, Note.D2, Note.E2, Note.F2, Note.G2, Note.A2, Note.B2, Note.C3, Note.D3, Note.E3, Note.F3, Note.G3, Note.A3, Note.B3, Note.C4, Note.D4, Note.E4, Note.F4, Note.G4, Note.A4, Note.B4];
		public static const C_MINOR		: Array = ["C Minor", Note.C1, Note.D1, Note.Ds1, Note.F1, Note.G1, Note.Gs1, Note.As1, Note.C2, Note.D2, Note.Ds2, Note.F2, Note.G2, Note.Gs2, Note.As2, Note.C3, Note.D3, Note.Ds3, Note.F3, Note.G3, Note.Gs3, Note.As3, Note.C4, Note.D4, Note.Ds4, Note.F4, Note.G4, Note.Gs4, Note.As4]
		/** Array of all the keys. */
		public static const DATABASE	: Array /* of Array */ = [C_MAJOR, C_MINOR];
		/** Number used with key array to select and identify the current key. */
		public static var index			: int = Helpers.randInt(0, DATABASE.length - 1);
		/** The current key, and the string equivalent of keyIndex. */
		public static var current		: String = DATABASE[index][0];
		/** Whether or not the key has been just changed. */
		public static var justChanged	: Boolean;
	
		public static function change():void
		{
			var newIndex:int = Helpers.randInt(0, DATABASE.length - 1);
			while (newIndex == index)
				newIndex = Helpers.randInt(0, DATABASE.length - 1);			
			index = newIndex;
			current = DATABASE[index][0];
			Intervals.updated = false;
			Intervals.populate();
			
			if (Playback.mode == true)
			{
				var currentInterval:String = Playback.sequence[Playback.index];
				
				// Check for tension notes (2nds, 4ths, and 6ths)
				if (currentInterval == "two1" || currentInterval == "for1" || currentInterval == "six1" || currentInterval == "two2" || currentInterval == "for2" || currentInterval == "six2" || currentInterval == "two3" || currentInterval == "for3" || currentInterval == "six3")
				{
					// Shift the interval for the next note to be played up or down one spot, to a chord tone.
					for (var i:int = 0; i < Intervals.DATABASE.length - 1; i++)
					{
						if (currentInterval == Intervals.DATABASE[i])
							Playback.sequence[Playback.index] = Intervals.DATABASE[i + FlxMath.randomSign()];
					}
				}		
					
			}
			
			justChanged = true;
			
			HUD.logKey();
		}
	}
}