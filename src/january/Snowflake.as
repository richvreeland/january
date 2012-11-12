package january
{
	import flash.utils.getDefinitionByName;
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
		protected var volume: Number = 0;	
		/** Pan Value for the Note, measured in -1 to 1. */
		protected var pan: Number = 0;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// NON-MUSIC DEFINITIONS ///////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** The type of snowflake in question. */
		public var type: String;
		/** Type of the last licked snowflake. */
		protected static var lastLickedType: String;
		/** Horizontal modifier for snowflake movement. */
		protected var windX: int;
		/** Vertical modifier for snowflake movement. */
		protected var windY: int;
		/** Whether snowflake is a firefly or not, determined by whether it has been licked. */
		protected var licked: Boolean;
		/** The number of seconds to hold the firefly before it starts to fade. */
		protected var alphaLifespan: Number;
		
		// Snowflake spawning probabilities
		private static var flakes: Array  = ["Small", "Large", "Octave", "Harmony", "Chord"	, "Vamp", "Transpose"];
		private static var weights: Array = [78.5, 10, 0, 0, 0, 0, 0];
		
		// List of classes for getDefinitionByName() to use
		Chord; Large; Octave; Small; Transpose; Harmony; Vamp;
		
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
				flakeID = flakes[Helpers.weightedChoice(weights)];
			else if (FlxG.score == 1)
				flakeID = "Small";
			else
				flakeID = "Large";
			
			// use string above to instantiate proper Snowflake Subclass.
			var subClass : Class = getDefinitionByName( "january.snowflakes." + flakeID ) as Class;	
			var flake : Object = Game.snow.recycle(subClass) as subClass;
			flake.spawn(flakeID);		
		}
		
		/** Spawns snowflakes. */
		protected function spawn(flakeType: String, licked: Boolean = false, X: Number = 0, Y: Number = 0):void
		{															
			if (licked == false)
			{
				// POSITION
				if (FlxG.score > 0)
					x = Helpers.randInt(Camera.lens.scroll.x, Camera.rails.x + 60);
				else
					x = Camera.lens.scroll.x + FlxG.width/2;			
				y = height * -1;
			}
			else
			{
				licked = true;
				
				// CLEAN UP
				maxVelocity.y = 0;
				drag.y = 0;	
				
				// POSITION
				x = X;
				y = Y;	
				
				// COLOR
				if (Playback.mode == true)
					color = Global.PLAYBACK_COLOR;
				else
					color = Global.RECORD_COLOR;
				
				// OPACITY
				flicker(0.75);
				
				alphaLifespan = Global.ALPHA_LIFESPAN;
				if (Game.night.layerOn == true)
				{
						alpha = Game.night.alpha;	
					if (alpha >= 0.85)
						alpha = 1;
				}
				else
					alpha = 0;
				
				// TEXT OUTPUT
				Game.textOutput.onLick(this);
			}
			
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
				Global.scores[type]++;
			
			// Gradually introduce flakes
			if (FlxG.score >= Transpose.INTRODUCE_AT)	weights[6] = 0.5;	// Transpose
			if (FlxG.score >= Vamp.INTRODUCE_AT)		weights[5] = 2;		// Vamp
			if (FlxG.score >= Chord.INTRODUCE_AT)		weights[4] = 2;		// Chord
			if (FlxG.score >= Harmony.INTRODUCE_AT)		weights[3] = 3.5;	// Harmony
			if (FlxG.score >= Octave.INTRODUCE_AT)		weights[2] = 3.5;	// Octave
			
			// Increase Flake Probability if Player Keeps Licking that type. Excludes Small, Large, and Transpose Flakes
			for (var i:int = 2; i <= 5; i++)
			{
				// Increment probability by .05%
				if (type == flakes[i])
				{
					weights[i] += 0.05;
					weights[0] -= 0.05;	
				}
				
				// Limit Probability to 5%
				if (weights[i] >= 5)
					weights[i] = 5;
			}
			lastLickedType = type;
			
			// DETERMINE WHETHER TO USE RECORD/PLAYBACK MODE
			if (type == "Large" && FlxG.score > 1)
			{
				if (Playback.mode == false && Playback.sequence.length > 0)
					Playback.mode = true;
				else
				{
					Playback.mode = false;
					Playback.sequence = [];
					Playback.index = 0;
				}
			}
		}
		
		/** Create a firefly when player has licked snowflake. */
		public function fly():void
		{
			if (FlxG.score > 1)
			{				
				var lickedFlake: Class = getDefinitionByName( "january.snowflakes." + type ) as Class;	
				var firefly: Object = Game.fireflies.recycle(lickedFlake) as lickedFlake;
				firefly.spawn(type, true, x, y);
			}
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////
		// MUSIC FUNCTIONS //////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** Determines which kind of note to play. */
		final protected function playNote():void
		{									
			calculatePan();
		
			var intervals:Object = Intervals.loadout;
			
			if (Playback.mode == true)	// PLAYBACK MODE
			{						
				// Convert Interval String in Sequence to Note, then play it.
				var id:String = Playback.sequence[Playback.index];
				FlxG.play(intervals[id] as Class, volume, pan);
				Note.lastAbsolute = intervals[id] as Class;			
				Playback.index++;
				
				if (Playback.index > Playback.sequence.length - 1)
					Playback.index = 0;
				
				MIDI.log(Note.lastAbsolute, volume);
			}
			else if (Note.lastRecorded != null)	// RECORD MODE
			{						
				var modeFunction:Function = this[Mode.current] as Function;
				modeFunction();			
			}
			else // INITIAL SNOWFLAKE
			{
				Intervals.populate();
				Note.initial = Helpers.pickFrom(Intervals.loadout.one2, Intervals.loadout.one3);
				FlxG.play(Note.initial, volume);
				Note.lastRecorded = Note.initial;
				Note.lastAbsolute = Note.lastRecorded;
				
				MIDI.log(Note.lastAbsolute, volume);
				HUD.logNote(volume, pan);
				HUD.logMode();
				HUD.logKey();
			}
			
			if (Playback.mode == false)
			{
				// Push reference to interval to sequence array (strings)
				loop: for (var interval:* in intervals)
				{
					if (Note.lastRecorded == intervals[interval])
					{
						Playback.sequence.push(interval);				
						break loop;
					}
				}
			}
			
			// Push the last Play note to the Replay Playback sequence.
//			if (Playback.mode == false)
//				Playback.sequence.push(Note.lastRecorded as Class);
			
			// Limit Playback Sequence Size
			if (Playback.sequence.length > 8)
				Playback.sequence.shift();
		}

		/** Play a note! Takes in class arguments, and will pick one randomly. */	
		final protected function _play(... options):void
		{				
			var random: int = 0;
			var randomNote: Class = null;
			
			// Prevent null notes, and various types of repetitions from happening.
			while (randomNote == null || randomNote == Note.lastAbsolute || (randomNote == Note.lastHarmony && lastLickedType == "Harmony") || (randomNote == Note.lastOctave && lastLickedType == "Octave"))
			{
				random = Helpers.randInt(0, options.length - 1);
				randomNote = options[random] as Class;
			}
			
			// Separate check for preventing trills, at a probability of X : 1, where X is total number of options
			if (randomNote == Note.secondToLastRecorded)
			{
				random = Helpers.randInt(0, options.length - 1);
				randomNote = options[random] as Class;
			}
			
			// Make Fourth Octave Range quieter, because it gets a bit shrill.
			for (var h:int = Note.DATABASE.length - 13; h < Note.DATABASE.length - 1; h++)
			{
				if (randomNote == Note.DATABASE[h])
					volume = Helpers.rand(Global.NOTE_MAX_VOLUME * 0.16, Global.NOTE_MAX_VOLUME * 0.5);
			}
			
			var i:Object = Intervals.loadout;
			
			// Prevent seconds, fourths and sixths from triggering on key changes
			if (Key.justChanged && (randomNote == i.for1 || randomNote == i.six1 || randomNote == i.for2 || randomNote == i.six2 || randomNote == i.for3 || randomNote == i.six3) )
			{	
				//Check randomNote against intervals
				outerLoop: for (var desc:* in i)
				{				
					if (randomNote == i[desc])
					{
						// check against interval strings
						for (var j:int = 0; j < Intervals.DATABASE.length - 1; j++)
						{
							if (i[desc] == Intervals.DATABASE[j])
							{
								// change new note to be +/- 1 interval if the key just changed.
								randomNote = i[Intervals.DATABASE[j + FlxMath.randomSign()]];
								break outerLoop;
							}
						}
					}
				}
				
				Key.justChanged = false;
			}
				
			
			FlxG.play(randomNote, volume, pan);
			MIDI.log(randomNote, volume);

			
			// Only store note we just played if we're in play mode.
			if (Playback.mode == false)
			{
				// Store second to Last Play Note, used above, to prevent trills.
				Note.secondToLastRecorded = Note.lastRecorded;
				// Store Last Play Note, used for generative logic.
				Note.lastRecorded = randomNote;
				// Store Last Play Note as the Last Absolute Note, because it is.
				Note.lastAbsolute = Note.lastRecorded;
			}
			
			HUD.logNote(volume, pan);
		}
				
		final protected function playChord():void
		{					
			var i:Object = Intervals.loadout;		
			var chordTones: Array;
			
			if (Mode.current == "ionian")
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
					//[i.sev1, i.one2, i.thr2, i.fiv2],
					/////////////////////////
					[i.one2, i.two2, i.sev2],
					[i.one1, i.two2, i.sev2]
				);
			}
			else if (Mode.current == "dorian")
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
					[i.fiv1, i.one2, i.thr2]
					/////////////////////////
				);
			}
			else if (Mode.current == "lydian")
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
					/////////////////////////
					[i.one1, i.six1, i.sev1, i.thr2]
				);
			}
			else if (Mode.current == "mixolydian")
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
					/////////////////////////
					[i.thr1, i.fiv1, i.sev1, i.two2]
				);						 
			}
			else if (Mode.current == "aeolian")
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
					[i.fiv1, i.one2, i.thr2]
					/////////////////////////
				);
			}
			else
				chordTones = [i.one1, i.fiv1, i.thr2];
		
			calculatePan();
			FlxG.play(chordTones[0], Chord.VOLUME, pan);
			FlxG.play(chordTones[1], Chord.VOLUME,-1);
			FlxG.play(chordTones[2], Chord.VOLUME, 1);
			
			if (chordTones[3] != null)
			{
				FlxG.play(chordTones[3], Chord.VOLUME, -1*pan);
				MIDI.log(chordTones[3], Chord.VOLUME);	
			}
			
			HUD.logMode(chordTones);
			
			MIDI.log(chordTones[0], Chord.VOLUME);
			MIDI.log(chordTones[1], Chord.VOLUME);
			MIDI.log(chordTones[2], Chord.VOLUME);
			
			if (type == "Transpose")
			{
				var sound:FlxSound;
				var g:uint = 0;
				
				// Run through all sounds.
				outerLoop: while (g < FlxG.sounds.length)
				{
					sound = FlxG.sounds.members[g++] as FlxSound;
					
					// If the sound has volume,
					if (sound != null && sound.active == true)
					{
						// Compare to current key notes.
						for each (var note:Class in i)
						{
							if (sound.classType == note)
								continue outerLoop;
						}
						
						// If a note made it this far, it's not in the current key, so fade it out. 
						sound.fadeOut(0.2);	
					}
				}
				
			}
		}
				
		final protected function playOctave():void
		{		
			var octaveTone: Class;
			
			outerLoop: for (var i:int = 0; i <= Note.DATABASE.length - 1; i++)
			{								
				if (Note.lastAbsolute == Note.DATABASE[i])
				{
					while (octaveTone == null)
						octaveTone = Note.DATABASE[i + Helpers.pickFrom(12, -12)] as Class;
					
					break outerLoop;
				}
			}
			
			FlxG.play(octaveTone, Octave.VOLUME, pan);		
			Note.lastOctave = octaveTone;
			
			MIDI.log(octaveTone, Octave.VOLUME);
		}
			
		final protected function playHarmonyTone():void
		{					
			var harmonyTone: Class;
			var choices: Array = [];	
			var i:Object = Intervals.loadout;
			
				 if (Note.lastAbsolute == i.one1) choices = [i.thr1, i.fiv1, i.thr2, i.fiv2];
			else if (Note.lastAbsolute == i.two1) choices = [i.fiv1, i.sev1, i.fiv2];
			else if (Note.lastAbsolute == i.thr1) choices = [i.fiv1, i.one2];
			else if (Note.lastAbsolute == i.for1) choices = [i.fiv1, i.one2, i.two2];
			else if (Note.lastAbsolute == i.fiv1) choices = [i.thr1, i.sev1, i.thr2];
			else if (Note.lastAbsolute == i.six1) choices = [i.one2, i.thr2];
			else if (Note.lastAbsolute == i.sev1) choices = [i.thr1, i.fiv1, i.thr2];
			else if (Note.lastAbsolute == i.one2) choices = [i.fiv1, i.thr2, i.fiv2];
			else if (Note.lastAbsolute == i.two2) choices = [i.fiv1, i.fiv2, i.sev2];
			else if (Note.lastAbsolute == i.thr2) choices = [i.sev1, i.one2, i.fiv2, i.sev2, i.one3];
			else if (Note.lastAbsolute == i.for2) choices = [i.two2, i.fiv2, i.one3];
			else if (Note.lastAbsolute == i.fiv2) choices = [i.thr2, i.sev2, i.thr3];
			else if (Note.lastAbsolute == i.six2) choices = [i.one3, i.thr3];
			else if (Note.lastAbsolute == i.sev2) choices = [i.thr2, i.fiv2, i.thr3];
			else if (Note.lastAbsolute == i.one3) choices = [i.thr2, i.fiv2, i.thr3, i.fiv3];
			else if (Note.lastAbsolute == i.two3) choices = [i.fiv2, i.sev2, i.fiv3];
			else if (Note.lastAbsolute == i.thr3) choices = [i.sev2, i.one3, i.fiv3, i.sev3, i.one4];
			else if (Note.lastAbsolute == i.for3) choices = [i.two3, i.fiv3, i.one4];
			else if (Note.lastAbsolute == i.fiv3) choices = [i.thr3, i.sev3, i.one4];
			else if (Note.lastAbsolute == i.six3) choices = [i.thr3, i.one4];
			else if (Note.lastAbsolute == i.sev3) choices = [i.thr3, i.fiv3];
			else if (Note.lastAbsolute == i.one4) choices = [i.thr3, i.fiv3];
				 
			harmonyTone = choices[Helpers.randInt(0, choices.length - 1)];
				 
			FlxG.play(harmonyTone, Global.NOTE_MAX_VOLUME * 0.33, pan);		
			Note.lastHarmony = harmonyTone;
			
			MIDI.log(harmonyTone, 0.1);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		// MODE FUNCTIONS //////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		final protected function ionian():void
		{
				var i:Object = Intervals.loadout;
			
					 if (Note.lastRecorded == i.one1) 	_play(i.two1, i.thr1, i.fiv1, i.two2, i.thr2);
				else if (Note.lastRecorded == i.two1)	_play(i.fiv1, i.sev1);
				else if (Note.lastRecorded == i.thr1)	_play(i.fiv1, i.sev1, i.one1);
				else if (Note.lastRecorded == i.for1)	_play(i.thr1, i.fiv1, i.one2);
				else if (Note.lastRecorded == i.fiv1)	_play(i.one1, i.thr1, i.for1, i.six1, i.sev1, i.one2, i.two2, i.thr2);
				else if (Note.lastRecorded == i.six1)	_play(i.one1, i.fiv1, i.sev1, i.one2, i.thr2, i.for2);
				else if (Note.lastRecorded == i.sev1)	_play(i.fiv1, i.one2, i.thr2);
				else if (Note.lastRecorded == i.one2)	_play(i.one1, i.thr1, i.two2, i.thr2, i.fiv2, i.thr3, i.sev2, i.sev1, i.six1);
				else if (Note.lastRecorded == i.two2)	_play(i.one2, i.thr2, i.fiv2, i.sev2);
				else if (Note.lastRecorded == i.thr2)	_play(i.two2, i.for2, i.fiv2, i.sev2, i.one2, i.six1, i.fiv1);
				else if (Note.lastRecorded == i.for2)	_play(i.thr2, i.fiv2, i.one3, i.six1);
				else if (Note.lastRecorded == i.fiv2)	_play(i.one2, i.thr2, i.for2, i.six2, i.sev2, i.thr3, i.sev2, i.sev3, i.two3);
				else if (Note.lastRecorded == i.six2)	_play(i.one2, i.fiv2, i.sev2, i.one3);
				else if (Note.lastRecorded == i.sev2)	_play(i.fiv2, i.one3);
				else if (Note.lastRecorded == i.one3)	_play(i.one2, i.two3, i.thr3, i.fiv3, i.thr2, i.for2, i.sev2, i.six2);
				else if (Note.lastRecorded == i.two3)	_play(i.one3, i.thr3, i.fiv3, i.sev3);
				else if (Note.lastRecorded == i.thr3)	_play(i.fiv2, i.two3, i.for3, i.fiv3, i.sev3, i.one3);
				else if (Note.lastRecorded == i.for3)	_play(i.thr3, i.fiv3, i.one4);	
				else if (Note.lastRecorded == i.fiv3)	_play(i.one3, i.thr3, i.for3, i.six3, i.sev3, i.one4);
				else if (Note.lastRecorded == i.six3)	_play(i.one3, i.fiv3, i.sev3, i.one4);
				else if (Note.lastRecorded == i.sev3)	_play(i.fiv3, i.one4);
				else if (Note.lastRecorded == i.one4)	_play(i.one2, i.thr3, i.for3, i.fiv3, i.sev3, i.one3);
					
												else	_play(i.one2, i.one3);
		}
		
		final protected function dorian():void
		{
			var i:Object = Intervals.loadout;
			
				 if (Note.lastRecorded == i.one1) 	_play(i.two1, i.thr1, i.for1, i.fiv1, i.sev1, i.one2, i.two2, i.thr2, i.for2, i.fiv2);
			else if (Note.lastRecorded == i.two1)	_play(i.fiv1, i.six1, i.sev1);
			else if (Note.lastRecorded == i.thr1)	_play(i.one1, i.for1, i.fiv1, i.six1, i.sev1, i.one2, i.thr2, i.two2, i.fiv2);
			else if (Note.lastRecorded == i.for1)	_play(i.fiv1, i.six1, i.sev1, i.one2, i.thr2);
			else if (Note.lastRecorded == i.fiv1)	_play(i.two1, i.thr1, i.six1, i.sev1, i.one2, i.two2, i.thr2, i.for2, i.fiv2, i.sev2);
			else if (Note.lastRecorded == i.six1)	_play(i.one1, i.for1, i.fiv1, i.sev1, i.one2, i.for2, i.fiv2);
			else if (Note.lastRecorded == i.sev1)	_play(i.thr1, i.fiv1, i.six1, i.one2, i.two2, i.thr2, i.fiv2, i.sev2);
			else if (Note.lastRecorded == i.one2)	_play(i.one1, i.thr1, i.for1, i.fiv1, i.sev1, i.two2, i.thr2, i.fiv2, i.sev2, i.one3, i.two3, i.thr3, i.fiv3);
			else if (Note.lastRecorded == i.two2)	_play(i.fiv1, i.one2, i.thr2, i.fiv2, i.sev2, i.two3);
			else if (Note.lastRecorded == i.thr2)	_play(i.thr1, i.fiv1, i.six1, i.sev1, i.one2, i.two2, i.for2, i.fiv2, i.six2, i.sev2, i.one3, i.thr3);
			else if (Note.lastRecorded == i.for2)	_play(i.thr2, i.fiv2, i.six2, i.sev2, i.two3, i.six1);
			else if (Note.lastRecorded == i.fiv2)	_play(i.thr1, i.fiv1, i.six1, i.sev1, i.one2, i.two2, i.thr2, i.for2, i.six2, i.sev2, i.one3, i.two3, i.thr3);
			else if (Note.lastRecorded == i.six2)	_play(i.for1, i.six1, i.for2, i.fiv2, i.sev2, i.one3, i.thr3, i.for3, i.six3);
			else if (Note.lastRecorded == i.sev2)	_play(i.sev1, i.thr2, i.fiv2, i.six2, i.one3, i.two3, i.thr3, i.fiv3, i.sev3);
			else if (Note.lastRecorded == i.one3)	_play(i.one1, i.fiv1, i.six1, i.one2, i.thr2, i.fiv2, i.six2, i.sev2, i.two3, i.thr3, i.fiv3, i.one4);
			else if (Note.lastRecorded == i.two3)	_play(i.two2, i.fiv2, i.one3, i.thr3, i.fiv3, i.sev3);
			else if (Note.lastRecorded == i.thr3)	_play(i.thr2, i.fiv2, i.six2, i.sev2, i.one3, i.two3, i.for3, i.fiv3, i.six3, i.sev3, i.one4);
			else if (Note.lastRecorded == i.for3)	_play(i.six2, i.thr3, i.fiv3, i.six3, i.sev3);	
			else if (Note.lastRecorded == i.fiv3)	_play(i.thr2, i.fiv2, i.six2, i.sev2, i.one3, i.two3, i.thr3, i.for3, i.six3, i.sev3, i.one4);
			else if (Note.lastRecorded == i.six3)	_play(i.for2, i.six2, i.for3, i.fiv3, i.sev3, i.one4);
			else if (Note.lastRecorded == i.sev3)	_play(i.sev2, i.thr3, i.fiv3, i.six3, i.one4);
			else if (Note.lastRecorded == i.one4)	_play(i.six2, i.one3, i.thr3, i.for3, i.fiv3, i.six3, i.sev3);
				
			else	_play(i.one1, i.one2, i.one3);
		}
		
		final protected function lydian():void
		{
			var i:Object = Intervals.loadout;
			
				 if (Note.lastRecorded == i.one1) 	_play(i.two1, i.thr1, i.fiv1, i.two2, i.thr2);
			else if (Note.lastRecorded == i.two1)	_play(i.fiv1, i.sev1);
			else if (Note.lastRecorded == i.thr1)	_play(i.for1, i.fiv1, i.sev1, i.one1);
			else if (Note.lastRecorded == i.for1)	_play(i.thr1, i.fiv1, i.two2);
			else if (Note.lastRecorded == i.fiv1)	_play(i.one1, i.thr1, i.for1, i.six1, i.sev1, i.one2, i.two2, i.thr2);
			else if (Note.lastRecorded == i.six1)	_play(i.one1, i.for1, i.fiv1, i.sev1, i.one2, i.thr2);
			else if (Note.lastRecorded == i.sev1)	_play(i.fiv1, i.one2, i.thr2);
			else if (Note.lastRecorded == i.one2)	_play(i.one1, i.thr1, i.for1, i.two2, i.thr2, i.fiv2, i.thr3, i.sev2, i.sev1, i.six1);
			else if (Note.lastRecorded == i.two2)	_play(i.one2, i.thr2, i.fiv2, i.sev2);
			else if (Note.lastRecorded == i.thr2)	_play(i.two2, i.for2, i.fiv2, i.sev2, i.one2, i.one3, i.thr1, i.six1, i.fiv1);
			else if (Note.lastRecorded == i.for2)	_play(i.thr2, i.fiv2, i.two3, i.six1);
			else if (Note.lastRecorded == i.fiv2)	_play(i.one2, i.thr3, i.thr2, i.six2, i.sev2, i.two3);
			else if (Note.lastRecorded == i.six2)	_play(i.one2, i.fiv2, i.sev2, i.one3);
			else if (Note.lastRecorded == i.sev2)	_play(i.fiv2, i.one3);
			else if (Note.lastRecorded == i.one3)	_play(i.one2, i.two3, i.thr3, i.fiv3, i.thr2, i.for2, i.sev2, i.six2);
			else if (Note.lastRecorded == i.two3)	_play(i.one3, i.thr3, i.fiv3, i.sev3);
			else if (Note.lastRecorded == i.thr3)	_play(i.fiv2, i.two3, i.for3, i.fiv3, i.sev3, i.one3);
			else if (Note.lastRecorded == i.for3)	_play(i.thr3, i.fiv3, i.six2);	
			else if (Note.lastRecorded == i.fiv3)	_play(i.one3, i.thr3, i.for3, i.six3, i.sev3, i.one4);
			else if (Note.lastRecorded == i.six3)	_play(i.one3, i.fiv3, i.sev3, i.one4);
			else if (Note.lastRecorded == i.sev3)	_play(i.fiv3, i.one4);
			else if (Note.lastRecorded == i.one4)	_play(i.one2, i.thr3, i.for3, i.fiv3, i.sev3, i.one3);
				
										else	_play(i.one2, i.one3);
		}
		
		final protected function mixolydian():void
		{
			var i:Object = Intervals.loadout;
			
				 if (Note.lastRecorded == i.one1) 	_play(i.two1, i.thr1, i.fiv1, i.sev1, i.two2, i.thr2);
			else if (Note.lastRecorded == i.two1)	_play(i.fiv1, i.sev1);
			else if (Note.lastRecorded == i.thr1)	_play(i.for1, i.fiv1, i.sev1, i.one1);
			else if (Note.lastRecorded == i.for1)	_play(i.thr1, i.fiv1, i.sev1, i.two2);
			else if (Note.lastRecorded == i.fiv1)	_play(i.one1, i.thr1, i.for1, i.six1, i.sev1, i.one2, i.two2, i.thr2, i.for2);
			else if (Note.lastRecorded == i.six1)	_play(i.one1, i.fiv1, i.sev1, i.one2, i.thr2);
			else if (Note.lastRecorded == i.sev1)	_play(i.fiv1, i.one2, i.two2, i.thr2);
			else if (Note.lastRecorded == i.one2)	_play(i.one1, i.thr1, i.for1, i.two2, i.thr2, i.fiv2, i.thr3, i.sev2, i.sev1, i.six1);
			else if (Note.lastRecorded == i.two2)	_play(i.one2, i.thr2, i.fiv2, i.sev2);
			else if (Note.lastRecorded == i.thr2)	_play(i.two2, i.for2, i.fiv2, i.sev2, i.one2, i.one3, i.thr1, i.six1, i.fiv1, i.sev1);
			else if (Note.lastRecorded == i.for2)	_play(i.thr2, i.fiv2, i.two3, i.six1, i.sev1, i.sev2);
			else if (Note.lastRecorded == i.fiv2)	_play(i.one2, i.thr3, i.six2, i.thr2, i.sev2, i.two3);
			else if (Note.lastRecorded == i.six2)	_play(i.one2, i.fiv2, i.sev2, i.one3, i.thr3);
			else if (Note.lastRecorded == i.sev2)	_play(i.fiv2, i.one3, i.two2, i.two3, i.thr3, i.sev3, i.sev1);
			else if (Note.lastRecorded == i.one3)	_play(i.one2, i.two3, i.thr3, i.fiv3, i.thr2, i.for2, i.sev2, i.six2);
			else if (Note.lastRecorded == i.two3)	_play(i.one3, i.thr3, i.fiv3, i.sev3);
			else if (Note.lastRecorded == i.thr3)	_play(i.fiv2, i.two3, i.for3, i.fiv3, i.sev3, i.one3);
			else if (Note.lastRecorded == i.for3)	_play(i.thr3, i.fiv3, i.sev3, i.six2, i.sev2);	
			else if (Note.lastRecorded == i.fiv3)	_play(i.one3, i.thr3, i.for3, i.six3, i.sev3, i.one4);
			else if (Note.lastRecorded == i.six3)	_play(i.one3, i.fiv3, i.sev3, i.one4);
			else if (Note.lastRecorded == i.sev3)	_play(i.two3, i.sev2, i.fiv3, i.one4);
			else if (Note.lastRecorded == i.one4)	_play(i.one2, i.thr3, i.fiv3, i.sev3, i.one3);
				
			else	_play(i.one2, i.one3);
		}
		
		final protected function aeolian():void
		{
			var i:Object = Intervals.loadout;
			
				 if (Note.lastRecorded == i.one1) 	_play(i.two1, i.thr1, i.for1, i.fiv1, i.six1, i.sev1, i.one2, i.two2, i.thr2, i.for2, i.fiv2);
			else if (Note.lastRecorded == i.two1)	_play(i.fiv1, i.sev1);
			else if (Note.lastRecorded == i.thr1)	_play(i.one1, i.for1, i.fiv1, i.six1, i.sev1, i.one2, i.thr2, i.two2, i.fiv2);
			else if (Note.lastRecorded == i.for1)	_play(i.fiv1, i.six1, i.sev1, i.one2, i.thr2);
			else if (Note.lastRecorded == i.fiv1)	_play(i.two1, i.thr1, i.six1, i.sev1, i.one2, i.two2, i.thr2, i.for2, i.fiv2);
			else if (Note.lastRecorded == i.six1)	_play(i.one1, i.for1, i.fiv1, i.sev1, i.one2, i.thr2, i.for2, i.fiv2);
			else if (Note.lastRecorded == i.sev1)	_play(i.thr1, i.fiv1, i.six1, i.one2, i.two2, i.thr2, i.fiv2, i.sev2);
			else if (Note.lastRecorded == i.one2)	_play(i.one1, i.thr1, i.for1, i.fiv1, i.six1, i.sev1, i.two2, i.thr2, i.for2, i.fiv2, i.six2, i.sev2, i.one3, i.two3, i.thr3, i.for3, i.fiv3);
			else if (Note.lastRecorded == i.two2)	_play(i.fiv1, i.sev1, i.one2, i.thr2, i.fiv2, i.sev2, i.two3);
			else if (Note.lastRecorded == i.thr2)	_play(i.thr1, i.fiv1, i.six1, i.sev1, i.one2, i.two2, i.for2, i.fiv2, i.six2, i.sev2, i.one3, i.thr3);
			else if (Note.lastRecorded == i.for2)	_play(i.thr2, i.fiv2, i.six2, i.sev2, i.two3, i.six1);
			else if (Note.lastRecorded == i.fiv2)	_play(i.thr1, i.fiv1, i.six1, i.sev1, i.one2, i.two2, i.thr2, i.for2, i.six2, i.sev2, i.one3, i.two3, i.thr3);
			else if (Note.lastRecorded == i.six2)	_play(i.for1, i.six1, i.for2, i.fiv2, i.sev2, i.one3, i.thr3, i.for3, i.six3);
			else if (Note.lastRecorded == i.sev2)	_play(i.sev1, i.thr2, i.fiv2, i.six2, i.one3, i.two3, i.thr3, i.fiv3, i.sev3);
			else if (Note.lastRecorded == i.one3)	_play(i.one1, i.for1, i.fiv1, i.six1, i.one2, i.thr2, i.fiv2, i.six2, i.sev2, i.two3, i.thr3, i.for3, i.fiv3, i.six3, i.one4);
			else if (Note.lastRecorded == i.two3)	_play(i.two2, i.fiv2, i.sev2, i.one3, i.thr3, i.fiv3, i.sev3);
			else if (Note.lastRecorded == i.thr3)	_play(i.thr2, i.fiv2, i.six2, i.sev2, i.one3, i.two3, i.for3, i.fiv3, i.six3, i.sev3, i.one4);
			else if (Note.lastRecorded == i.for3)	_play(i.six2, i.thr3, i.fiv3, i.six3, i.sev3);	
			else if (Note.lastRecorded == i.fiv3)	_play(i.thr2, i.fiv2, i.six2, i.sev2, i.one3, i.two3, i.thr3, i.for3, i.six3, i.sev3, i.one4);
			else if (Note.lastRecorded == i.six3)	_play(i.for2, i.six2, i.for3, i.fiv3, i.sev3, i.one4);
			else if (Note.lastRecorded == i.sev3)	_play(i.sev2, i.thr3, i.fiv3, i.six3, i.one4);
			else if (Note.lastRecorded == i.one4)	_play(i.six2, i.one3, i.thr3, i.for3, i.fiv3, i.six3, i.sev3);
				
			else	_play(i.one1, i.one2, i.one3);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		// MUSIC HELPERS ///////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		final protected function calculatePan():void
		{
			// Convert x position to pan position.
			pan = 2 * ((this.x - Camera.lens.scroll.x) / FlxG.width) - 1;
		}
	}
}