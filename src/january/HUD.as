package january
{
	import january.music.*;
	
	import org.flixel.*;
	
	public class HUD
	{
		/** The text sprite that holds note name, volume, pan, etc. */
		public static var noteData: FlxText;
		/** The text sprite that holds mode type, chord tones, etc. */
		public static var modeData: FlxText;
		/** Current mode in fancy form, with key and proper capitalization. */
		public static var modeName: String;
		/** The text sprite that holds key name, key quality, etc. */
		public static var keysData: FlxText;
		/** The "Save as MIDI" button. */
		public static var midiButton: Button;
		/** The font used for HUD objects. */
		public static const FONT: String = "frucade";
		/** Regular Expression used to find "s" for sharp. */
		private static var findSharp:RegExp = /\s*[s]/g;
		
		/** Sets up HUD! does everything but add it to the state. */
		public static function init():void
		{				
			noteData = new FlxText(9, -1, 256, "Note: ");
			modeData = new FlxText(8, 9, 256, "Mode: ");
			keysData = new FlxText(4, 19, 256, "Chord: ");
			midiButton = new Button();
			midiButton.x = FlxG.width - midiButton.width - 3;
			midiButton.y = 3;
			noteData.scrollFactor.x = modeData.scrollFactor.x = keysData.scrollFactor.x = 0;
			noteData.font = modeData.font = keysData.font = FONT;
			noteData.exists = modeData.exists = keysData.exists = false;			
		}
		
		/** Turns HUD on or off. */ 
		public static function toggle():void
		{
			// Press H to Toggle HUD.
			if(FlxG.keys.justPressed("H") && Game.end == false)		
				noteData.exists = modeData.exists = keysData.exists = !keysData.exists;
			
			// Press M to Toggle MIDI Save Button.
			if(FlxG.keys.justPressed("M"))
			{
				if (FlxG.mouse.visible)
					FlxG.mouse.hide();
				else
					FlxG.mouse.show();
				
				midiButton.exists = !midiButton.exists;
			}
		}
		
		/**
		 * Logs Note Data to HUD: ie. C3, 0.26 (volume), -0.3 (pan)
		 * 
		 * @param volume	Volume of note to be logged.
		 * @param pan		Pan position of note to be logged.
		 */		
		public static function logNote(volume:Number, pan:Number):void
		{		
			// Log note name, volume and pan to HUD
			var loggedNote: String = String(Note.lastAbsolute);
				loggedNote = loggedNote.slice(7);
				loggedNote = loggedNote.slice(0,-2);
				loggedNote = enharmonic(loggedNote);
			
			var loggedVolume: String = int( (volume*100)*(1/Note.MAX_VOLUME) ).toString() + "%";
			
			var loggedPan: String = int(pan*100).toString();
			
			if (loggedPan.match("-") != null)
			{
				loggedPan = loggedPan.substring(1);
				loggedPan = loggedPan + "% L";
			}
			else if (loggedPan != "0")
				loggedPan = loggedPan + "% R";
			
			noteData.text = "Note: " + loggedNote + ", Volume: " + loggedVolume + ", Pan: " + loggedPan;
		}
		
		/**
		 * Logs Mode Data to HUD.
		 *  
		 * @param currentMode	The current mode.
		 * @param chordTones	If a chord was just played, passes through the chord tones.
		 */		
		public static function logMode():void
		{
			var keyLetter: String;

			if (Key.current == "C Major")
			{
				if (Mode.current == "ionian")
					keyLetter = "C";
				else if (Mode.current == "dorian")
					keyLetter = "D";
				else if (Mode.current == "lydian")
					keyLetter = "F";
				else if (Mode.current == "mixolydian")
					keyLetter = "G";
				else if (Mode.current == "aeolian")
					keyLetter = "A";
			}
			else if (Key.current == "C Minor")
			{
				if (Mode.current == "ionian")
					keyLetter = "Eb";
				else if (Mode.current == "dorian")
					keyLetter = "F";
				else if (Mode.current == "lydian")
					keyLetter = "Ab";
				else if (Mode.current == "mixolydian")
					keyLetter = "Bb";
				else if (Mode.current == "aeolian")
					keyLetter = "C";
			}
			
			var firstLetter:String = Mode.current.substr(0, 1);
			var restOfString:String = Mode.current.substr(1, Mode.current.length);
			modeName = keyLetter + " " + firstLetter.toUpperCase() + restOfString.toLowerCase();
			modeData.text = "Mode: " + modeName;
		}
		
		/** Logs Key Data to HUD. */		
		public static function logEvent(chordTones:Array = null):void
		{
			if (chordTones != null)
			{
				var chordName: String = "";
				for (var i:int = 0; i <= chordTones.length - 1; i++)
				{
					var actualName: String = String(chordTones[i]);
					actualName = actualName.slice(12);
					actualName = actualName.slice(0,-2);
					actualName = enharmonic(actualName);
					chordName += actualName + " ";
				}
				
				keysData.text = "Chord: " + chordName;
			}
		}
		
		private static function enharmonic(text:String):String
		{
			if (text.search(findSharp) == 1)
			{
				text = text.replace(findSharp, "");
				
				for (var i:int = 0; i < Key.LETTERS.length - 1; i++)
				{
					if (text == Key.LETTERS[i])
					{
						text = Key.LETTERS[i+1];
						break;
					}
				}
				
				text += "b";
			}
			
			return text;
		}
		
		public static function hide():void
		{
			noteData.exists = modeData.exists = keysData.exists = false;
		}
	}
}