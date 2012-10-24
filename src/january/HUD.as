package january
{
	import org.flixel.*;
	import january.music.*;
	
	public class HUD
	{
		/** The text sprite that holds note name, volume, pan, etc. */
		public static var noteData: FlxText;
		/** The text sprite that holds mode type, chord tones, etc. */
		public static var modeData: FlxText;
		/** The text sprite that holds key name, key quality, etc. */
		public static var keysData: FlxText;
		/** The font used for HUD objects. */
		public static const FONT: String = "frucade";
		
		/** Sets up HUD! does everything but add it to the state. */
		public static function init():void
		{				
			noteData = new FlxText(6, -2, 256, "Note: ");
			modeData = new FlxText(2, 8, 256, "Event: ");
			keysData = new FlxText(11, 18, 256, "Key: ");
			noteData.scrollFactor.x = modeData.scrollFactor.x = keysData.scrollFactor.x = 0;
			noteData.font = modeData.font = keysData.font = FONT;
			noteData.exists	= modeData.exists = keysData.exists = false;			
		}
		
		/** Turns HUD on or off. */ 
		public static function toggle():void
		{
			if(FlxG.keys.justPressed("H") == true)
				keysData.exists = noteData.exists = modeData.exists = !keysData.exists;
		}
		
		/**
		 * Logs Note Data to HUD: ie. C3, 0.26 (volume), -0.3 (pan)
		 * 
		 * @param volume	Volume of note to be logged.
		 * @param pan		Pan position of note to be logged.
		 * 
		 */		
		public static function logNote(volume:Number, pan:Number):void
		{		
			// Log note name, volume and pan to HUD
			var actualName: String = String(Note.lastAbsolute);
			actualName = actualName.slice(12);
			actualName = actualName.slice(0,-1);
			actualName = actualName.replace(/s/,"#");
			noteData.text = "Note: " + actualName + ", Volume: " + int(volume*100)/100 + ", Pan: " + int(pan*100)/100;
		}
		
		/**
		 * Logs Mode Data to HUD.
		 *  
		 * @param currentMode	The current mode.
		 * @param chordTones	If a chord was just played, passes through the chord tones.
		 */		
		public static function logMode(chordTones:Array = null):void
		{
			var firstLetter:String = Mode.current.substr(0, 1);
			var restOfString:String = Mode.current.substr(1, Mode.current.length);	
			modeData.text = "Event: " + firstLetter.toUpperCase() + restOfString.toLowerCase();;
			
			if (chordTones != null)
			{
				var chordName: String = "";
				for (var i:int = 0; i <= chordTones.length - 1; i++)
				{
					FlxG.log(chordTones[i]);
					var actualName: String = String(chordTones[i]);
					actualName = actualName.slice(12);
					actualName = actualName.slice(0,-1);
					actualName = actualName.replace(/s/,"#");
					chordName += actualName + " ";
				}
				
				modeData.text += ", " + chordName;
			}
		}
		
		/**
		 * Logs Key Data to HUD.
		 *  
		 * @param currentKey	The current key.
		 * 
		 */		
		public static function logKey():void
		{
			keysData.text = "Key: " + Key.current;
		}
	}
}