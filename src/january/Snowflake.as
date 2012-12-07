package january
{
	import flash.utils.*;
	import january.music.*;
	import january.snowflakes.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Snowflake extends FlxSprite
	{		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// MUSIC-RELATED DEFINITIONS ///////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////		

		/** Volume for the Note. */
		protected var volume: Number;	
		/** Pan Value for the Note, measured in -1 to 1. */
		protected var pan: Number = Helper.rand(-1, 1);
		/** Whether the Snowflake in question allows for a pedal tone. */
		protected var pedalAllowed: Boolean;
		/** The current gameplay mode. */
		public static var mode: String = "Record";
		/** Used to store Intervals.loadout */
		protected static var i: Object;
		/** Whether to use primary or secondary timbre set. */
		public static var timbre: String;
		/** Volume Modifier for Secondary Timbre, used to divide original volume. */
		public static var _volumeMod: Number = 1.5;
		
		// List of Secondary Timbre Classes
		_C1; _Cs1; _D1; _Ds1; _E1; _F1; _Fs1; _G1; _Gs1; _A1; _As1; _B1; _C2; _Cs2; _D2; _Ds2; _E2; _F2; _Fs2; _G2; _Gs2; _A2; _As2; _B2; _C3; _Cs3; _D3; _Ds3; _E3; _F3; _Fs3; _G3; _Gs3; _A3; _As3; _B3; _C4; _Cs4; _D4; _Ds4; _E4; _F4; _Fs4; _G4; _Gs4; _A4; _As4; _B4;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// NON-MUSIC DEFINITIONS ///////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** The default color for fireflies in Record mode. */
		public static const RECORD_COLOR: uint = 0xFFFFFF;
		/** The default color for fireflies in Playback mode. */
		public static const PLAYBACK_COLOR: uint = 0x64E000;
		/** The default color for fireflies in Interject mode. */
		public static const INTERJECT_COLOR: uint = 0xF5D400;
		
		/** The type of snowflake in question. */
		public var type: String = "";
		/** Type of the last licked snowflake. */
		private static var lastLickedType: String;
		/** Horizontal modifier for snowflake movement. */
		protected var windX: int = 0;
		/** Vertical modifier for snowflake movement. */
		protected var windY: int = 0;
		/** The amount of headway for flake spawning. */
		protected static var headwayX: int = 60;
		/** Whether snowflake is a firefly or not, determined by whether it has been licked. */
		protected var licked: Boolean;
		/** The number of seconds to hold the firefly before it starts to fade. */
		protected var alphaLifespan: Number = 0;
		
		// Snowflake spawning probabilities
		private static var flakes: Array  = ["Small", "Octave", "Harmony", "Chord", "Vamp", "Transpose"];
		public static var weights: Array = [88.5, 0, 0, 0, 0, 0];
		
		// List of classes for getDefinitionByName() to use
		Small; Octave; Harmony; Chord; Vamp; Transpose;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
		public function Snowflake():void
		{	
			super(x, y);
			exists = false;
		}
		
		/** Determines which snowflakes to spawn.  */
		public static function manage(): void
		{													
			// All Flakes are Spawned based on weighted probability, except for the first one.
			var flakeID: String;
			
			 if (FlxG.score > 1)
				flakeID = flakes[Helper.weightedChoice(weights)];
			else
				flakeID = "Small";
			
			// use string above to instantiate proper Snowflake Subclass.
			var subClass: Class = getDefinitionByName( "january.snowflakes." + flakeID ) as Class;			
			var flake: Object = Game.snow.recycle(subClass) as subClass;
			flake.spawn(flakeID);		
		}
		
		/** Spawns snowflakes. */
		protected function spawn(flakeType: String, spawnX: Number = 0):void
		{															
			// POSITION
			if (spawnX != 0)
				x = spawnX;
			else
				x = Helper.randInt(Camera.lens.scroll.x, Camera.anchor.x + headwayX);		
				
			y = height * -1;
					
			type = flakeType;
			exists = true;
		}
		
		override public function update():void
		{			
			//////////////
			// MOVEMENT //
			//////////////
			
			if (licked == false)
			{
				windX = 5 + (FlxG.score * 0.025);
			
				if (windX >= 10)
					windX = 10;
				
				velocity.x = (Math.cos(y / windX) * windX);
					
				if (FlxG.score == 0)
					velocity.y = 15;
				else
					velocity.y = 5 + (Math.cos(y / 25) * 5) + windY;					
			}
			else // FIREFLIES
			{
				velocity.x = (Math.cos(y / 4) * 8);
				maxVelocity.y = 20;
				drag.y = 5;
				acceleration.y -= drag.y;
			}
			
			super.update();
			
			///////////////
			// COLLISION //
			///////////////
			
			if (( y > FlxG.height - 24 && (x + width <= Game.player.x || x >= Game.player.x + Game.player.width)) && x < Game.houseRight.x)
				kill();
			else if (y >= FlxG.height - 11 || x < Camera.lens.scroll.x - width || x > FlxG.worldBounds.width)
				kill();
			
			/////////////
			// EFFECTS //
			/////////////
			
			if (licked == true)
			{
				if (alphaLifespan > 0)
					alphaLifespan -= FlxG.elapsed;
				else
					alpha -= FlxG.elapsed;
				
				if (alpha <= 0)
					kill();
			}
		}
		
		/** Called when a Snowflake has been licked. */
		public function onLick():void
		{				
			super.kill();
			
			FlxG.score++;
			
			if (type != "Small")
				Game.scores[type]++;
			
			// Gradually introduce flakes
			if (FlxG.score >= Transpose.INTRODUCE_AT)	weights[5] = 0.5;	// Transpose
			if (FlxG.score >= Vamp.INTRODUCE_AT)		weights[4] = 2;		// Vamp
			if (FlxG.score >= Chord.INTRODUCE_AT)		weights[3] = 2;		// Chord
			if (FlxG.score >= Harmony.INTRODUCE_AT)		weights[2] = 3.5;	// Harmony
			if (FlxG.score >= Octave.INTRODUCE_AT)		weights[1] = 3.5;	// Octave
			
			// Increase Flake Probability if Player Keeps Licking that type. only Harmony and Octave Flakes
			for (var j:int = 1; j <= 2; j++)
			{
				// Increment probability by .05%
				if (type == flakes[j])
				{
					weights[j] += 0.05;
					weights[0] -= 0.05;	
				}
				
				// Limit Probability to 5%
				if (weights[j] >= 5)
					weights[j] = 5;
			}
			
			lastLickedType = type;
		}
		
		/** Create a firefly when player has licked snowflake. */
		public function fly():void
		{
			if (mode == "Playback")
				Playback.numbers.onLick(this);
			
//			if (FlxG.score > 1)
//			{				
//				var lickedFlake: Class = getDefinitionByName( "january.snowflakes." + type ) as Class;	
//				var firefly: Object = Game.fireflies.recycle(lickedFlake) as lickedFlake;
//				firefly.spawnFirefly(type, x, y);
//			}
		}
		
		/** Spawns fireflies (post-licked snowflakes). */
		protected function spawnFirefly(flakeType: String, X: Number = 0, Y: Number = 0):void
		{
			// CLEAN UP
			maxVelocity.y = 0; drag.y = 0;	
			
			// POSITION
			x = X; y = Y;	
			
			// MODE SPECIFIC STUFF
			if (mode == "Playback")
			{
				color = PLAYBACK_COLOR;
				//Playback.numbers.onLick(this);
			}
			else if (mode == "Interject")
				color = INTERJECT_COLOR;
			else
				color = RECORD_COLOR;
			
			// VISUAL FX			
			alphaLifespan = 1;
			if (Game.night.layerOn == true)
			{
				alpha = Game.night.alpha;	
				
				if (alpha >= 0.85)
					alpha = 1;
			}
			else
				alpha = 0;
			
			// ASSIGNMENTS
			type = flakeType;
			licked = true;
			exists = true;
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////
		// MUSIC FUNCTIONS //////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** Determines which kind of note to play. */
		final protected function playNote():void
		{									
			i = Intervals.loadout;
			
			if (mode == "Playback")									
				playback();
			else
				generateNote();
			
			if (mode == "Record")
				manageSequence();
			
			if (Pedal.mode == true)
				if (pedalAllowed) playPedalTone();
		}
		
		/** Plays a playback note, pulled from a sequence of stored notes. */
		final protected function playback():void
		{
			//FlxG.log("playback()");
			
			if (Playback.sequence.length == 0)
			{
				FlxG.play(Note.lastAbsolute, volume, pan);
				Playback.index = 1;
			}
			else
			{				
				// Convert Interval String in Sequence to Note, then play it.
				var id:String = Playback.sequence[Playback.index];
				
				if (timbre == "Primary")
					FlxG.play(i[id] as Class, volume, pan);
				else
				{
					var modifiedNote: Class = getDefinitionByName("_" + getQualifiedClassName(i[id] as Class) ) as Class;
					FlxG.play(modifiedNote, volume/_volumeMod, pan);
				}
				
				Note.lastAbsolute = i[id] as Class;			
				
				// Index Counting 
				if (Playback.reverse == false)
				{
					Playback.index++;
				
					if (Playback.index > Playback.sequence.length - 1)
						Playback.index = 0;
				}
				else
				{
					Playback.index--;
					
					if (Playback.index < 0)
						Playback.index = Playback.sequence.length - 1;
				}
			}
			
			MIDI.log(Note.lastAbsolute, volume);
			HUD.logNote(volume, pan);
		}
		
		final protected function manageSequence():void
		{			
			// Push reference to interval to sequence array (strings)
			loop: for (var interval:* in i)
			{
				if (Note.lastRecorded == i[interval])
				{
					Playback.sequence.push(interval);
					
					break loop;
				}
			}
			
			// Limit Playback Sequence Size
			if (Playback.sequence.length > 8)
				Playback.sequence.shift();
		}
		
		/** Play a note! Takes in an array of classes, and will pick one randomly. */	
		final protected function _play(options: Array):void
		{				
			var randomNote: Class = noteAdjustments(options);
			
			if (timbre == "Primary")
				FlxG.play(randomNote, volume, pan);
			else
			{
				var modifiedNote: Class = getDefinitionByName("_" + getQualifiedClassName(randomNote) ) as Class;
				FlxG.play(modifiedNote, volume/_volumeMod, pan);
			}	
			
			// LOGS
			MIDI.log(randomNote, volume);
			Note.secondToLastRecorded = Note.lastRecorded;
			Note.lastRecorded = randomNote;
			Note.lastAbsolute = Note.lastRecorded;
			HUD.logNote(volume, pan);
		}
				
		final protected function playChord():void
		{					
			i = Intervals.loadout;
			
			// DETERMINE CHORD TONES
			var chordTones: Array = Helper.pickNested(Mode.current.chords);
		
			// PUSH NOTES TO FLAM TIMER
			calculatePan();
			
			// MODIFY ROOT NOTE IF USING SECONDARY TIMBRE
			if (timbre == "Secondary")
				var modifiedNote: Class = getDefinitionByName("_" + getQualifiedClassName(i[chordTones[0]]) ) as Class;
			
			// First chord tone of Vamp should play immediately, because there is no playNote() function call.
			if (type == "Vamp")
			{
				if (timbre == "Primary")
					FlxG.play(i[chordTones[0]], Chord.VOLUME, pan);
				else
					FlxG.play(modifiedNote, Chord.VOLUME/_volumeMod, pan);
			}
			else
			{
				var s1:FlxSound;
				
				if (timbre == "Primary")
					s1 = FlxG.loadSound(i[chordTones[0]], Chord.VOLUME, pan);	
				else
					s1 = FlxG.loadSound(modifiedNote, Chord.VOLUME/_volumeMod, pan);
				
				Game.flamNotes.push(s1);
			}
			
			var s2:FlxSound;
			var s3:FlxSound;
			
			if (timbre == "Primary")
			{
				s2 = FlxG.loadSound(i[chordTones[1]], Chord.VOLUME, -1);
				s3 = FlxG.loadSound(i[chordTones[2]], Chord.VOLUME, 1);
			}
			else
			{
				var _s2: Class = getDefinitionByName("_" + getQualifiedClassName(i[chordTones[1]]) ) as Class;
				var _s3: Class = getDefinitionByName("_" + getQualifiedClassName(i[chordTones[2]]) ) as Class;
				
				s2 = FlxG.loadSound(_s2, Chord.VOLUME/_volumeMod, -1);
				s3 = FlxG.loadSound(_s3, Chord.VOLUME/_volumeMod, 1);
			}
			
			Game.flamNotes.push(s2, s3);
			
			// Create array of classes for HUD logging.
			var events: Array = [ i[chordTones[0]], i[chordTones[1]], i[chordTones[2]] ];
			
			// If the chord is a seventh chord, push the 4th chord tone.
			if (i[chordTones[3]] != null)
			{
				var s4:FlxSound;
				
				if (timbre == "Primary")
					s4 = FlxG.loadSound(i[chordTones[3]], Chord.VOLUME, -1*pan);
				else
				{
					var _s4: Class = getDefinitionByName("_" + getQualifiedClassName(i[chordTones[3]]) ) as Class;
					s4 = FlxG.loadSound(_s4, Chord.VOLUME/_volumeMod, -1*pan);
				}
					
				Game.flamNotes.push(s4);	
				events[3] = i[chordTones[3]];
			}
			
			Game.flamTimer.start();
			
			HUD.logMode();			
			HUD.logEvent(events);
		}
		
		final protected function playPedalTone():void
		{	
			var pedalTone:Class = Note.lastAbsolute;
			
			while (pedalTone == Note.lastAbsolute 
				|| pedalTone == Note.lastPedal
				||(pedalTone == Note.lastOctave && type == "Octave")
				||(pedalTone == Note.lastHarmony && type == "Harmony"))
			{
				pedalTone = Helper.pickFrom(i.one1, i.fiv1, i.one2, i.fiv2);
			}
			
			if (timbre == "Primary")
				FlxG.play(pedalTone, volume/2, 0);
			else
			{
				var modifiedNote: Class = getDefinitionByName("_" + getQualifiedClassName(pedalTone) ) as Class;
				FlxG.play(modifiedNote, volume/(2 + _volumeMod), 0);
			}
			
			Note.lastPedal = pedalTone;
			MIDI.log(pedalTone, volume/2);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		// MODE FUNCTIONS //////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** Uses the option sets of the current mode to choose which note to generate. */
		final protected function generateNote():void
		{
			var played: Boolean;
			var optionSets: Array = Mode.current.logic;
			
			loop: for (var j:int = 0; j < Intervals.DATABASE.length - 1; j++)
			{				
				if (Note.lastRecorded == i[Intervals.DATABASE[j]])
				{					
					_play(optionSets[j]);
					played = true;
					
					break loop;
				}
			}
			
			if (played == false)
				_play(optionSets[22]);	// [22] is the else statement.
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		// MUSIC HELPERS ///////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		final protected function calculatePan():void
		{
			// Convert x position to pan position.
			pan = 2 * ((this.x - Camera.lens.scroll.x) / FlxG.width) - 1;
		}
		
		final protected function noteAdjustments(options: Array):Class
		{
			var note: Class;
			var random: int;
			
			// NOTE PREVENTIONS			
			while (note == null
				|| note == Note.lastAbsolute
				|| note == Note.secondToLastRecorded
				|| (note == Note.lastHarmony && lastLickedType == "Harmony")
				|| (note == Note.lastOctave && lastLickedType == "Octave")
				|| (type == "Octave" && (note == i.for1 || note == i.for2 || note == i.for3)) )
			{
				random = Helper.randInt(0, options.length - 1);
				note = i[options[random]] as Class;
			}
			
			// Prevent certain tensions from triggering on record mode key changes
			if (Key.justChanged
				&& Mode.current != Mode.MIXOLYDIAN
				&& (note == i.two1 ||
					note == i.for1 ||
					note == i.six1 ||
					note == i.for2 ||
					note == i.six2 ||
					note == i.for3 ||
					note == i.six3) )
			{	
				outerLoop: for (var desc:* in i)
				{				
					if (note == i[desc])
					{
						for (var j:int = 0; j < Intervals.DATABASE.length - 1; j++)
						{
							if (i[desc] == Intervals.DATABASE[j])
							{
								// change new note to be +/- 1 interval if the key just changed.
								note = i[Intervals.DATABASE[j + FlxMath.randomSign()]];	
								break outerLoop;
							}
						}
					}
				}
				
				Key.justChanged = false;
			}
		
			return note;
			
		}
	}
}