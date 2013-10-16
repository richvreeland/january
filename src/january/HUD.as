package january
{
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.utils.*;
	import january.music.*;
	import org.flixel.*;
	
	public class HUD
	{
		/** The text sprite that holds note name, volume, pan, etc. */
		public static var row1: FlxText;
		/** The text sprite that holds mode type, chord tones, etc. */
		public static var row2: FlxText;
		/** The text sprite that holds chord information, etc. */
		public static var row3: FlxText;
		/** Current mode in fancy form, with key and proper capitalization. */
		public static var modeName: String = "";
		/** Current mode in fancy form, with key and proper capitalization. */
		public static var noteText: String = "";

		/** The "Save as MIDI" button. */
		public static var midiButton: Button;
		/** The font used for HUD objects. */
		public static const FONT: String = "frucade";
		/** Regular Expression used to find "s" for sharp. */
		private static var findSharp:RegExp = /\s*[s]/g;
		
		/** Sets up HUD! does everything but add it to the state. */
		public static function init():void
		{				
			row1 = new FlxText(4, -1, 256, "");
			row2 = new FlxText(4, 9, 256, "");
			row3 = new FlxText(4, 19, 256, "");
			midiButton = new Button();
			midiButton.x = FlxG.width - midiButton.width - 3;
			midiButton.y = 3;
			row1.scrollFactor.x = row2.scrollFactor.x = row3.scrollFactor.x = 0;
			row1.font = row2.font = row3.font = FONT;
			row1.exists = row2.exists = row3.exists = false;			
		}
		
		/** Turns HUD on or off. */ 
		public static function toggle():void
		{
			row1.exists = row2.exists = row3.exists = !row3.exists;
		}
		
		public static function midi():void
		{
			FlxG.stage.displayState = StageDisplayState.NORMAL;
			
			if (FlxG.mouse.visible)
			{
				FlxG.mouse.hide();
				FlxG.stage.removeEventListener(MouseEvent.MOUSE_DOWN, MIDI.generate);
			}
			else
			{
				FlxG.mouse.show(); 
				FlxG.stage.addEventListener(MouseEvent.MOUSE_DOWN, MIDI.generate);
			}
			
			midiButton.exists = !midiButton.exists;
		}
		
		/**
		 * Logs Note Data to HUD: ie. C3, 0.26 (volume), -0.3 (pan)
		 * 
		 * @param volume	Volume of note to be logged.
		 * @param pan		Pan position of note to be logged.
		 */		
		public static function logNote(volume:Number, pan:Number):void
		{					
			row1.text = "";
			
			// Log note name, volume and pan to HUD
			var loggedNote: String = enharmonic(getQualifiedClassName(Note.lastAbsolute));	
			var loggedVolume: String = int( (volume*100)*(1/Note.MAX_VOLUME) ).toString() + "%";		
			var loggedPan: String = int(pan*100).toString();
			
			if (loggedPan.match("-") != null)
			{
				loggedPan = loggedPan.substring(1);
				loggedPan = loggedPan + "% L";
			}
			else if (loggedPan != "0")
				loggedPan = loggedPan + "% R";
			
			noteText = loggedNote + ", in ";
			row1.text = noteText + modeName + ".";
			row2.text = "Vol: " + loggedVolume + ", Pan: " + loggedPan;
		}
		
		/**
		 * Logs Mode Data to HUD.
		 *  
		 * @param currentMode	The current mode.
		 * @param chordTones	If a chord was just played, passes through the chord tones.
		 */		
		public static function logMode():void
		{
			var keyLetter: String = enharmonic(getQualifiedClassName(Intervals.loadout.one1));
			
			if (Scale.isPentatonic)
			{
				if (Mode.current == Mode.AEOLIAN || Mode.current == Mode.DORIAN)
					modeName = "Minor";
				else
					modeName = "Major";
						
				modeName = keyLetter + " " + modeName + " Pentatonic";
			}
			else
				modeName = keyLetter + " " + Mode.current.name;
						
			row1.text = noteText + modeName + ".";
		}
		
		/** Logs Key Data to HUD. */		
		public static function logEvent(chordTones:Array = null):void
		{
			//FlxG.log("logEvent()");
			
			if (chordTones != null)
			{
				var chordName: String = "";
				for (var i:int = 0; i <= chordTones.length - 1; i++)
				{
					var actualName: String = enharmonic(getQualifiedClassName(chordTones[i]));
					chordName += actualName + " ";
				}
				
				row3.text = "Last Chord: " + chordName;
			}
		}
		
		private static function enharmonic(text:String):String
		{
			text = text.slice(0,-1);
			
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
		
		private static function hide():void
		{
			row1.exists = row2.exists = row3.exists = false;
		}
	}
}