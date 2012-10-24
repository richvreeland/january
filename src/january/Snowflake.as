package january
{
	import flash.utils.getDefinitionByName;	
	import january.snowflakes.*;
	import january.music.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Snowflake extends FlxSprite
	{		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// MUSIC-RELATED DEFINITIONS ///////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////		

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
		/** Type of the last licked snowflake. */
		protected static var lastLickedType: String;
		/** Horizontal modifier for snowflake movement. */
		protected var _windX: int;
		/** Vertical modifier for snowflake movement. */
		protected var _windY: int;
		/** Whether snowflake is a firefly or not, determined by whether it has been licked. */
		protected var _licked: Boolean;
		/** The number of seconds to hold the firefly before it starts to fade. */
		protected var _alphaLifespan: Number;
		
		// Snowflake spawning probabilities
		public static var flakes	: Array = ["Small", "Large", "Octave", "Harmony", "Chord", "Vamp", "Transpose"];
		public static var weights	: Array = [ 80    ,  10    ,  0		 ,	0		,  0	 ,	0	 ,	0  		  ];
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
			var flake : Object = PlayState.snow.recycle(subClass) as subClass;
			flake.spawn(flakeID);		
		}
		
		/** Spawns snowflakes. */
		protected function spawn(flakeType: String, licked: Boolean = false, X: Number = 0, Y: Number = 0):void
		{															
			if (licked == false)
			{
				// POSITION
				if (FlxG.score > 0)
					x = Helpers.randInt(PlayState.camera.scroll.x, PlayState.cameraRails.x + 160);
				else
					x = PlayState.camera.scroll.x + FlxG.width/2;			
				y = height * -1;
			}
			else
			{
				_licked = true;
				
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
				
				_alphaLifespan = Global.ALPHA_LIFESPAN;
				if (PlayState.night.layerOn == true)
				{
						alpha = PlayState.night.alpha;	
					if (alpha >= 0.85)
						alpha = 1;
				}
				else
					alpha = 0;
				
				// TEXT OUTPUT
				PlayState.textOutput.onLick(this);
			}
			
			type = flakeType;
			exists = true;
		}
		
		override public function update():void
		{			
			//////////////
			// MOVEMENT //
			//////////////
			
			if (_licked == false)
			{
					_windX = 5 + (FlxG.score * 0.025);
				if (_windX >= 10)
					_windX = 10;
				velocity.x = (Math.cos(y / _windX) * _windX);
				
				if (FlxG.score == 0)
					velocity.y = 15;
				else
					velocity.y = 5 + (Math.cos(y / 25) * 5) + _windY;
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
			
			if (( y > FlxG.height - 24 && (x + width <= PlayState.player.x || x >= PlayState.player.x + PlayState.player.width)) && x < PlayState.houseRight.x)
				kill();
			else if (y >= FlxG.height - 11 || x < PlayState.camera.scroll.x - width || x > FlxG.worldBounds.width)
				kill();
			
			/////////////
			// EFFECTS //
			/////////////
			
			if (_licked == true)
			{
				if (_alphaLifespan > 0)
					_alphaLifespan -= FlxG.elapsed;
				else
					alpha -= FlxG.elapsed;
				
				if (alpha < 0)
					kill();
			}
		}
		
		/** Called when a Snowflake has been licked. */
		public function onLick():void
		{							
			super.kill();
								
			FlxG.score += _pointValue;
			
			// Gradually introduce flakes
			if (FlxG.score >= 100)	weights[6] = 1;		// 100, Key
			if (FlxG.score >= 20)	weights[5] = 1.5;	// 20, Vamp
			if (FlxG.score >= 50)	weights[4] = 1.5;	// 50, Chord
			if (FlxG.score >= 25)	weights[3] = 3;		// 25, Harmony
			if (FlxG.score >= 10)	weights[2] = 3;		// 10, Octave
			
			// Increase Flake Probability if Player Keeps Licking. Excludes Small, Large, and Key Flakes
			for (var i:int = 2; i <= 5; i++)
			{
				if (type == flakes[i])
				{
					weights[i] += 0.25;
					weights[0] -= 0.25;	
				}			
				// Limit Probability to 12.5%
				if (weights[i] >= 6)
					weights[i] = 6;
			}
			lastLickedType = type;
		}
		
		public function fly():void
		{
			if (FlxG.score > 1)
			{				
				var lickedFlake: Class = getDefinitionByName( "january.snowflakes." + type ) as Class;	
				var firefly: Object = PlayState.fireflies.recycle(lickedFlake) as lickedFlake;
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
			
			// Tell Large flakes ahead of time to toggle loop mode.
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
			
			if (Playback.mode == true)	// REPLAY MODE
			{
				FlxG.play(Playback.sequence[Playback.index] as Class, _volume, _pan);				
				Note.lastAbsolute = Playback.sequence[Playback.index];			
				Playback.index++;
				if (Playback.index > Playback.sequence.length - 1)
					Playback.index = 0;
			}
			else if (Note.lastRecorded != null)	// PLAY MODE
			{				
				Intervals.populate();			
				var modeFunction:Function = this[Mode.current] as Function;
				modeFunction();			
			}
			else // INITIAL SNOWFLAKE
			{
				Intervals.populate();
				Note.initial = Helpers.pickFrom(Intervals.loadout.one2, Intervals.loadout.one3);
				FlxG.play(Note.initial, _volume);
				Note.lastRecorded = Note.initial;
				Note.lastAbsolute = Note.lastRecorded;
				HUD.logNote(_volume, _pan);
				HUD.logMode();
				HUD.logKey();
			}
			
			// Push the last Play note to the Replay Playback.sequence.
			if (type == "Small" || type == "Octave" || type == "Harmony")
			{
				if (Playback.mode == false)  // recording == true
					Playback.sequence.push(Note.lastRecorded as Class);
			}
			else if (type == "Large")
			{								
				// Large flake always gets pushed.
				if (Playback.mode == false )//&& FlxG.score > 1)
					Playback.sequence.push(Note.lastRecorded as Class);
			}
			
			// Limit Playback Sequence Size
			if (Playback.sequence.length > 8)
				Playback.sequence.shift();
		}

		/** Play a note! Takes in class arguments, and will pick one randomly. */	
		final protected function _play(... options):void
		{				
			var random: int = Helpers.randInt(0, options.length - 1);
			var randomNote: Class = options[random] as Class;
			
			// Make Fourth Octave Range quieter, because it gets a bit shrill.
			for (var i:int = Note.DATABASE.length - 13; i < Note.DATABASE.length - 1; i++)
			{
				if (randomNote == Note.DATABASE[i])
					_volume = Helpers.rand(0.05, 0.15);
			}
			
			// Prevent null notes, and various types of repetitions from happening.
			while (randomNote == null || Note.lastAbsolute == randomNote || Note.secondToLastRecorded == randomNote || (lastLickedType == "Harmony" && Note.lastHarmony == randomNote) || (lastLickedType == "Octave" && Note.lastOctave == randomNote))
			{
				random = Helpers.randInt(0, options.length - 1);
				randomNote = options[random] as Class;
			}
				
			FlxG.play(randomNote, _volume, _pan);
			
			// Only log note we just played if we're in play mode.
			if (Playback.mode == false)
			{
				// Log second to Last Play Note, used above, to prevent trills.
				Note.secondToLastRecorded = Note.lastRecorded;
				// Log Last Play Note, used for generative logic.
				Note.lastRecorded = randomNote;
				// Set Last Play Note as the Last Absolute Note, because it is.
				Note.lastAbsolute = Note.lastRecorded;
			}
			
			HUD.logNote(_volume, _pan);
		}
				
		final protected function playChord():void
		{					
			if (type != "Vamp")
			{
				Playback.mode = false;
				Playback.sequence = [];
			}
			
			var chordTones: Array;		
			Intervals.populate();
			var i:Object = Intervals.loadout;
			
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
					[i.sev1, i.one2, i.thr2, i.fiv2],
//					[i.one2, i.fiv2, i.thr3],
//					[i.thr2, i.fiv2, i.one3],
//					[i.fiv2, i.one3, i.thr3],
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
					[i.fiv1, i.one2, i.thr2],
					[i.sev1, i.one2, i.thr2, i.fiv2]
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
					[i.sev1, i.one2, i.thr2, i.fiv2],
					/////////////////////////
					[i.one1, i.six2, i.sev2, i.thr3]
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
					[i.sev1, i.one2, i.thr2, i.fiv2]
					/////////////////////////
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
					[i.fiv1, i.one2, i.thr2],
					[i.sev1, i.one2, i.thr2, i.fiv2]
					/////////////////////////
				);
			}
			else
				chordTones = [i.one1, i.fiv1, i.thr2];
		
			calculatePan();		
			FlxG.play(chordTones[0], 0.15, 0);
			FlxG.play(chordTones[1], 0.15,-1);
			FlxG.play(chordTones[2], 0.15, 1);
			if (chordTones[3] != null)
				FlxG.play(chordTones[3], 0.15, _pan);		
			HUD.logMode(chordTones);
		}
				
		final protected function playOctave():void
		{		
			var octaveTone: Class;
			
			for (var i:int = 0; i <= Note.DATABASE.length - 1; i++)
			{								
				if (Note.lastAbsolute == Note.DATABASE[i])
				{
					while (octaveTone == null)
						octaveTone = Note.DATABASE[i + Helpers.pickFrom(12, -12)] as Class;
				}
			}
			
			FlxG.play(octaveTone, 0.1, _pan, false, true);		
			Note.lastOctave = octaveTone;
		}
			
		final protected function playHarmonyTone():void
		{					
			var harmonyTone: Class = null;
			var choices: Array = [];	
			var i:Object = Intervals.loadout;
			
				 if (Note.lastAbsolute == i.one1)	choices = [i.fiv1, i.thr2];
			else if (Note.lastAbsolute == i.two1)	choices = [i.fiv1, i.sev1];
			else if (Note.lastAbsolute == i.thr1)	choices = [i.fiv1, i.sev1];
			else if (Note.lastAbsolute == i.for1)	choices = [i.six1, i.one2];
			else if (Note.lastAbsolute == i.fiv1)	choices = [i.thr2, i.two2];
			else if (Note.lastAbsolute == i.six1)	choices = [i.one2, i.thr2];
			else if (Note.lastAbsolute == i.sev1)	choices = [i.fiv1, i.thr1];
			else if (Note.lastAbsolute == i.one2)	choices = [i.thr1, i.thr2];
			else if (Note.lastAbsolute == i.two2)	choices = [i.fiv2, i.sev1];
			else if (Note.lastAbsolute == i.thr2)	choices = [i.fiv1, i.one3];
			else if (Note.lastAbsolute == i.for2)	choices = [i.six1, i.six2];
			else if (Note.lastAbsolute == i.fiv2)	choices = [i.thr3, i.sev2];
			else if (Note.lastAbsolute == i.six2)	choices = [i.one3, i.one2];
			else if (Note.lastAbsolute == i.sev2)	choices = [i.thr2, i.fiv2];
			else if (Note.lastAbsolute == i.one3)	choices = [i.thr2, i.thr3];
			else if (Note.lastAbsolute == i.two3)	choices = [i.fiv2, i.fiv3];
			else if (Note.lastAbsolute == i.thr3)	choices = [i.fiv2, i.fiv3];
			else if (Note.lastAbsolute == i.for3)	choices = [i.six2, i.six3];
			else if (Note.lastAbsolute == i.fiv3)	choices = [i.sev2, i.sev3];
			else if (Note.lastAbsolute == i.six3)	choices = [i.one3, i.one4];
			else if (Note.lastAbsolute == i.sev3)	choices = [i.fiv2, i.thr3];
			else if (Note.lastAbsolute == i.one4)	choices = [i.six2, i.thr3];
			
			while (harmonyTone == null)
				harmonyTone = Helpers.randomPull(choices);
				 
			FlxG.play(harmonyTone, 0.1, _pan, false, true);		
			Note.lastHarmony = harmonyTone;
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
				else if (Note.lastRecorded == i.six1)	_play(i.one1, i.fiv1, i.sev1, i.one2, i.thr2);
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
			
				 if (Note.lastRecorded == i.one1) 	_play(i.two1, i.thr1, i.for1, i.fiv1, i.six1, i.sev1, i.one2, i.two2, i.thr2, i.for2, i.fiv2);
			else if (Note.lastRecorded == i.two1)	_play(i.fiv1, i.six1, i.sev1);
			else if (Note.lastRecorded == i.thr1)	_play(i.one1, i.for1, i.fiv1, i.six1, i.sev1, i.one2, i.thr2, i.two2, i.fiv2);
			else if (Note.lastRecorded == i.for1)	_play(i.fiv1, i.six1, i.sev1, i.one2, i.thr2);
			else if (Note.lastRecorded == i.fiv1)	_play(i.two1, i.thr1, i.six1, i.sev1, i.one2, i.two2, i.thr2, i.for2, i.fiv2, i.sev2);
			else if (Note.lastRecorded == i.six1)	_play(i.one1, i.for1, i.fiv1, i.sev1, i.one2, i.for2, i.fiv2);
			else if (Note.lastRecorded == i.sev1)	_play(i.thr1, i.fiv1, i.six1, i.one2, i.two2, i.thr2, i.fiv2, i.sev2);
			else if (Note.lastRecorded == i.one2)	_play(i.one1, i.thr1, i.for1, i.fiv1, i.six1, i.sev1, i.two2, i.thr2, i.for2, i.fiv2, i.six2, i.sev2, i.one3, i.two3, i.thr3, i.for3, i.fiv3);
			else if (Note.lastRecorded == i.two2)	_play(i.fiv1, i.one2, i.thr2, i.fiv2, i.sev2, i.two3);
			else if (Note.lastRecorded == i.thr2)	_play(i.thr1, i.fiv1, i.six1, i.sev1, i.one2, i.two2, i.for2, i.fiv2, i.six2, i.sev2, i.one3, i.thr3);
			else if (Note.lastRecorded == i.for2)	_play(i.thr2, i.fiv2, i.six2, i.sev2, i.two3, i.six1);
			else if (Note.lastRecorded == i.fiv2)	_play(i.thr1, i.fiv1, i.six1, i.sev1, i.one2, i.two2, i.thr2, i.for2, i.six2, i.sev2, i.one3, i.two3, i.thr3);
			else if (Note.lastRecorded == i.six2)	_play(i.for1, i.six1, i.for2, i.fiv2, i.sev2, i.one3, i.thr3, i.for3, i.six3);
			else if (Note.lastRecorded == i.sev2)	_play(i.sev1, i.thr2, i.fiv2, i.six2, i.one3, i.two3, i.thr3, i.fiv3, i.sev3);
			else if (Note.lastRecorded == i.one3)	_play(i.one1, i.for1, i.fiv1, i.six1, i.one2, i.thr2, i.fiv2, i.six2, i.sev2, i.two3, i.thr3, i.for3, i.fiv3, i.six3, i.one4);
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
			
				 if (Note.lastRecorded == i.one1) 	_play(i.two1, i.thr1, i.for1, i.fiv1, i.two2, i.thr2);
			else if (Note.lastRecorded == i.two1)	_play(i.fiv1, i.sev1);
			else if (Note.lastRecorded == i.thr1)	_play(i.for1, i.fiv1, i.sev1, i.one1);
			else if (Note.lastRecorded == i.for1)	_play(i.thr1, i.fiv1, i.two2);
			else if (Note.lastRecorded == i.fiv1)	_play(i.one1, i.thr1, i.for1, i.six1, i.sev1, i.one2, i.two2, i.thr2);
			else if (Note.lastRecorded == i.six1)	_play(i.one1, i.for1, i.fiv1, i.sev1, i.one2, i.thr2);
			else if (Note.lastRecorded == i.sev1)	_play(i.fiv1, i.one2, i.thr2);
			else if (Note.lastRecorded == i.one2)	_play(i.one1, i.thr1, i.for1, i.two2, i.thr2, i.for2, i.fiv2, i.thr3, i.sev2, i.sev1, i.six1);
			else if (Note.lastRecorded == i.two2)	_play(i.one2, i.thr2, i.fiv2, i.sev2);
			else if (Note.lastRecorded == i.thr2)	_play(i.two2, i.for2, i.fiv2, i.sev2, i.one2, i.one3, i.thr1, i.six1, i.fiv1);
			else if (Note.lastRecorded == i.for2)	_play(i.thr2, i.fiv2, i.two3, i.six1);
			else if (Note.lastRecorded == i.fiv2)	_play(i.one2, i.thr3, i.thr2, i.six2, i.sev2, i.two3);
			else if (Note.lastRecorded == i.six2)	_play(i.one2, i.fiv2, i.sev2, i.one3);
			else if (Note.lastRecorded == i.sev2)	_play(i.fiv2, i.one3);
			else if (Note.lastRecorded == i.one3)	_play(i.one2, i.two3, i.thr3, i.for3, i.fiv3, i.thr2, i.for2, i.sev2, i.six2);
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
			
				 if (Note.lastRecorded == i.one1) 	_play(i.two1, i.thr1, i.fiv1, i.six1, i.sev1, i.two2, i.thr2);
			else if (Note.lastRecorded == i.two1)	_play(i.fiv1, i.sev1);
			else if (Note.lastRecorded == i.thr1)	_play(i.for1, i.fiv1, i.sev1, i.one1);
			else if (Note.lastRecorded == i.for1)	_play(i.thr1, i.fiv1, i.sev1, i.two2);
			else if (Note.lastRecorded == i.fiv1)	_play(i.one1, i.thr1, i.for1, i.six1, i.sev1, i.one2, i.two2, i.thr2, i.for2);
			else if (Note.lastRecorded == i.six1)	_play(i.one1, i.fiv1, i.sev1, i.one2, i.thr2);
			else if (Note.lastRecorded == i.sev1)	_play(i.fiv1, i.one2, i.two2, i.thr2);
			else if (Note.lastRecorded == i.one2)	_play(i.one1, i.thr1, i.for1, i.two2, i.thr2, i.fiv2, i.six2, i.thr3, i.sev2, i.sev1, i.six1);
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
			_pan = 2 * ((this.x - PlayState.camera.scroll.x) / FlxG.width) - 1;
		}
	}
}