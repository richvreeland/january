package january
{
	import flash.utils.getDefinitionByName;
	
	import january.snowflakes.*;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Snowflake extends FlxSprite
	{		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// MUSIC-RELATED DEFINITIONS ///////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
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
		protected static const notes:  Array = [C1,Cs1,D1,Ds1,E1,F1,Fs1,G1,Gs1,A1,As1,B1,C2,Cs2,D2,Ds2,E2,F2,Fs2,G2,Gs2,A2,As2,B2,C3,Cs3,D3,Ds3,E3,F3,Fs3,G3,Gs3,A3,As3,B3,C4,Cs4,D4,Ds4,E4,F4,Fs4,G4,Gs4,A4,As4,B4];
		/** Length property of the notes array, stored once for better performance. */
		protected static const notesLength: uint = notes.length;
		
		/** All of the scales/scales to be used with keys. */
		protected static const scales: Array = ["ionian", "dorian", "lydian", "mixolydian", "aeolian"];
		/** The name of the current mode/scale. */
		protected static var currentScale: String = "ionian";
		
		/** The various keys and their respective scales, stored in arrays. */
		protected static const eDorian: Array = ["eDorian",E1,Fs1,G1,A1,B1,Cs2,D2,E2,Fs2,G2,A2,B2,Cs3,D3,E3,Fs3,G3,A3,B3,Cs4,D4,E4,Fs4,G4,A4,B4];
		protected static const dMajor: Array = ["dMajor",B1,D2,E2,Fs2,G2,A2,B2,Cs3,D3,E3,Fs3,G3,A3,B3,Cs4,D4,E4,Fs4,G4,A4];
		
		//protected static const cDiatonic: Array = [ ["cDiatonic",C1,D1,E1,F1,G1,A1,B1], [C2,D2,E2,F2,G2,A2,B2], [C3,D3,E3,F3,G3,A3,B3], [C4] ];
		protected static const cDiatonic: Array = [ ["cDiatonic"], ["",C1,C2,C3,C4], ["",D1,D2,D3], ["",E1,E2,E3], ["",F1,F2,F3], ["",G1,G2,G3], ["",A1,A2,A3], ["",B1,B2,B3] ];
		
		/** All of the keys, stored in an array for easy access. */
		protected static const keys: Array = [cDiatonic];//[eDorian, dMajor];
		/** Length property of the keys array, stored once for better performance. */
		protected static const keysLength: uint = keys.length;
		/** The index position of a given key (used with keys) */
		protected static var keyIndex: int = 0;
		/** The name of the current key, stored as a string. */
		protected static var currentKey: String = "cDiatonic";
		
		/** The very first note that's triggered. */
		private static var initialNote: Class = cDiatonic[Helpers.randInt(1, 7)][Helpers.randInt(1, 2)] as Class; //dMajor[Helpers.randInt(1, dMajor.length/2)] as Class;
		
		/** The last Play Note played. */
		protected static var lastPlayNote: Class;
		
		/** Used to instantiate lastPlayNote, and push to the replaySequence. */
		protected var _replayNote: Class;
		
		/** Current replaySequence of notes being cycled through */
		public static var replaySequence: Array = [];
		
		/** Current position in replaySequence array */
		public static var replaySequenceIndex: int = 0;
		
		/** Whether replaySequence is being looped through */
		public static var replayMode: Boolean = false;
			
		/** Whether or not pedal point mode is on. */
		protected static var pedalPointMode: Boolean = false;
		
		/** Volume for the Note. */
		protected var _volume: Number;
		
		/** Pan Value for the Note, measured in -1 to 1. */
		protected var _pan: Number;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// NON-MUSIC DEFINITIONS ///////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** The point value of each snowflake */
		protected var _pointValue: int;
		
		/** The type of snowflake in question. */
		public var type: String;
		
		// List of classes for getDefinitionByName() to use
		Chord; Large; Octave; Small; Key; Harmony;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
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
			var weights		: Array = [ 75    ,  12.5  ,  5      ,  4.5     ,  2.5   ,  0.5 ];
			
			// Gradually introduce Harmony, Chord and Key flakes
			if (FlxG.score < 100)	weights[5] = 0;		
			if (FlxG.score < 50)	weights[4] = 0;				
			if (FlxG.score < 25)	weights[3] = 0;
			if (FlxG.score < 10)	weights[2] = 0;
			
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
			if (FlxG.score > 0)
				x = Helpers.randInt(PlayState.camera.scroll.x, PlayState.cameraRails.x + 160);
			else
				x = PlayState.camera.scroll.x + 160;
			
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

			var windX:int = 5 + (FlxG.score * 0.05);
			
			velocity.x = (Math.cos(y / windX) * windX);
			velocity.y = 5 + (Math.cos(y / 25) * 5) + 10;
			
			super.update();
			
			///////////////
			// COLLISION //
			///////////////
			
			if (y >= FlxG.height - 11 || x < PlayState.camera.scroll.x - width || x > FlxG.worldBounds.width || ( y > FlxG.height - 24 && (x + width <= PlayState.player.x || x >= PlayState.player.x + PlayState.player.width)) )
				kill();

		}
		
		/** Called when a Snowflake has been licked. */
		public function onLick():void
		{					
			super.kill();
			
			FlxG.score += _pointValue;			
			
			// Determine Key, and log it to the HUD
			currentKey = keys[keyIndex][0][0];
			PlayState.HUDkey.text = "Key: " + currentKey;
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
			// Convert x position to pan position.
			_pan = 2 * ((this.x - PlayState.camera.scroll.x) / FlxG.width) - 1;
			
			// Tell Large flakes ahead of time to toggle loop mode.
			if (type == "Large" && FlxG.score > 1)
			{
				if (replayMode == false && replaySequence.length > 0)
					replayMode = true;
				else
				{
					replayMode = false;
					replaySequence = [];
					replaySequenceIndex = 0;
				}
			}
			
			// if this is any licked Snowflake but the first one
			if (replayMode == true)
			{
				FlxG.play(replaySequence[replaySequenceIndex] as Class, _volume, _pan);	
				
				replaySequenceIndex++;
				if (replaySequenceIndex > replaySequence.length - 1)
					replaySequenceIndex = 0;
			}
			else if (lastPlayNote != null)
			{				
				var functionName:String = currentScale as String;
				var modeFunction:Function = this[functionName] as Function;
				modeFunction();
				
				// Call function for proper key to play note in				
//				var functionName:String = "in_" + currentKey as String;
//				var keyFunction:Function = this[functionName] as Function;
//				keyFunction();				
			}
			else // if this is any Snowflake before the first licked Snowflake.
			{
				FlxG.play(initialNote, _volume);
				lastPlayNote = initialNote;
			}
			
			// Store the last Play note as new object to prevent pushing a reference.
			_replayNote = lastPlayNote as Class;
			
			// Push the last Play note to the Replay replaySequence.
			if (type == "Small" || type == "Octave" || type == "Harmony")
			{
				if (replayMode == false)  // recording == true
					replaySequence.push(_replayNote as Class);
			}
			else if (type == "Large")
			{								
				// Large flake always gets pushed.
				if (replayMode == false && FlxG.score > 1)
					replaySequence.push(_replayNote as Class);
			}		
			
		}

		/**
		 * Play a note! Takes in class arguments, and will pick one randomly.
		 *  
		 * @param options
		 * 
		 */		
		final protected function _play(... options):void
		{				
			var lastNote: Class = lastNoteCheck();
			var random: int = Helpers.randInt(0, options.length - 1);
			var randomNote: Class = options[random] as Class;
			
			// Make Fourth Octave Range quieter, because it gets a bit shrill.
			for (var i:int = notesLength - 13; i < notesLength - 1; i++)
			{
				if (randomNote == notes[i])
					_volume = Helpers.rand(0.1, 0.25);
			}
			
			// Prevent new note from being the same as a replay note.
			while (lastNote == randomNote)
			{
				random = Helpers.randInt(0, options.length - 1);
				randomNote = options[random] as Class;
			}	
				
			FlxG.play(randomNote, _volume, _pan);
			
			// Only log note we just played if we're in play mode.
			if (replayMode == false)
				lastPlayNote = randomNote;
			
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
			replayMode = false;
			replaySequence = [];
			
			var chordTones: Array;
			var choice: int;
			
			/* Note: Chords that should only be triggered for Key flakes, should go above the type == "Key" conditional */
			
			if (currentKey == "eDorian")
			{
				// Pick a Chord Type to Generate
				choice = Helpers.randInt(1, 7);
				
					 if (choice == 1) 					chordTones = [E1, B1, G2];	//	I-
				else if (choice == 2 || type == "Key")	chordTones = [Fs2, G2, D3];	//	2 b3 b7
				else if (choice == 3) 					chordTones = [Cs2, E2, A2];	//  IV/3rd
				else if (choice == 4) 					chordTones = [A1, G2, Cs3];	//	IV7
				else if (choice == 5) 					chordTones = [Fs2, A2, D3];	//	VII/3rd
				else if (choice == 6) 					chordTones = [B1, Fs2, Cs3];	//	Vno5add9
				else if (choice == 7) 					chordTones = [Cs2, E2, E3];	//	IV/3rd
			}
			else if (currentKey == "dMajor")
			{
				// Pick a Chord Type to Generate
				choice = Helpers.randInt(1, 10);
					
					 if (choice == 1) 					chordTones = [D2, E2, Cs3];	//	I sus2 M7
				else if (choice == 2) 					chordTones = [E2, Fs2, A2];	//	I sus2
				else if (choice == 3) 					chordTones = [Fs2, A2, E3];	//	III-7
				else if (choice == 4) 					chordTones = [D2, Fs2, A2];	//	I
				else if (choice == 5 || type == "Key")	chordTones = [Fs2, A2, D3];	//	I/3rd
				else if (choice == 6)					chordTones = [B1, Fs2, B2]; //	VI 5
				else if (choice == 7)					chordTones = [B1, Fs2, Cs3];//	VI 5add9
				else if (choice == 8)					chordTones = [B2, D3, A3];	//	VI-7
				else if (choice == 9)					chordTones = [B2, Fs3, Cs4];//	VI 5add9
				else if (choice == 10) 					chordTones = [E2, G2, D3];	//	II-7
			}
		
			FlxG.play(chordTones[0], 0.15, 0);
			FlxG.play(chordTones[1], 0.15, 1);
			FlxG.play(chordTones[2], 0.15,-1);
			
			PlayState.HUDevent.text = "Chord: " + choice;
			PlayState.HUDkey.text = "Key: " + currentKey;
		}
		
		
		/**
		 * Generate an Octave! 
		 */		
		final protected function playOctave():void
		{		
			var octaveTone: Class;

			var note: Class = lastNoteCheck();
			
			for (var i:int = notesLength - 1; i > 0; --i)
			{								
				if (note == notes[i] && i < (notesLength - 12))
					octaveTone = notes[i+12] as Class;	
				else if (note == notes[i] && i >= (notesLength - 12))
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
		final protected function playHarmonyTone():void
		{									
			var harmonyTone: Class;	
			var currentScale:Array = keys[keyIndex] as Array;
			var scaleLength:int = currentScale.length;
			
			var lastNote: Class = lastNoteCheck();
			
			for (var i:int = scaleLength - 1; i > 1; --i)
			{	
				if (lastNote == currentScale[i])
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
		
		final protected function lastNoteCheck():Class
		{
			var lastAbsoluteNote: Class;
			
			if (replayMode == true)
			{
				var i: int;
				
				if (replaySequenceIndex == 0)
					i = replaySequence.length - 1;
				else
					i = replaySequenceIndex - 1;
				
				lastAbsoluteNote = replaySequence[i] as Class;
			}
			else
				lastAbsoluteNote = lastPlayNote;
			
			return lastAbsoluteNote;
		}
		
		/**
		 * Conditionals for generating notes in ionian. 
		 * 
		 */		
		final protected function ionian():void
		{									
			var scale:Array = keys[keyIndex];
			
				 if (lastPlayNote == scale[1][1]) 	_play(scale[2][1], scale[3][1], scale[4][1], scale[5][1], scale[2][2], scale[3][2], scale[4][2]);
			else if (lastPlayNote == scale[2][1])	_play(scale[3][1], scale[5][1], scale[7][1]);
			else if (lastPlayNote == scale[3][1])	_play(scale[2][1], scale[4][1], scale[5][1], scale[7][1], scale[1][1]);
			else if (lastPlayNote == scale[4][1])	_play(scale[3][1], scale[5][1]);
			else if (lastPlayNote == scale[5][1])	_play(scale[1][1], scale[3][1], scale[4][1], scale[6][1], scale[7][1], scale[1][2], scale[2][2]);
			else if (lastPlayNote == scale[6][1])	_play(scale[5][1], scale[7][1]);
			else if (lastPlayNote == scale[7][1])	_play(scale[5][1], scale[1][2]);
			else if (lastPlayNote == scale[1][2])	_play(scale[2][2], scale[3][2], scale[4][2], scale[5][2], scale[2][3], scale[3][3], scale[4][3], scale[7][2]);
			else if (lastPlayNote == scale[2][2])	_play(scale[1][2], scale[3][2], scale[5][2], scale[7][2]);
			else if (lastPlayNote == scale[3][2])	_play(scale[2][2], scale[4][2], scale[5][2], scale[7][2], scale[1][2]);
			else if (lastPlayNote == scale[4][2])	_play(scale[3][2], scale[5][2]);
			else if (lastPlayNote == scale[5][2])	_play(scale[1][2], scale[3][2], scale[4][2], scale[6][2], scale[7][2], scale[1][3], scale[2][3]);
			else if (lastPlayNote == scale[6][2])	_play(scale[5][2], scale[7][2]);
			else if (lastPlayNote == scale[7][2])	_play(scale[5][2], scale[1][3]);
			else if (lastPlayNote == scale[1][3])	_play(scale[2][3], scale[3][3], scale[4][3], scale[5][3], scale[3][2], scale[4][2], scale[7][2]);
			else if (lastPlayNote == scale[2][3])	_play(scale[1][3], scale[3][3], scale[5][3], scale[7][3]);
			else if (lastPlayNote == scale[3][3])	_play(scale[2][3], scale[4][3], scale[5][3], scale[7][3], scale[1][3]);
			else if (lastPlayNote == scale[4][3])	_play(scale[3][3], scale[5][3]);	
			else if (lastPlayNote == scale[5][3])	_play(scale[1][3], scale[3][3], scale[4][3], scale[6][3], scale[7][3], scale[1][4]);
			else if (lastPlayNote == scale[6][3])	_play(scale[5][3], scale[7][3]);
			else if (lastPlayNote == scale[7][3])	_play(scale[5][3], scale[1][4]);
			else if (lastPlayNote == scale[1][4])	_play(scale[3][3], scale[4][3], scale[5][3], scale[7][3], scale[1][3]);
				 
			else									_play(scale[1][2], scale[1][3]);
		}
		
		/**
		 * Conditionals for generating in the key of E Dorian. 
		 * 
		 */		
		final protected function in_eDorian():void
		{						
				 if (lastPlayNote == E1) 	_play(Fs1,G1,B1,B2,Cs2,E2);
			else if (lastPlayNote == Fs1)	_play(E1,Fs2,Fs3,G1,D2,E2);
			else if (lastPlayNote == G1)	_play(E1,A1,B1,D2,Fs2,G2,G3);
			else if (lastPlayNote == A1)	_play(Cs2,E2,A2,B2);
			else if (lastPlayNote == B1)	_play(A1,Cs2,D2,Fs2,B2);
			else if (lastPlayNote == Cs2)	_play(D2,B2,Cs3);
			else if (lastPlayNote == D2)	_play(Cs2,E2,Fs2);
			else if (lastPlayNote == E2) 	_play(D2,Fs2,G2,B1,B2,B3,Cs3,E3,E1);
			else if (lastPlayNote == Fs2)	_play(D2,E2,G2,A2,D3);
			else if (lastPlayNote == G2)	_play(Fs2,A2,B1,D2,E2,B2,D3,E3,Fs3,A3,B3);
			else if (lastPlayNote == A2)	_play(G2,B2,E3,D2);
			else if (lastPlayNote == B2)	_play(A2,Cs3,Fs3,G2,E2,D2);
			else if (lastPlayNote == Cs3)	_play(D3,B3,Cs4);
			else if (lastPlayNote == D3)	_play(Fs2,Fs3,A2,B2);
			else if (lastPlayNote == E3)	_play(E2,G3,Fs3,D3,B3,E4);
			else if (lastPlayNote == Fs3)	_play(D3,B2,A2,G3,A3,B3);
			else if (lastPlayNote == G3)	_play(B3,B2,Fs4,E4);
			else if (lastPlayNote == A3)	_play(D3,Fs3,G3,Fs4);
			else if (lastPlayNote == B3)	_play(A3,E2,G3);
			else if (lastPlayNote == Cs4)	_play(D4,G4,B4,Cs3);
			else if (lastPlayNote == D4)	_play(B3,Fs4);
			else if (lastPlayNote == E4)	_play(G4,Fs4,E3,E2,E1,B3);
			else if (lastPlayNote == Fs4)	_play(B3,D4,A4);
			else if (lastPlayNote == G4)	_play(G3,A4,B3);
			else if (lastPlayNote == A4)	_play(A3,D4);
			else if (lastPlayNote == B4)	_play(E1,Fs2,Fs3);
								   else _play(E1,E2,E3);
		}
		
		/**
		 * Conditionals for generating in the key of D Major. 
		 * 
		 */	
		final protected function in_dMajor():void
		{			
				 if (lastPlayNote == B1)	_play(Fs2, B2, D3);
			else if (lastPlayNote == D2)	_play(B1, G2, D3, Fs2, Fs3);
			else if (lastPlayNote == E2)	_play(G2, E3, D3);
			else if (lastPlayNote == Fs2)	_play(B1, E2, G2, Fs3, A2, D2);
			else if (lastPlayNote == G2)	_play(Fs2, E2, A2, E3, G3, B3);
			else if (lastPlayNote == A2)	_play(G2, Fs2, D2, B2, D3, Fs3, A3);
			else if (lastPlayNote == B2)	_play(B1, G2, A2, D3, Fs3, G3, B3);
			else if (lastPlayNote == Cs3)	_play(D3, B2, A2);
			else if (lastPlayNote == D3)	_play(B1, G2, A2, B2, Fs3, G3, A3, B3, Cs3);
			else if (lastPlayNote == E3)	_play(G2, A2, D3, Fs3, E4);
			else if (lastPlayNote == Fs3)	_play(E3, G3, A2, D3, Fs2, Cs3);
			else if (lastPlayNote == G3)	_play(Fs3, E3, B2, A3, B3, D2, E2);
			else if (lastPlayNote == A3)	_play(Cs3, G3, Fs3, D3, B3, D4, Fs4, A4);
			else if (lastPlayNote == B3)	_play(G3, A3, D4, Fs3, Fs4, B2, E3);
			else if (lastPlayNote == Cs4)	_play(D4, B3, A3);
			else if (lastPlayNote == D4)	_play(G3, B3, E4, Fs4, G4, Fs3, D3, Cs4);
			else if (lastPlayNote == E4)	_play(G3, D4, Fs4, E3);
			else if (lastPlayNote == Fs4)	_play(E4, G4, A3, D4, Fs3, Cs4);
			else if (lastPlayNote == G4)	_play(G3, Fs4, A4, B3);
			else if (lastPlayNote == A4)	_play(Cs4, B3, D4, Fs4, A3);
								   else _play(G2,G3);
			
//				 if (lastPlayNote == B1)	_play(D2, D3, D4);
//			else if (lastPlayNote == D2)	_play(Fs2, Fs3);
//			else if (lastPlayNote == E2)	_play(G2, D3);
//			else if (lastPlayNote == Fs2)	_play(G2, A2);
//			else if (lastPlayNote == G2)	_play(D2, A2, B2);
//			else if (lastPlayNote == A2)	_play(G2, Fs3, B2);
//			else if (lastPlayNote == B2)	_play(Fs2, A2, D3, E3, Fs3);
//			else if (lastPlayNote == D3)	_play(Fs2, Fs3);
//			else if (lastPlayNote == E3)	_play(A2, D3, Fs3, B3);
//			else if (lastPlayNote == Fs3)	_play(D3, G3, A3);
//			else if (lastPlayNote == G3)	_play(B3, B2, B1);
//			else if (lastPlayNote == A3)	_play(D3, G3, D4, Fs4);
//			else if (lastPlayNote == B3)	_play(E2, G3, E3, E4);
//			else if (lastPlayNote == D4)	_play(B3, Fs4);
//			else if (lastPlayNote == E4)	_play(Fs4);
//			else if (lastPlayNote == Fs4)	_play(D4, G4);
//			else if (lastPlayNote == G4)	_play(G3, A4, B3);
//			else if (lastPlayNote == A4)	_play(A3, D4);
//								   else _play(G2,G3);
		}
	}
}