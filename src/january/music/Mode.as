package january.music
{
	import january.*;
	import org.flixel.*;

	public class Mode
	{
		// Modes. Ionian in Major is 3 Octaves, Aeolian in Minor. The rest are 2 octaves.
		public static const	IONIAN		: Object = {name: "ionian", 	majorPos: 1, minorPos: 3};
		public static const	DORIAN		: Object = {name: "dorian", 	majorPos: 2, minorPos: 4};
		public static const	LYDIAN		: Object = {name: "lydian", 	majorPos: 4, minorPos: 6};
		public static const	MIXOLYDIAN	: Object = {name: "mixolydian", majorPos: 5, minorPos: 7};
		public static const	AEOLIAN		: Object = {name: "aeolian", 	majorPos: 6, minorPos: 1};
		/** Array of all the modes. */
		public static const	DATABASE: Array /* of Object */ = [IONIAN, DORIAN, LYDIAN, MIXOLYDIAN, AEOLIAN];
		/** Number used with mode array to select and identify the current mode. */
		public static var index: int = 0;
		/** The current mode, and the string equivalent of modeIndex. */
		public static var current: String = "";
		/** The previous mode. */
		public static var previous: String = "";
		
		public static function change():void
		{
			var newIndex:int = Helper.randInt(0, DATABASE.length - 1);			
			while (newIndex == index)
				newIndex = Helper.randInt(0, DATABASE.length - 1);	
			index = newIndex;
			init();
		}
		
		public static function cycle():void
		{
				if (FlxG.keys.justPressed("COMMA"))
				{
					index--;
					if (index < 0)
						index = DATABASE.length - 1;
					
					init();
					Playback.numbers.show(HUD.modeName);
				}
				
				if (FlxG.keys.justPressed("PERIOD"))
				{
					index++;
					if (index > DATABASE.length - 1)
						index = 0;
					
					init();
					Game.secretFeedback.show(HUD.modeName);
				}
		}
		
		public static function init():void
		{
			previous = current;
			current = DATABASE[index].name;
			Intervals.updated = false;
			Intervals.populate();
			HUD.logMode();
		}
	}
}