package january
{
	import flash.utils.*;
	
	import january.snowflakes.*;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Snowflake extends FlxSprite
	{		
		///////////////////////////////
		// MUSIC-RELATED DEFINITIONS //
		///////////////////////////////
		
		// Import Notes	
		[Embed(source="../assets/audio/notes/C1.mp3")]	protected static var C1:Class;
		[Embed(source="../assets/audio/notes/C#1.mp3")]	protected static var Cs1:Class;
		[Embed(source="../assets/audio/notes/D2.mp3")]	protected static var D1:Class;
		[Embed(source="../assets/audio/notes/D#1.mp3")]	protected static var Ds1:Class;
		[Embed(source="../assets/audio/notes/E2.mp3")]	protected static var E1:Class;
		[Embed(source="../assets/audio/notes/F1.mp3")]	protected static var F1:Class;
		[Embed(source="../assets/audio/notes/F#1.mp3")]	protected static var Fs1:Class;
		[Embed(source="../assets/audio/notes/G2.mp3")]	protected static var G1:Class;
		[Embed(source="../assets/audio/notes/G#1.mp3")]	protected static var Gs1:Class;
		[Embed(source="../assets/audio/notes/A2.mp3")]	protected static var A1:Class;
		[Embed(source="../assets/audio/notes/A#1.mp3")]	protected static var As1:Class;
		[Embed(source="../assets/audio/notes/B1.mp3")]	protected static var B1:Class;
		[Embed(source="../assets/audio/notes/C2.mp3")]	protected static var C2:Class;
		[Embed(source="../assets/audio/notes/C#2.mp3")]	protected static var Cs2:Class;
		[Embed(source="../assets/audio/notes/D2.mp3")]	protected static var D2:Class;
		[Embed(source="../assets/audio/notes/D#2.mp3")]	protected static var Ds2:Class;
		[Embed(source="../assets/audio/notes/E2.mp3")]	protected static var E2:Class;
		[Embed(source="../assets/audio/notes/F2.mp3")]	protected static var F2:Class;
		[Embed(source="../assets/audio/notes/F#2.mp3")]	protected static var Fs2:Class;
		[Embed(source="../assets/audio/notes/G2.mp3")]	protected static var G2:Class;
		[Embed(source="../assets/audio/notes/G#2.mp3")]	protected static var Gs2:Class;
		[Embed(source="../assets/audio/notes/A2.mp3")]	protected static var A2:Class;
		[Embed(source="../assets/audio/notes/A#2.mp3")]	protected static var As2:Class;
		[Embed(source="../assets/audio/notes/B2.mp3")]	protected static var B2:Class;
		[Embed(source="../assets/audio/notes/C3.mp3")]	protected static var C3:Class;
		[Embed(source="../assets/audio/notes/C#3.mp3")]	protected static var Cs3:Class;
		[Embed(source="../assets/audio/notes/D3.mp3")]	protected static var D3:Class;
		[Embed(source="../assets/audio/notes/D#3.mp3")]	protected static var Ds3:Class;
		[Embed(source="../assets/audio/notes/E3.mp3")]	protected static var E3:Class;
		[Embed(source="../assets/audio/notes/F3.mp3")]	protected static var F3:Class;
		[Embed(source="../assets/audio/notes/F#3.mp3")]	protected static var Fs3:Class;
		[Embed(source="../assets/audio/notes/G3.mp3")]	protected static var G3:Class;
		[Embed(source="../assets/audio/notes/G#3.mp3")]	protected static var Gs3:Class;
		[Embed(source="../assets/audio/notes/A3.mp3")]	protected static var A3:Class;
		[Embed(source="../assets/audio/notes/A#3.mp3")]	protected static var As3:Class;
		[Embed(source="../assets/audio/notes/B3.mp3")]	protected static var B3:Class;
		[Embed(source="../assets/audio/notes/C4.mp3")]	protected static var C4:Class;
		[Embed(source="../assets/audio/notes/C#4.mp3")]	protected static var Cs4:Class;
		[Embed(source="../assets/audio/notes/D4.mp3")]	protected static var D4:Class;
		[Embed(source="../assets/audio/notes/D#4.mp3")]	protected static var Ds4:Class;
		[Embed(source="../assets/audio/notes/E4.mp3")]	protected static var E4:Class;
		[Embed(source="../assets/audio/notes/F4.mp3")]	protected static var F4:Class;
		[Embed(source="../assets/audio/notes/F#4.mp3")]	protected static var Fs4:Class;
		[Embed(source="../assets/audio/notes/G4.mp3")]	protected static var G4:Class;
		[Embed(source="../assets/audio/notes/G#4.mp3")]	protected static var Gs4:Class;
		[Embed(source="../assets/audio/notes/A4.mp3")]	protected static var A4:Class;
		[Embed(source="../assets/audio/notes/A#4.mp3")]	protected static var As4:Class;
		[Embed(source="../assets/audio/notes/B4.mp3")]	protected static var B4:Class;	
		
		/** An Array of all of the Note sounds. */
		protected static var notes:  Array = [C1,Cs1,D1,Ds1,E1,F1,Fs1,G1,Gs1,A1,As1,B1,C2,Cs2,D2,Ds2,E2,F2,Fs2,G2,Gs2,A2,As2,B2,C3,Cs3,D3,Ds3,E3,F3,Fs3,G3,Gs3,A3,As3,B3,C4,Cs4,D4,Ds4,E4,F4,Fs4,G4,Gs4,A4,As4,B4];
		/** Length property of the notes array, stored once for better performance. */
		protected static var notesLength: uint = notes.length;
		
		/** The various keys and their respective scales, stored in arrays. */
		protected static var eMinor: Array = ["eMinor",E1,Fs1,G1,A1,B1,Cs2,D2,E2,Fs2,G2,A2,B2,Cs3,D3,E3,Fs3,G3,A3,B3,Cs4,D4,E4,Fs4,G4,A4,B4];
		protected static var gMajor: Array = ["gMajor",B1,D2,E2,Fs2,G2,A2,B2,D3,E3,Fs3,G3,A3,B3,D4,E4,Fs4,G4,A4];
		/** All of the keys, stored in an array for easy access. */
		protected static var keys: Array = [eMinor, gMajor];
		/** Length property of the keys array, stored once for better performance. */
		protected static var keysLength: uint = keys.length;
		/** The index position of a given key (used with keys) */
		protected static var keyIndex: int;
		/** The name of the current key, stored as a string. */
		protected static var currentKey: String;
		
		/** The previous Note generated. */
		protected static var _previous: Class;
		
		/** Volume for the Note. */
		protected var _volume: Number;
		
		/** Pan Value for the Note, measured in -1 to 1. */
		protected var _pan: Number;
		
		/** Whether or not pedal point mode is on. */
		protected static var pedalPointMode: Boolean = false;
		/** Whether or not incidental mode is on. Incidental mode toggles whether incidental flakes generate notes. */
		protected static var incidentalMode: Boolean = false;
		
		/** The very first note that's triggered. */
		private static var _initial: Class = gMajor[Helpers.randInt(0, gMajor.length / 2)] as Class;
		
		///////////////////////////
		// NON-MUSIC DEFINITIONS //
		///////////////////////////
		
		/** The type of snowflake in question. */
		public var type: String;

		/** The point value of each snowflake */
		protected var _pointValue: int;
		
		/** Wind modifier for x position. */
		protected static var windX : Number = 0;
		/** Wind modifier for y position. */
		protected static var windY : Number = 0;
		
		// List of classes for getDefinitionByName() to use
		Chord; Large; Octave; Small; Pedal; Incidental; Key; Harmony;
		
		/**
		 * Snowflake Constructor! 
		 * 
		 */		
		public function Snowflake():void
		{	
			super(x, y);
			
			exists = false;
		}
		
		/** Determines which snowflakes to spawn.  */
		public static function manage() : void
		{				
			// Snowflake spawning probabilities
			var flakes		: Array = ["Small", "Large", "Octave", "Harmony", "Chord", "Key"];
			var weights		: Array = [ 75    ,  15    ,  4      ,  4       ,  1.5   ,  0.5 ];
			
			// All Flakes are Spawned based on weighted probability, except for the first one.
			var flakeID: String;
			if (FlxG.score > 0)
				flakeID = flakes[Helpers.weightedChoice(weights)];
			else
				flakeID = "Large";
			
			// use string above to instantiate proper Snowflake Subclass.
			var subClass : Class = getDefinitionByName( "january.snowflakes." + flakeID ) as Class;	
			var flake : Object = PlayState.snow.recycle(subClass) as subClass;
			flake.spawn(flakeID);
			
		}
		
		/** Spawns snowflakes. */
		protected function spawn(flakeType: String):void
		{						
			var screenMidpoint:Number = PlayState.camera.scroll.x + (FlxG.width/2);
			
			if (FlxG.score > 0)
				x = Helpers.randInt(PlayState.camera.scroll.x, PlayState.cameraRails.x + FlxG.width);
			else
				x = screenMidpoint;
			
			if (x < PlayState.camera.scroll.x || x > FlxG.worldBounds.width)
				kill();

				y = 0;
			
			// Set type to Snowflake Subclass name ie. "Small"
			type = flakeType;
			exists = true;
		}
		
		override public function update():void
		{			
			//////////////
			// MOVEMENT //
			//////////////			
			
			velocity.y = 10;// + windY;
			velocity.x = (Math.cos(y / 5) * 5);// + windX;
			
			super.update();
			
			///////////////
			// COLLISION //
			///////////////
			
			if (y > FlxG.height - 10 || x < PlayState.camera.scroll.x - width)
				kill();

		}
		
		/** Called when a Snowflake has been licked. */
		public function onLick():void
		{					
			FlxG.score += _pointValue;
			
			if (Text.storyOver == true)
				incidentalMode == true;
			
			super.kill();
		}
		
		/** When snowflakes hit the player but he doesn't lick them. */
		public function onIncidental():void
		{
			_volume = Helpers.rand(0.025, 0.075);
			
			// Prevent an incidental collision from generating a pedal tone.
			var switched:Boolean;
			if (pedalPointMode == true)
			{
				pedalPointMode = false;
				switched = true;
			}
			
			if (FlxG.score > 0 && incidentalMode == true)
				playNote();
			
			// Return pedal point mode to it's original state, if we switched it.
			if (switched == true)
				pedalPointMode = true;
			
			super.kill();
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////
		// MUSIC FUNCTIONS //////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Initializes, determines key and plays the note!
		 * 
		 */		
		final protected function playNote():void
		{						
			// if this is any licked Snowflake but the first one
			if (_previous != null)
			{
				// Convert x position to pan position.
				_pan = 2 * ((this.x - PlayState.camera.scroll.x) / FlxG.width) - 1;
				
				// Determine Key, and by proxy play the note.
				determineKey();
				
				if (pedalPointMode == true)
					playPedalTone();
				
			}
			else // if this is any Snowflake before the first licked Snowflake.
			{
				FlxG.play(_initial, _volume);
				_previous = _initial;
				
				keyIndex = 1;
			}
			
		}
		
		/**
		 * Determines which key to generate notes in, and then uses that information to call the appropriate method.
		 * 
		 * @param KeyIndex
		 * 
		 */		
		final protected function determineKey():void
		{			
			currentKey = keys[keyIndex][0];
			// Set function name and call it, ie. inGMajor()
			var functionName:String = "in_" + currentKey as String;
			var keyFunction:Function = this[functionName] as Function;
			keyFunction();
			
			// Log Current Key to HUD 
			PlayState.HUDkey.text = "Key: " + functionName;
		}
		
		/**
		 * Play a note! Takes in class arguments, and will pick one randomly.
		 *  
		 * @param options
		 * 
		 */		
		final protected function _play(... options):void
		{			
			
			var random: int = Helpers.randInt(0, options.length - 1);
			var randomNote: Class = options[random] as Class;
			
			if (_volume == 0)
				_volume = Helpers.rand(0.1, 0.4);			
			
			FlxG.play(randomNote, _volume, _pan);
			
			_previous = randomNote;
			
			// Log note name, volume and pan to HUD
			var actualName: String = String(randomNote);
			actualName = actualName.slice(17);
			actualName = actualName.slice(0,-1);
			actualName = actualName.replace(/s/,"#");
			PlayState.HUDnote.text = "Note: " + actualName + ", " + int(_volume*100)/100 + ", " + int(_pan*100)/100;
		}
		
		
		/**
		 * Generate a chord!
		 *  
		 * @param isKeyFlake
		 * 
		 */		
		final protected function playChord():void
		{			
			var chordTone1: Class;
			var chordTone2: Class;
			var chordTone3: Class;
			var chordChoice: String;
			
			if (currentKey == "eMinor")
			{
				// Pick a Chord Type to Generate
				chordChoice = Helpers.pickFrom("i","v");
				
				if (chordChoice == "i" || type == "Key")
				{
					chordTone1 = Helpers.pickFrom(E1,E3);
					chordTone2 = Helpers.pickFrom(G2,E2);
					chordTone3 = Helpers.pickFrom(B1,Cs2);
				}
				else if (chordChoice == "v")
				{
					chordTone1 = Helpers.pickFrom(B1,B2);
					chordTone2 = Helpers.pickFrom(D3,Cs3);
					chordTone3 = Helpers.pickFrom(Fs2,Fs3);
				}
			}
			else if (currentKey == "gMajor")
			{
				// Pick a Chord Type to Generate
				chordChoice = Helpers.pickFrom("I","iii");
				
				if (chordChoice == "I" || type == "Key")
				{
					chordTone1 = Helpers.pickFrom(G1,G2);
					chordTone2 = Helpers.pickFrom(G2,B2);
					chordTone3 = Helpers.pickFrom(D2,E2);
				}
				else if (chordChoice == "iii")
				{
					chordTone1 = Helpers.pickFrom(B1,B2);
					chordTone2 = Helpers.pickFrom(D3,D2);
					chordTone3 = Helpers.pickFrom(Fs2,Fs3);
				}
			}
			
			FlxG.play(chordTone1, 0.15, 0);
			FlxG.play(chordTone2, 0.15, 1);
			FlxG.play(chordTone3, 0.15,-1);
			
			PlayState.HUDevent.text = "Chord: " + chordChoice;
		}
		
		
		/**
		 * Generate an Octave! 
		 */		
		final protected function playOctave():void
		{		
			var octaveTone: Class;
			
			for (var i:int = notesLength - 1; i > 0; --i)
			{								
				if (_previous == notes[i] && i < (notesLength - 12))
					octaveTone = notes[i+12] as Class;	
				else if (_previous == notes[i] && i >= (notesLength - 12))
					octaveTone = notes[i-12] as Class;
			}
			
			if (octaveTone != null)
				FlxG.play(octaveTone, 0.1, _pan);
			else
				FlxG.log("Null Octave Tone!");
		}
		
		/**
		 * Generate a Harmony Tone! 
		 */		
		final protected function playHarmonyNote():void
		{						
			var harmonyTone: Class;	
			var currentScale:Array = keys[keyIndex] as Array;
			var scaleLength:int = currentScale.length;
			
			for (var i:int = scaleLength - 1; i > 1; --i)
			{								
				if (_previous == currentScale[i])
				{
					if (i >= scaleLength - 2)
						harmonyTone = currentScale[i-2] as Class;	
					else if (i <= 2)
						harmonyTone = currentScale[i+2] as Class;
					else
						harmonyTone = currentScale[i + Helpers.pickFrom(-2, 2)] as Class;
				}
			}
			
			if (harmonyTone != null)
				FlxG.play(harmonyTone, 0.1, _pan);
			else
				FlxG.log("Null Harmony Tone!");
		}
		
		/**
		 * Plays a pedal tone! 
		 */		
		final protected function playPedalTone():void
		{			
			var pedalTone: Class;
			
			if (keyIndex == 0) 		// E Minor
				pedalTone = Helpers.pickFrom(E1,E2);
			else if (keyIndex == 1) 	// G Major
				pedalTone = Helpers.pickFrom(G1,G2);
			
			FlxG.play(pedalTone, Helpers.rand(0.05, 0.15), Helpers.rand(-1, 1));
		}
		
		/**
		 * Conditionals for generating in the key of E Minor. 
		 * 
		 */		
		final protected function in_eMinor():void
		{						
				 if (_previous == E1) 	_play(Fs1,G1,B1,B2,Cs2,E2);
			else if (_previous == Fs1)	_play(E1,Fs2,Fs3,G1,D2,E2);
			else if (_previous == G1)	_play(E1,A1,B1,D2,Fs2,G2,G3);
			else if (_previous == A1)	_play(Cs2,E2,A2,B2);
			else if (_previous == B1)	_play(A1,Cs2,D2,Fs2,B2);
			else if (_previous == Cs2)	_play(D2,B2,Cs3);
			else if (_previous == D2)	_play(Cs2,E2,Fs2);
			else if (_previous == E2) 	_play(D2,Fs2,G2,B1,B2,B3,Cs3,E3,E1);
			else if (_previous == Fs2)	_play(D2,E2,G2,A2,D3);
			else if (_previous == G2)	_play(Fs2,A2,B1,D2,E2,B2,D3,E3,Fs3,A3,B3);
			else if (_previous == A2)	_play(G2,B2,E3,D2);
			else if (_previous == B2)	_play(A2,Cs3,Fs3,G2,E2,D2);
			else if (_previous == Cs3)	_play(D3,B3,Cs4);
			else if (_previous == D3)	_play(Fs2,Fs3,A2,B2);
			else if (_previous == E3)	_play(E2,G3,Fs3,D3,B3,E4);
			else if (_previous == Fs3)	_play(D3,B2,A2,G3,A3,B3);
			else if (_previous == G3)	_play(B3,B2,Fs4,E4);
			else if (_previous == A3)	_play(D3,Fs3,G3,Fs4);
			else if (_previous == B3)	_play(A3,E2,G3);
			else if (_previous == Cs4)	_play(D4,G4,B4,Cs3);
			else if (_previous == D4)	_play(B3,Fs4);
			else if (_previous == E4)	_play(G4,Fs4,E3,E2,E1,B3);
			else if (_previous == Fs4)	_play(B3,D4,A4);
			else if (_previous == G4)	_play(G3,A4,B3);
			else if (_previous == A4)	_play(A3,D4);
			else if (_previous == B4)	_play(E1,Fs2,Fs3);
								   else _play(E1,E2,E3);
		}
		
		/**
		 * Conditionals for generating in the key of G Major. 
		 * 
		 */	
		final protected function in_gMajor():void
		{			
				 if (_previous == B1)	_play(D2, D3, D4);
			else if (_previous == D2)	_play(Fs2, Fs3);
			else if (_previous == E2)	_play(G2, D3);
			else if (_previous == Fs2)	_play(G2, A2);
			else if (_previous == G2)	_play(D2, A2, B2);
			else if (_previous == A2)	_play(G2, Fs3, B2);
			else if (_previous == B2)	_play(Fs2, A2, D3, E3, Fs3);
			else if (_previous == D3)	_play(Fs2, Fs3);
			else if (_previous == E3)	_play(A2, D3, Fs3, B3);
			else if (_previous == Fs3)	_play(D3, G3, A3);
			else if (_previous == G3)	_play(B3, B2, B1);
			else if (_previous == A3)	_play(D3, G3, D4, Fs4);
			else if (_previous == B3)	_play(E2, G3, E3, E4);
			else if (_previous == D4)	_play(B3, Fs4);
			else if (_previous == E4)	_play(Fs4);
			else if (_previous == Fs4)	_play(D4, G4);
			else if (_previous == G4)	_play(G3, A4, B3);
			else if (_previous == A4)	_play(A3, D4);
								   else _play(G2,G3);
		}
	}
}