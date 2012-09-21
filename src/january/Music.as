package january
{		
	import january.snowflakes.*;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Music
	{
		// Import Tones	
		[Embed(source="../assets/audio/notes/C1.mp3")]	public static var C1:Class;
		[Embed(source="../assets/audio/notes/C#1.mp3")]	public static var Cs1:Class;
		[Embed(source="../assets/audio/notes/D2.mp3")]	public static var D1:Class;
		[Embed(source="../assets/audio/notes/D#1.mp3")]	public static var Ds1:Class;
		[Embed(source="../assets/audio/notes/E2.mp3")]	public static var E1:Class;
		[Embed(source="../assets/audio/notes/F1.mp3")]	public static var F1:Class;
		[Embed(source="../assets/audio/notes/F#1.mp3")]	public static var Fs1:Class;
		[Embed(source="../assets/audio/notes/G2.mp3")]	public static var G1:Class;
		[Embed(source="../assets/audio/notes/G#1.mp3")]	public static var Gs1:Class;
		[Embed(source="../assets/audio/notes/A2.mp3")]	public static var A1:Class;
		[Embed(source="../assets/audio/notes/A#1.mp3")]	public static var As1:Class;
		[Embed(source="../assets/audio/notes/B1.mp3")]	public static var B1:Class;
		[Embed(source="../assets/audio/notes/C2.mp3")]	public static var C2:Class;
		[Embed(source="../assets/audio/notes/C#2.mp3")]	public static var Cs2:Class;
		[Embed(source="../assets/audio/notes/D2.mp3")]	public static var D2:Class;
		[Embed(source="../assets/audio/notes/D#2.mp3")]	public static var Ds2:Class;
		[Embed(source="../assets/audio/notes/E2.mp3")]	public static var E2:Class;
		[Embed(source="../assets/audio/notes/F2.mp3")]	public static var F2:Class;
		[Embed(source="../assets/audio/notes/F#2.mp3")]	public static var Fs2:Class;
		[Embed(source="../assets/audio/notes/G2.mp3")]	public static var G2:Class;
		[Embed(source="../assets/audio/notes/G#2.mp3")]	public static var Gs2:Class;
		[Embed(source="../assets/audio/notes/A2.mp3")]	public static var A2:Class;
		[Embed(source="../assets/audio/notes/A#2.mp3")]	public static var As2:Class;
		[Embed(source="../assets/audio/notes/B2.mp3")]	public static var B2:Class;
		[Embed(source="../assets/audio/notes/C3.mp3")]	public static var C3:Class;
		[Embed(source="../assets/audio/notes/C#3.mp3")]	public static var Cs3:Class;
		[Embed(source="../assets/audio/notes/D3.mp3")]	public static var D3:Class;
		[Embed(source="../assets/audio/notes/D#3.mp3")]	public static var Ds3:Class;
		[Embed(source="../assets/audio/notes/E3.mp3")]	public static var E3:Class;
		[Embed(source="../assets/audio/notes/F3.mp3")]	public static var F3:Class;
		[Embed(source="../assets/audio/notes/F#3.mp3")]	public static var Fs3:Class;
		[Embed(source="../assets/audio/notes/G3.mp3")]	public static var G3:Class;
		[Embed(source="../assets/audio/notes/G#3.mp3")]	public static var Gs3:Class;
		[Embed(source="../assets/audio/notes/A3.mp3")]	public static var A3:Class;
		[Embed(source="../assets/audio/notes/A#3.mp3")]	public static var As3:Class;
		[Embed(source="../assets/audio/notes/B3.mp3")]	public static var B3:Class;
		[Embed(source="../assets/audio/notes/C4.mp3")]	public static var C4:Class;
		[Embed(source="../assets/audio/notes/C#4.mp3")]	public static var Cs4:Class;
		[Embed(source="../assets/audio/notes/D4.mp3")]	public static var D4:Class;
		[Embed(source="../assets/audio/notes/D#4.mp3")]	public static var Ds4:Class;
		[Embed(source="../assets/audio/notes/E4.mp3")]	public static var E4:Class;
		[Embed(source="../assets/audio/notes/F4.mp3")]	public static var F4:Class;
		[Embed(source="../assets/audio/notes/F#4.mp3")]	public static var Fs4:Class;
		[Embed(source="../assets/audio/notes/G4.mp3")]	public static var G4:Class;
		[Embed(source="../assets/audio/notes/G#4.mp3")]	public static var Gs4:Class;
		[Embed(source="../assets/audio/notes/A4.mp3")]	public static var A4:Class;
		[Embed(source="../assets/audio/notes/A#4.mp3")]	public static var As4:Class;
		[Embed(source="../assets/audio/notes/B4.mp3")]	public static var B4:Class;	
		
		public static var notes:  Array = [C1,Cs1,D1,Ds1,E1,F1,Fs1,G1,Gs1,A1,As1,B1,C2,Cs2,D2,Ds2,E2,F2,Fs2,G2,Gs2,A2,As2,B2,C3,Cs3,D3,Ds3,E3,F3,Fs3,G3,Gs3,A3,As3,B3,C4,Cs4,D4,Ds4,E4,F4,Fs4,G4,Gs4,A4,As4,B4];
		
		public static var eMinor: Array = [E1,Fs1,G1,A1,B1,Cs2,D2,E2,Fs2,G2,A2,B2,Cs3,D3,E3,Fs3,G3,A3,B3,Cs4,D4,E4,Fs4,G4,A4,B4];
		public static var gMajor: Array = [B1,D2,E2,Fs2,G2,A2,B2,D3,E3,Fs3,G3,A3,B3,D4,E4,Fs4,G4,A4];
		public static var keys:	  Array = ["EMinor", "GMajor"];
		
		
		public static var keyID: int;	
		public static var previous: Class;
		
		/** Volume for the Next Tone. */
		private static var _volume: Number;
		
		/** Pan Value for the Next Tone. */
		private static var _pan: Number;
		
		/** The very first tone that's triggered. */
		private static var _initial: Class = eMinor[Helpers.randInt(0, eMinor.length - 1)];
		
		public static function generate(noteVolume: Number = 0, panX : Number = 0):void
		{																			
			_volume = noteVolume;
			
			// Convert X position to pan position.
			_pan = 2 * ((panX - PlayState.camera.scroll.x) / FlxG.width) - 1;
						
			if (keyID == 0 || _initial == E1 || _initial == E2 || _initial == E3 || _initial == E4)
				keyID = 0;
			else
				keyID = 1;
			
				var functionName:String = "in" + keys[keyID];
				var keyFunction:Function = Music[functionName];
				keyFunction();
				
				PlayState.HUDkey.text = "Key: " + keys[keyID];
			
			// if this is the first note
			if (previous == null)
			{
				FlxG.play(_initial, 0.5);
				previous = _initial;
			}
			
			if (Snowflake.pedalPointMode == true)
				pedalPoint();
			
		}
		
		private static function generateNextInterval(... options):void
		{			
			
			var _random: int = Helpers.randInt(0, options.length - 1);
			var _randomNote: Class = options[_random];
			
			if (_volume == 0)
				_volume = Helpers.rand(0.1, 0.5);			
						
			FlxG.play(_randomNote, _volume, _pan);
			PlayState.HUDnote.text = "Note: " + _randomNote;
			
			previous = _randomNote;
		}
		
		public static function chord(isKeyFlake:Boolean):void
		{			
			var _chordTone1: Class;
			var _chordTone2: Class;
			var _chordTone3: Class;
			var _chordChoice: String;
			
			if (keyID == 0) 		// E Minor
			{
				// Pick a Chord Type to Generate
				_chordChoice = Helpers.pickFrom("i","v");
				
				if (_chordChoice == "i" || isKeyFlake == true)
				{
					_chordTone1 = Helpers.pickFrom(E1,E3);
					_chordTone2 = Helpers.pickFrom(G2,E2);
					_chordTone3 = Helpers.pickFrom(B1,Cs2);
				}
				else if (_chordChoice == "v")
				{
					_chordTone1 = Helpers.pickFrom(B1,B2);
					_chordTone2 = Helpers.pickFrom(D3,Cs3);
					_chordTone3 = Helpers.pickFrom(Fs2,Fs3);
				}
			}
			else if (keyID == 1) 	// G Major
			{
				// Pick a Chord Type to Generate
				_chordChoice = Helpers.pickFrom("I","iii");
				
				if (_chordChoice == "I" || isKeyFlake == true)
				{
					_chordTone1 = Helpers.pickFrom(G1,G2);
					_chordTone2 = Helpers.pickFrom(G2,B2);
					_chordTone3 = Helpers.pickFrom(D2,E2);
				}
				else if (_chordChoice == "iii")
				{
					_chordTone1 = Helpers.pickFrom(B1,B2);
					_chordTone2 = Helpers.pickFrom(D3,D2);
					_chordTone3 = Helpers.pickFrom(Fs2,Fs3);
				}
			}
						
			FlxG.play(_chordTone1, 0.15, 0);
			FlxG.play(_chordTone2, 0.15, 1);
			FlxG.play(_chordTone3, 0.15,-1);
			
			PlayState.HUDevent.text = "Chord: " + _chordChoice;
		}
		
		public static function octave():void
		{			
			var _octaveTone: Class;
			
			for (var i:int = notes.length - 1; i > 0; --i)
			{								
				if (previous == notes[i] && i < (notes.length - 12))
					_octaveTone = notes[i+12];	
				else if (previous == notes[i] && i >= (notes.length - 12))
					_octaveTone = notes[i-12];
			}
		
			FlxG.play(_octaveTone, 0.1, -0.5);
		}
		
		public static function pedalPoint():void
		{			
			var _pedalTone: Class;
			
			if (keyID == 0) 		// E Minor
				_pedalTone = Helpers.pickFrom(E1,E2);
			else if (keyID == 1) 	// G Major
				_pedalTone = Helpers.pickFrom(G1,G2);
			
			FlxG.play(_pedalTone, Helpers.rand(0.05, 0.15), Helpers.rand(-1, 1));
		}
		
		private static function inEMinor():void
		{			
				 if (previous == E1) 	generateNextInterval(Fs1,G1,B1,B2,Cs2,E2);
			else if (previous == Fs1)	generateNextInterval(E1,Fs2,Fs3,G1,D2,E2);
			else if (previous == G1)	generateNextInterval(E1,A1,B1,D2,Fs2,G2,G3);
			else if (previous == A1)	generateNextInterval(Cs2,E2,A2,B2);
			else if (previous == B1)	generateNextInterval(A1,Cs2,D2,Fs2,B2);
		 	else if (previous == Cs2)	generateNextInterval(Fs1,D2,B2,Cs3);
			else if (previous == D2)	generateNextInterval(Cs2,E2,Fs2);
			else if (previous == E2) 	generateNextInterval(D2,Fs2,G2,B1,B2,B3,Cs3,E3,E1);
			else if (previous == Fs2)	generateNextInterval(D2,E2,G2,A2,D3);
			else if (previous == G2)	generateNextInterval(Fs2,A2,B1,D2,E2,B2,D3,E3,Fs3,A3,B3);
			else if (previous == A2)	generateNextInterval(G2,B2,E3,D2);
			else if (previous == B2)	generateNextInterval(A2,Cs3,Fs3,G2,E2,D2);
			else if (previous == Cs3)	generateNextInterval(Fs2,D3,B3,Cs4);
			else if (previous == D3)	generateNextInterval(Fs2,Fs3,A2,B2);
			else if (previous == E3)	generateNextInterval(E2,G3,Fs3,D3,B3,E4);
			else if (previous == Fs3)	generateNextInterval(D3,B2,A2,G3,A3,B3);
			else if (previous == G3)	generateNextInterval(B3,B2,Fs4,E4);
			else if (previous == A3)	generateNextInterval(D3,Fs3,G3,Fs4);
			else if (previous == B3)	generateNextInterval(A3,E2,G3);
			else if (previous == Cs4)	generateNextInterval(D4,G4,B4,Cs3);
			else if (previous == D4)	generateNextInterval(B3,Fs4);
			else if (previous == E4)	generateNextInterval(G4,Fs4,E3,E2,E1,B3);
			else if (previous == Fs4)	generateNextInterval(D4,G4);
			else if (previous == G4)	generateNextInterval(G3,A4,B3);
			else if (previous == A4)	generateNextInterval(A3,D4);
			else if (previous == B4)	generateNextInterval(E1,Fs2,Fs3);
								   else generateNextInterval(E1,E2,E3);
		}
		
		private static function inGMajor():void
		{			
				 if (previous == B1)	generateNextInterval(D2, D3, D4);
			else if (previous == D2)	generateNextInterval(Fs2, Fs3);
			else if (previous == E2)	generateNextInterval(G2, D3);
			else if (previous == Fs2)	generateNextInterval(G2, A2);
			else if (previous == G2)	generateNextInterval(D2, A2, B2);
			else if (previous == A2)	generateNextInterval(G2, Fs3, B2);
			else if (previous == B2)	generateNextInterval(Fs2, A2, D3, E3, Fs3);
			else if (previous == D3)	generateNextInterval(Fs2, Fs3);
			else if (previous == E3)	generateNextInterval(A2, D3, Fs3, B3);
			else if (previous == Fs3)	generateNextInterval(D3, G3, A3);
			else if (previous == G3)	generateNextInterval(B3, B2, B1);
			else if (previous == A3)	generateNextInterval(D3, G3, D4, Fs4);
			else if (previous == B3)	generateNextInterval(E2, G3, E3, E4);
			else if (previous == D4)	generateNextInterval(B3, Fs4);
			else if (previous == E4)	generateNextInterval(Fs4);
			else if (previous == Fs4)	generateNextInterval(D4, G4);
			else if (previous == G4)	generateNextInterval(G3, A4, B3);
			else if (previous == A4)	generateNextInterval(A3, D4);
								   else generateNextInterval(G2,G3);
		}
		
	}
	
}