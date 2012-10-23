package january
{
	import flash.utils.Dictionary;
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
		[Embed(source="../assets/audio/notes/D1.mp3")]	protected static var D1:Class;
		[Embed(source="../assets/audio/notes/D#1.mp3")]	protected static var Ds1:Class;
		[Embed(source="../assets/audio/notes/E1.mp3")]	protected static var E1:Class;
		[Embed(source="../assets/audio/notes/F1.mp3")]	protected static var F1:Class;
		[Embed(source="../assets/audio/notes/F#1.mp3")]	protected static var Fs1:Class;
		[Embed(source="../assets/audio/notes/G1.mp3")]	protected static var G1:Class;
		[Embed(source="../assets/audio/notes/G#1.mp3")]	protected static var Gs1:Class;
		[Embed(source="../assets/audio/notes/A1.mp3")]	protected static var A1:Class;
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
		
		// Keys. MUST ALL BE THE SAME LENGTH.
		protected static const	cMajor	: Array = ["cMajor",C1,D1,E1,F1,G1,A1,B1,C2,D2,E2,F2,G2,A2,B2,C3,D3,E3,F3,G3,A3,B3,C4,D4,E4,F4,G4,A4,B4];
		protected static const	eMajor	: Array = ["eMajor",E1,Fs1,Gs1,A1,B1,Cs2,Ds2,E2,Fs2,Gs2,A2,B2,Cs3,Ds3,E3,Fs3,Gs3,A3,B3,Cs4,Ds4,E4];
		protected static const	bbMajor	: Array = ["bbMajor",As1,C2,D2,Ds2,F2,G2,A2,As2,C3,D3,Ds3,F3,G3,A3,As3,C4,D4,Ds4,F4,G4,A4,As4];
		protected static const	bMajor	: Array = ["bMajor",B1,Cs2,Ds2,E2,Fs2,Gs2,As2,B2,Cs3,Ds3,E3,Fs3,Gs3,As3,B3,Cs4,Ds4,E4,Fs4,Gs4,As4,B4];
		
		protected static const	keys		: Array = [cMajor, eMajor, bbMajor, bMajor];
		protected static var	keyIndex	: int = 0;	//Helpers.randInt(0, keys.length - 1)
		protected static var	currentKey	: String = keys[keyIndex][0];
		
		/** All of the modes to be used with keys. Modes work within two octaves. */
		protected static const	ionian		: Object = {name: "ionian", 	offset:  1};
		protected static const	dorian		: Object = {name: "dorian", 	offset:  2};
		protected static const	lydian		: Object = {name: "lydian", 	offset:  4};
		protected static const	mixolydian	: Object = {name: "mixolydian", offset:  5};
		protected static const	aeolian		: Object = {name: "aeolian", 	offset:  6};
		
		protected static const	modes			: Array = [ionian, dorian, lydian, mixolydian, aeolian];
		protected static var	modeIndex		: int = modes[Helpers.randInt(0, modes.length - 1)];
		protected static var	currentMode		: String = modes[modeIndex].name;
		protected static var	previousMode	: String = currentMode;
		
		// INTERVAL OBJECT, FOR EASE OF USE
		protected static var	intervals		: Object = {currentKey: "", currentMode: ""};
		protected static const	intervalNames	: Array = ["one1", "two1", "thr1", "for1", "fiv1", "six1", "sev1", "one2", "two2", "thr2", "for2", "fiv2", "six2", "sev2", "one3", "two3", "thr3", "for3", "fiv3", "six3", "sev3", "one4"];
		
		/** The very first note that's triggered. */
		private static const initialNote: Class = keys[keyIndex][Helpers.randInt(1, keys[keyIndex].length/2)] as Class;	
		/** The last Play Note played. */
		protected static var lastPlayNote: Class;		
		/** The second to last Play Note played. */
		protected static var secondToLastPlayNote: Class;	
		/** The last Note played, regardless of whether in Play/Replay Mode **/
		protected static var lastAbsoluteNote: Class;
		/** The last Octave Note played. */
		protected static var lastOctaveTone: Class;
		/** The last Harmony Note played. */
		protected static var lastHarmonyTone: Class;
		
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
		
		/** Vertical modifier for snowflake movement. */
		protected var _windY: int;
		
		/** Type of the last licked snowflake. */
		protected static var lastLickedType: String;
		
		// Snowflake spawning probabilities
		public static var flakes	: Array = ["Small", "Large", "Octave", "Harmony", "Chord", "Key"];
		public static var weights	: Array = [ 80    ,  10    ];
		
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

			var windX:int = 5 + (FlxG.score * 0.025);
			if (windX >= 10) windX = 10;
			
			velocity.x = (Math.cos(y / windX) * windX);
			velocity.y = 5 + (Math.cos(y / 25) * 5) + _windY;
			
			super.update();
			
			///////////////
			// COLLISION //
			///////////////
			
			if ( ( y > FlxG.height - 24 && (x + width <= PlayState.player.x || x >= PlayState.player.x + PlayState.player.width)) && x < PlayState.houseRight.x)
				kill();
			else if (y >= FlxG.height - 11 || x < PlayState.camera.scroll.x - width || x > FlxG.worldBounds.width)
				kill();

		}
		
		/** Called when a Snowflake has been licked. */
		public function onLick():void
		{					
			super.kill();
			
			FlxG.score += _pointValue;
			
			// Gradually introduce Harmony, Chord and Key flakes
			if (FlxG.score == 2)	weights[4] = 3;
			if (FlxG.score == 2)	weights[3] = 3;
			if (FlxG.score == 2)	weights[2] = 3;
//			if (FlxG.score == 100)	weights[5] = 0.5;	// Key	
//			if (FlxG.score == 50)	weights[4] = 2.5;	// Chord	
//			if (FlxG.score == 25)	weights[3] = 4.5;	// Harmony
//			if (FlxG.score == 10)	weights[2] = 5;		// Octave
			
			// Increase Flake Probability if Player Keeps Licking. Excludes Small and Large
			for (var i:int = 2; i <= weights.length - 1; i++)
			{
				if (type == flakes[i])
				{
					weights[i] += 0.25;
					weights[0] -= 0.25;	
				}
				
				// Limit Probability to 12.5%
				if (weights[i] >= 12.5)
					weights[i] = 12.5;
			}
			
			lastLickedType = type;
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
			calculatePan();
			
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
			
			if (replayMode == true)	// REPLAY MODE
			{
				FlxG.play(replaySequence[replaySequenceIndex] as Class, _volume, _pan);				
				
				lastAbsoluteNote = replaySequence[replaySequenceIndex];
				
				replaySequenceIndex++;
				if (replaySequenceIndex > replaySequence.length - 1)
					replaySequenceIndex = 0;
			}
			else if (lastPlayNote != null)	// PLAY MODE
			{				
				populateIntervals();
				
				var modeFunction:Function = this[currentMode] as Function;
				modeFunction();
			
			}
			else // INITIAL SNOWFLAKE
			{
				FlxG.play(initialNote, _volume);
				lastPlayNote = initialNote;
				lastAbsoluteNote = lastPlayNote;
				logNotetoHUD();
				PlayState.HUDevent.text = "Event: " + currentMode;
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
			var random: int = Helpers.randInt(0, options.length - 1);
			var randomNote: Class = options[random] as Class;
			
			// Make Fourth Octave Range quieter, because it gets a bit shrill.
			for (var i:int = notesLength - 13; i < notesLength - 1; i++)
			{
				if (randomNote == notes[i])
					_volume = Helpers.rand(0.05, 0.15);
			}
			
			// Prevent various types of repetitions from happening.
			while (lastAbsoluteNote == randomNote || secondToLastPlayNote == randomNote || (lastLickedType == "Harmony" && lastHarmonyTone == randomNote) || (lastLickedType == "Octave" && lastOctaveTone == randomNote))
			{
				random = Helpers.randInt(0, options.length - 1);
				randomNote = options[random] as Class;
			}
				
			FlxG.play(randomNote, _volume, _pan);
			
			// Only log note we just played if we're in play mode.
			if (replayMode == false)
			{
				// Log second to Last Play Note, used above, to prevent trills.
				secondToLastPlayNote = lastPlayNote;
				// Log Last Play Note, used for generative logic.
				lastPlayNote = randomNote;
				// Set Last Play Note as the Last Absolute Note, because it is.
				lastAbsoluteNote = lastPlayNote;
			}
			
			logNotetoHUD();
		}
				
		final protected function playChord():void
		{					
			replayMode = false;
			replaySequence = [];
			
			var chordTones: Array;
			var choice: int;
			
			populateIntervals();
			var i:Object = intervals;
			
			/* Note: Chords that should only be triggered for Key flakes, should go above the type == "Key" conditional */
			
			if (currentMode == "ionian")
			{
				chordTones = Helpers.pickFrom(
					// UNIVERSAL CHORDS /////
					[i.one1, i.thr1, i.fiv1],
					[i.one1, i.thr1, i.sev1],
					[i.one1, i.fiv1, i.one2],
					[i.one1, i.fiv1, i.thr2],
					[i.one1, i.fiv1, i.thr2, i.sev2],
					[i.one1, i.fiv1, i.fiv2],
					[i.one1, i.thr2, i.sev2],
					[i.thr1, i.one2, i.fiv2],
					[i.thr1, i.fiv1, i.one2],
					[i.fiv1, i.one2, i.thr2],
					[i.sev1, i.one2, i.thr2, i.fiv2],
//					[i.one2, i.fiv2, i.thr3],
//					[i.thr2, i.fiv2, i.one3],
//					[i.fiv2, i.one3, i.thr3],
					/////////////////////////
					[i.one2, i.two2, i.sev2],
					[i.one1, i.two2, i.sev2]
				);
			}
			else if (currentMode == "dorian")
			{
				chordTones = Helpers.pickFrom(
					// UNIVERSAL CHORDS /////
					[i.one1, i.thr1, i.fiv1],
					[i.one1, i.thr1, i.sev1],
					[i.one1, i.fiv1, i.one2],
					[i.one1, i.fiv1, i.thr2],
					[i.one1, i.fiv1, i.thr2, i.sev2],
					[i.one1, i.fiv1, i.fiv2],
					[i.one1, i.thr2, i.sev2],
					[i.thr1, i.one2, i.fiv2],
					[i.thr1, i.fiv1, i.one2],
					[i.fiv1, i.one2, i.thr2],
					[i.sev1, i.one2, i.thr2, i.fiv2]
					/////////////////////////
				);
			}
			else if (currentMode == "lydian")
			{
				chordTones = Helpers.pickFrom(
					// UNIVERSAL CHORDS /////
					[i.one1, i.thr1, i.fiv1],
					[i.one1, i.thr1, i.sev1],
					[i.one1, i.fiv1, i.one2],
					[i.one1, i.fiv1, i.thr2],
					[i.one1, i.fiv1, i.thr2, i.sev2],
					[i.one1, i.fiv1, i.fiv2],
					[i.one1, i.thr2, i.sev2],
					[i.thr1, i.one2, i.fiv2],
					[i.thr1, i.fiv1, i.one2],
					[i.fiv1, i.one2, i.thr2],
					[i.sev1, i.one2, i.thr2, i.fiv2],
					/////////////////////////
					[i.one1, i.six2, i.sev2, i.thr3]
				);
			}
			else if (currentMode == "mixolydian")
			{
				chordTones = Helpers.pickFrom(
					// UNIVERSAL CHORDS /////
					[i.one1, i.thr1, i.fiv1],
					[i.one1, i.thr1, i.sev1],
					[i.one1, i.fiv1, i.one2],
					[i.one1, i.fiv1, i.thr2],
					[i.one1, i.fiv1, i.thr2, i.sev2],
					[i.one1, i.fiv1, i.fiv2],
					[i.one1, i.thr2, i.sev2],
					[i.thr1, i.one2, i.fiv2],
					[i.thr1, i.fiv1, i.one2],
					[i.fiv1, i.one2, i.thr2],
					[i.sev1, i.one2, i.thr2, i.fiv2]
					/////////////////////////
				);						 
			}
			else if (currentMode == "aeolian")
			{
				chordTones = Helpers.pickFrom(
					// UNIVERSAL CHORDS /////
					[i.one1, i.thr1, i.fiv1],
					[i.one1, i.thr1, i.sev1],
					[i.one1, i.fiv1, i.one2],
					[i.one1, i.fiv1, i.thr2],
					[i.one1, i.fiv1, i.thr2, i.sev2],
					[i.one1, i.fiv1, i.fiv2],
					[i.one1, i.thr2, i.sev2],
					[i.thr1, i.one2, i.fiv2],
					[i.thr1, i.fiv1, i.one2],
					[i.fiv1, i.one2, i.thr2],
					[i.sev1, i.one2, i.thr2, i.fiv2]
					/////////////////////////
				);
			}
			else
				chordTones = [i.one1, i.fiv1, i.thr2];
		
			calculatePan();
			
			FlxG.play(chordTones[0], 0.15, 0, false, true);
			FlxG.play(chordTones[1], 0.15,-1, false, true);
			FlxG.play(chordTones[2], 0.15, 1, false, true);
			if (chordTones[3] != null)
				FlxG.play(chordTones[3], 0.15, _pan, false, true);
			
			var chordName: String = "";
			for (var j:int = 0; j <= chordTones.length - 1; j++)
			{
				var actualName: String = String(chordTones[j]);
				actualName = actualName.slice(17);
				actualName = actualName.slice(0,-1);
				actualName = actualName.replace(/s/,"#");
				chordName += actualName + " ";
			}
			PlayState.HUDevent.text = "Event: " + currentMode + ", " + chordName;
		}
				
		final protected function playOctave():void
		{		
			var octaveTone: Class;
			
			for (var i:int = 0; i <= notesLength - 1; i++)
			{								
				if (lastAbsoluteNote == notes[i])
				{
					while (octaveTone == null)
						octaveTone = notes[i + Helpers.pickFrom(12, -12)] as Class;
				}
			}
			
			FlxG.play(octaveTone, 0.1, _pan, false, true);
			
			lastOctaveTone = octaveTone;
		}
			
		final protected function playHarmonyTone():void
		{									
			var harmonyTone : Class;
//			var scale: Array = keys[keyIndex];
			
			var i:Object = intervals;
			
				 if (lastAbsoluteNote == i.one1)	harmonyTone = Helpers.pickFrom(i.fiv1, i.thr2);
			else if (lastAbsoluteNote == i.two1)	harmonyTone = i.fiv1;
			else if (lastAbsoluteNote == i.thr1)	harmonyTone = i.fiv1;
			else if (lastAbsoluteNote == i.for1)	harmonyTone = i.six1;
			else if (lastAbsoluteNote == i.fiv1)	harmonyTone = i.thr2;
			else if (lastAbsoluteNote == i.six1)	harmonyTone = i.one2;
			else if (lastAbsoluteNote == i.sev1)	harmonyTone = i.fiv1;
			else if (lastAbsoluteNote == i.one2)	harmonyTone = Helpers.pickFrom(i.thr1, i.thr2);
			else if (lastAbsoluteNote == i.two2)	harmonyTone = i.fiv2;
			else if (lastAbsoluteNote == i.thr2)	harmonyTone = i.fiv1;
			else if (lastAbsoluteNote == i.for2)	harmonyTone = i.six1;
			else if (lastAbsoluteNote == i.fiv2)	harmonyTone = i.thr3;
			else if (lastAbsoluteNote == i.six2)	harmonyTone = i.one3;
			else if (lastAbsoluteNote == i.sev2)	harmonyTone = i.thr2;
			else if (lastAbsoluteNote == i.one3)	harmonyTone = Helpers.pickFrom(i.thr2, i.thr3);
			else if (lastAbsoluteNote == i.two3)	harmonyTone = i.fiv2;
			else if (lastAbsoluteNote == i.thr3)	harmonyTone = i.fiv2;
			else if (lastAbsoluteNote == i.for3)	harmonyTone = i.six2;
			else if (lastAbsoluteNote == i.fiv3)	harmonyTone = i.sev2;
			else if (lastAbsoluteNote == i.six3)	harmonyTone = i.one3;
			else if (lastAbsoluteNote == i.sev3)	harmonyTone = i.thr3;
			else if (lastAbsoluteNote == i.one4)	harmonyTone = i.thr3;
				 
			
//			for (var i:int = 1; i < scale.length - 1; i++)
//			{	
//				if (lastAbsoluteNote == scale[i])
//				{
//					while (harmonyTone == null)
//						harmonyTone = scale[i + Helpers.pickFrom(-5, 2, 4)] as Class;
//				}
//			}
			
			FlxG.play(harmonyTone, 0.1, _pan, false, true);
			
			lastHarmonyTone = harmonyTone;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		// MODE FUNCTIONS //////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		final protected function ionian():void
		{
				var i:Object = intervals;
			
					 if (lastPlayNote == i.one1) 	_play(i.two1, i.thr1, i.fiv1, i.two2, i.thr2);
				else if (lastPlayNote == i.two1)	_play(i.thr1, i.for1, i.fiv1, i.sev1);
				else if (lastPlayNote == i.thr1)	_play(i.two1, i.for1, i.fiv1, i.sev1, i.one1);
				else if (lastPlayNote == i.for1)	_play(i.thr1, i.fiv1, i.one2);
				else if (lastPlayNote == i.fiv1)	_play(i.one1, i.thr1, i.for1, i.six1, i.sev1, i.one2, i.two2);
				else if (lastPlayNote == i.six1)	_play(i.fiv1, i.sev1, i.one2);
				else if (lastPlayNote == i.sev1)	_play(i.fiv1, i.one2);
				else if (lastPlayNote == i.one2)	_play(i.one1, i.thr1, i.for1, i.two2, i.thr2, i.fiv2, i.two3, i.thr3, i.sev2, i.sev1, i.six1);
				else if (lastPlayNote == i.two2)	_play(i.one2, i.thr2, i.for2, i.fiv2, i.sev2);
				else if (lastPlayNote == i.thr2)	_play(i.two2, i.for2, i.fiv2, i.sev2, i.one2, i.six1, i.fiv1);
				else if (lastPlayNote == i.for2)	_play(i.thr2, i.fiv2, i.one3);
				else if (lastPlayNote == i.fiv2)	_play(i.one2, i.thr3, i.for3, i.six3, i.sev3, i.one4, i.two3);
				else if (lastPlayNote == i.six2)	_play(i.fiv2, i.sev3, i.one4);
				else if (lastPlayNote == i.sev2)	_play(i.fiv2, i.one3);
				else if (lastPlayNote == i.one3)	_play(i.one2, i.two3, i.thr3, i.fiv3, i.thr2, i.for2, i.sev2, i.six2);
				else if (lastPlayNote == i.two3)	_play(i.one3, i.thr3, i.for3, i.fiv3, i.sev3);
				else if (lastPlayNote == i.thr3)	_play(i.two3, i.for3, i.fiv3, i.sev3, i.one3);
				else if (lastPlayNote == i.for3)	_play(i.thr3, i.fiv3, i.one4);	
				else if (lastPlayNote == i.fiv3)	_play(i.one3, i.thr3, i.for3, i.six3, i.sev3, i.one4);
				else if (lastPlayNote == i.six3)	_play(i.fiv3, i.sev3, i.one4);
				else if (lastPlayNote == i.sev3)	_play(i.fiv3, i.one4);
				else if (lastPlayNote == i.one4)	_play(i.one1, i.thr3, i.for3, i.fiv3, i.sev3, i.one3);
					
											else	_play(i.one2, i.one3);
		}
		
		final protected function dorian():void
		{
			var i:Object = intervals;
			
				 if (lastPlayNote == i.one1) 	_play(i.two1, i.thr1, i.for1, i.fiv1, i.six1, i.sev1, i.one2, i.two2, i.thr2, i.for2, i.fiv2);
			else if (lastPlayNote == i.two1)	_play(i.fiv1, i.six1, i.sev1);
			else if (lastPlayNote == i.thr1)	_play(i.one1, i.for1, i.fiv1, i.six1, i.sev1, i.one2, i.thr2, i.two2, i.fiv2);
			else if (lastPlayNote == i.for1)	_play(i.fiv1, i.six1, i.sev1, i.one2, i.thr2);
			else if (lastPlayNote == i.fiv1)	_play(i.two1, i.six1, i.sev1, i.one2, i.two2, i.thr2, i.for2, i.fiv2, i.sev2);
			else if (lastPlayNote == i.six1)	_play(i.one1, i.for1, i.fiv1, i.sev1, i.one2, i.for2, i.fiv2);
			else if (lastPlayNote == i.sev1)	_play(i.thr1, i.fiv1, i.six1, i.one2, i.two2, i.thr2, i.fiv2, i.sev2);
			else if (lastPlayNote == i.one2)	_play(i.one1, i.thr1, i.for1, i.fiv1, i.six1, i.sev1, i.two2, i.thr2, i.for2, i.fiv2, i.six2, i.sev2, i.one3, i.two3, i.thr3, i.for3, i.fiv3);
			else if (lastPlayNote == i.two2)	_play(i.fiv1, i.one2, i.thr2, i.fiv2, i.sev2, i.two3);
			else if (lastPlayNote == i.thr2)	_play(i.thr1, i.fiv1, i.six1, i.sev1, i.one2, i.two2, i.for2, i.fiv2, i.six2, i.sev2, i.one3, i.thr3);
			else if (lastPlayNote == i.for2)	_play(i.thr2, i.fiv2, i.six2, i.sev2, i.thr3, i.six1);
			else if (lastPlayNote == i.fiv2)	_play(i.thr1, i.fiv1, i.six1, i.sev1, i.one2, i.two2, i.thr2, i.for2, i.six2, i.sev2, i.one3, i.two3, i.thr3);
			else if (lastPlayNote == i.six2)	_play(i.for1, i.six1, i.for2, i.fiv2, i.sev2, i.one3, i.thr3, i.for3, i.six3);
			else if (lastPlayNote == i.sev2)	_play(i.sev1, i.thr2, i.fiv2, i.six2, i.one3, i.two3, i.thr3, i.fiv3, i.sev3);
			else if (lastPlayNote == i.one3)	_play(i.one1, i.for1, i.fiv1, i.six1, i.one2, i.thr2, i.fiv2, i.six2, i.sev2, i.two3, i.thr3, i.for3, i.fiv3, i.six3, i.one4);
			else if (lastPlayNote == i.two3)	_play(i.two2, i.fiv2, i.one3, i.thr3, i.fiv3, i.sev3);
			else if (lastPlayNote == i.thr3)	_play(i.thr1, i.fiv3, i.six3, i.sev3, i.one3, i.two3, i.for3, i.fiv3, i.six3, i.sev3, i.one4);
			else if (lastPlayNote == i.for3)	_play(i.six2, i.thr3, i.fiv3, i.six3, i.sev3);	
			else if (lastPlayNote == i.fiv3)	_play(i.thr2, i.fiv2, i.six2, i.sev2, i.one3, i.two3, i.thr3, i.for3, i.six3, i.sev3, i.one4);
			else if (lastPlayNote == i.six3)	_play(i.for2, i.six2, i.for3, i.fiv3, i.sev3, i.one4);
			else if (lastPlayNote == i.sev3)	_play(i.sev2, i.thr3, i.fiv3, i.six3, i.one4);
			else if (lastPlayNote == i.one4)	_play(i.six2, i.one3, i.thr3, i.for3, i.fiv3, i.six3, i.sev3);
				
			else	_play(i.one1, i.one2, i.one3);
		}
		
		final protected function lydian():void
		{
			var i:Object = intervals;
			
				 if (lastPlayNote == i.one1) 	_play(i.two1, i.thr1, i.fiv1, i.two2, i.thr2);
			else if (lastPlayNote == i.two1)	_play(i.thr1, i.for1, i.fiv1, i.sev1);
			else if (lastPlayNote == i.thr1)	_play(i.two1, i.for1, i.fiv1, i.sev1, i.one1);
			else if (lastPlayNote == i.for1)	_play(i.thr1, i.fiv1, i.one2);
			else if (lastPlayNote == i.fiv1)	_play(i.one1, i.thr1, i.for1, i.six1, i.sev1, i.one2, i.two2);
			else if (lastPlayNote == i.six1)	_play(i.fiv1, i.sev1, i.one2);
			else if (lastPlayNote == i.sev1)	_play(i.fiv1, i.one2);
			else if (lastPlayNote == i.one2)	_play(i.one1, i.thr1, i.for1, i.two2, i.thr2, i.fiv2, i.two3, i.thr3, i.sev2, i.sev1, i.six1);
			else if (lastPlayNote == i.two2)	_play(i.one2, i.thr2, i.for2, i.fiv2, i.sev2);
			else if (lastPlayNote == i.thr2)	_play(i.two2, i.for2, i.fiv2, i.sev2, i.one2, i.six1, i.fiv1);
			else if (lastPlayNote == i.for2)	_play(i.thr2, i.fiv2, i.one3);
			else if (lastPlayNote == i.fiv2)	_play(i.one2, i.thr3, i.for3, i.six3, i.sev3, i.one4, i.two3);
			else if (lastPlayNote == i.six2)	_play(i.fiv2, i.sev3, i.one4);
			else if (lastPlayNote == i.sev2)	_play(i.fiv2, i.one3);
			else if (lastPlayNote == i.one3)	_play(i.one2, i.two3, i.thr3, i.fiv3, i.thr2, i.for2, i.sev2, i.six2);
			else if (lastPlayNote == i.two3)	_play(i.one3, i.thr3, i.for3, i.fiv3, i.sev3);
			else if (lastPlayNote == i.thr3)	_play(i.two3, i.for3, i.fiv3, i.sev3, i.one3);
			else if (lastPlayNote == i.for3)	_play(i.thr3, i.fiv3, i.one4);	
			else if (lastPlayNote == i.fiv3)	_play(i.one3, i.thr3, i.for3, i.six3, i.sev3, i.one4);
			else if (lastPlayNote == i.six3)	_play(i.fiv3, i.sev3, i.one4);
			else if (lastPlayNote == i.sev3)	_play(i.fiv3, i.one4);
			else if (lastPlayNote == i.one4)	_play(i.one1, i.thr3, i.for3, i.fiv3, i.sev3, i.one3);
				
			else	_play(i.one2, i.one3);
		}
		
		final protected function mixolydian():void
		{
			var i:Object = intervals;
			
				 if (lastPlayNote == i.one1) 	_play(i.two1, i.thr1, i.fiv1, i.two2, i.thr2);
			else if (lastPlayNote == i.two1)	_play(i.thr1, i.for1, i.fiv1, i.sev1);
			else if (lastPlayNote == i.thr1)	_play(i.two1, i.for1, i.fiv1, i.sev1, i.one1);
			else if (lastPlayNote == i.for1)	_play(i.thr1, i.fiv1, i.one2);
			else if (lastPlayNote == i.fiv1)	_play(i.one1, i.thr1, i.for1, i.six1, i.sev1, i.one2, i.two2);
			else if (lastPlayNote == i.six1)	_play(i.fiv1, i.sev1, i.one2);
			else if (lastPlayNote == i.sev1)	_play(i.fiv1, i.one2);
			else if (lastPlayNote == i.one2)	_play(i.one1, i.thr1, i.for1, i.two2, i.thr2, i.fiv2, i.two3, i.thr3, i.sev2, i.sev1, i.six1);
			else if (lastPlayNote == i.two2)	_play(i.one2, i.thr2, i.for2, i.fiv2, i.sev2);
			else if (lastPlayNote == i.thr2)	_play(i.two2, i.for2, i.fiv2, i.sev2, i.one2, i.six1, i.fiv1);
			else if (lastPlayNote == i.for2)	_play(i.thr2, i.fiv2, i.one3);
			else if (lastPlayNote == i.fiv2)	_play(i.one2, i.thr3, i.for3, i.six3, i.sev3, i.one4, i.two3);
			else if (lastPlayNote == i.six2)	_play(i.fiv2, i.sev3, i.one4);
			else if (lastPlayNote == i.sev2)	_play(i.fiv2, i.one3);
			else if (lastPlayNote == i.one3)	_play(i.one2, i.two3, i.thr3, i.fiv3, i.thr2, i.for2, i.sev2, i.six2);
			else if (lastPlayNote == i.two3)	_play(i.one3, i.thr3, i.for3, i.fiv3, i.sev3);
			else if (lastPlayNote == i.thr3)	_play(i.two3, i.for3, i.fiv3, i.sev3, i.one3);
			else if (lastPlayNote == i.for3)	_play(i.thr3, i.fiv3, i.one4);	
			else if (lastPlayNote == i.fiv3)	_play(i.one3, i.thr3, i.for3, i.six3, i.sev3, i.one4);
			else if (lastPlayNote == i.six3)	_play(i.fiv3, i.sev3, i.one4);
			else if (lastPlayNote == i.sev3)	_play(i.fiv3, i.one4);
			else if (lastPlayNote == i.one4)	_play(i.one1, i.thr3, i.for3, i.fiv3, i.sev3, i.one3);
				
			else	_play(i.one2, i.one3);
		}
		
		final protected function aeolian():void
		{
			var i:Object = intervals;
			
				 if (lastPlayNote == i.one1) 	_play(i.two1, i.thr1, i.fiv1, i.two2, i.thr2);
			else if (lastPlayNote == i.two1)	_play(i.thr1, i.for1, i.fiv1, i.sev1);
			else if (lastPlayNote == i.thr1)	_play(i.two1, i.for1, i.fiv1, i.sev1, i.one1);
			else if (lastPlayNote == i.for1)	_play(i.thr1, i.fiv1, i.one2);
			else if (lastPlayNote == i.fiv1)	_play(i.one1, i.thr1, i.for1, i.six1, i.sev1, i.one2, i.two2);
			else if (lastPlayNote == i.six1)	_play(i.fiv1, i.sev1, i.one2);
			else if (lastPlayNote == i.sev1)	_play(i.fiv1, i.one2);
			else if (lastPlayNote == i.one2)	_play(i.one1, i.thr1, i.for1, i.two2, i.thr2, i.fiv2, i.two3, i.thr3, i.sev2, i.sev1, i.six1);
			else if (lastPlayNote == i.two2)	_play(i.one2, i.thr2, i.for2, i.fiv2, i.sev2);
			else if (lastPlayNote == i.thr2)	_play(i.two2, i.for2, i.fiv2, i.sev2, i.one2, i.six1, i.fiv1);
			else if (lastPlayNote == i.for2)	_play(i.thr2, i.fiv2, i.one3);
			else if (lastPlayNote == i.fiv2)	_play(i.one2, i.thr3, i.for3, i.six3, i.sev3, i.one4, i.two3);
			else if (lastPlayNote == i.six2)	_play(i.fiv2, i.sev3, i.one4);
			else if (lastPlayNote == i.sev2)	_play(i.fiv2, i.one3);
			else if (lastPlayNote == i.one3)	_play(i.one2, i.two3, i.thr3, i.fiv3, i.thr2, i.for2, i.sev2, i.six2);
			else if (lastPlayNote == i.two3)	_play(i.one3, i.thr3, i.for3, i.fiv3, i.sev3);
			else if (lastPlayNote == i.thr3)	_play(i.two3, i.for3, i.fiv3, i.sev3, i.one3);
			else if (lastPlayNote == i.for3)	_play(i.thr3, i.fiv3, i.one4);	
			else if (lastPlayNote == i.fiv3)	_play(i.one3, i.thr3, i.for3, i.six3, i.sev3, i.one4);
			else if (lastPlayNote == i.six3)	_play(i.fiv3, i.sev3, i.one4);
			else if (lastPlayNote == i.sev3)	_play(i.fiv3, i.one4);
			else if (lastPlayNote == i.one4)	_play(i.one1, i.thr3, i.for3, i.fiv3, i.sev3, i.one3);
				
			else	_play(i.one2, i.one3);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		// MUSIC HELPERS ///////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		final protected function populateIntervals():void
		{
			// If the intervals object is not already populated with the current key,
			if (intervals.currentKey != currentKey || intervals.currentMode != currentMode)
			{					
				intervals.currentKey = currentKey;
				intervals.currentMode = modes[modeIndex].name;
				
				for (var i:int = 0; i <= intervalNames.length - 1; i++)
				{
					intervals[intervalNames[i]] = keys[keyIndex][i + modes[modeIndex].offset];
				}
			}

		}
		
		final protected function logNotetoHUD():void
		{
			// Log note name, volume and pan to HUD
			var actualName: String = String(lastAbsoluteNote);
			actualName = actualName.slice(17);
			actualName = actualName.slice(0,-1);
			actualName = actualName.replace(/s/,"#");
			PlayState.HUDnote.text = "Note: " + actualName + ", " + int(_volume*100)/100 + ", " + int(_pan*100)/100;
		}
		
		final protected function calculatePan():void
		{
			// Convert x position to pan position.
			_pan = 2 * ((this.x - PlayState.camera.scroll.x) / FlxG.width) - 1;
		}
	}
}