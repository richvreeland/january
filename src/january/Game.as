package january
{			
	import flash.events.*;
	import flash.utils.*;
	
	import january.music.*;
	import january.snowflakes.*;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Game extends FlxState
	{				
		// SCORE RELATED /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** Initial Score. */
		private static const SCORE_INIT: int = 0;
		/** Scores of various Snowflakes. */
		public static var scores: Object = {"Chord": 0, "Harmony": 0, "Octave": 0, "Transpose": 0, "Vamp": 0};
		/** The highest flake score. */
		public static var mostLickedScore: int = 0;
		/** The type of flake licked most. */
		public static var mostLickedType: String = "";
		
		// TILEMAPS //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** Tilemap of ground tiles. */
		public static var ground: FlxTilemap;
		/** Tilemap of tree tiles. */
		private static var trees: FlxTilemap;
		/** Tilemap of trees in the far distance. */
		private static var backtrees: FlxTilemap;
		
		// SPRITES ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** Sprite of the sky. */
		private static var sky: FlxSprite;
		/** Sprite of the distant mountain. */
		private static var mountain: FlxSprite;		
		/** The player sprite. */
		public static var player: Player;
		/** All of the snowflakes. */
		public static var snow: FlxGroup;	
		
		// TEXT-RELATED //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** The feedback text for secret features. */
		public static var feedback: Text;
		
		// TIME-RELATED ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** The minimum amount of time allowed between Snowflake spawns. */
		public static const BLIZZARD: int = 50;
		/** The initial spawn rate for snowflakes. */
		private static const SHOWER: int = 250;
		/** The slowest spawn rate. */
		private static const FLURRY: int = 1000;
		/** The amount of time between Snowflake spawns. */
		public static var spawnRate: int = SHOWER;
		/** Rate at which the time between Snowflake spawns is decremented by. */
		private static const SPAWNRATE_DECREMENTER: int = 5;
		/** The timer for determining when to spawn snowflakes. */
		private static var spawnTimer: FlxDelay;
		
		/** The timer used to create separation between notes. */
		public static var flamTimer: FlxDelay;
		/** The notes to be flammed at any given time. */
		public static var flamNotes: Array = [];
		/** The time between flammed notes. */
		private static var flamRate: int = 25;
		/** Used to count through the notes in a chord/etc to be flammed. */
		private static var flamCounter: int = 0;
		
		/** Whether or not game is on autopilot or not. */
		public static var onAutoPilot: Boolean;
		public static var autoPilotMovement: String = "Right";
		/** Whether or not game is in improv mode. */
		public static var inImprovMode: Boolean;
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** Initialize game, create and add everything. */
		override public function create():void
		{					
			FlxG.score = SCORE_INIT;
			FlxG.volume = 1;
			FlxG.playMusic(Ambience, Note.MAX_VOLUME / 5); FlxG.music.fadeIn(2);
			FlxG.sounds.maxSize = 32;
			
			// Set Channel 1 Instrument to Guitar
			MIDI.trackEvents.push(0);
			MIDI.trackEvents.push(193);
			MIDI.trackEvents.push(24);
			
			//	Build World		
				sky = new FlxSprite(0, 0, Asset.SKY);
				sky.scrollFactor.x = 0;
				sky.velocity.x = -2;
			add(sky);
				mountain = new FlxSprite(FlxG.width - 70, 72, Asset.MOUNTAIN);
			add(mountain);	
				backtrees = new FlxTilemap();
				backtrees.y = 89;
				backtrees.loadMap(new Asset.BACKTREE_MAP , Asset.BACK_TREES, 13, 7);
			add(backtrees);				
				ground = new FlxTilemap();
				ground.loadMap(new Asset.LEVEL_MAP, Asset.GROUND, 16);
				ground.x = 0;
			add(ground);	
				trees = new FlxTilemap();
				trees.y = 83;
				trees.scrollFactor.x = 0.25;
				trees.loadMap(new Asset.TREE_MAP, Asset.TREES, 51, 13);
			add(trees);
			
			//	Set World Bounds, for optimization purposes.
			FlxG.worldBounds.x = 0;
			FlxG.worldBounds.width = FlxG.width;
			FlxG.worldBounds.y = 78;
			FlxG.worldBounds.height = FlxG.height - FlxG.worldBounds.y;	
			
			// Add Feedback Text
			feedback = new Text(); add(feedback);
			
			// Draw Player
			player = new Player(); add(player);
			
			// Create Snow
			snow = new FlxGroup(); add(snow);
			
			// Add HUD
			HUD.init(); add(HUD.row1); add(HUD.row2); add(HUD.row3);
			
			add(HUD.midiButton);
			
			// Start Timers
			spawnTimer = new FlxDelay(0);
			spawnTimer.start();
			
			flamTimer = new FlxDelay(flamRate);
			
			// Set Initial Mode to Ionian or Aeolian.
			Mode.index = Helper.pickFrom(0, 4);
			Mode.init();
			
			super.create();
		}
		
		/** Called every frame. */
		override public function update():void
		{																	
			// Timer callback, used to flam out notes in chords, etc. Awesome!
			flamTimer.callback = function():void
			{
				if (flamNotes[0] != null && flamCounter <= flamNotes.length - 1)
				{
					var note:FlxSound = flamNotes[flamCounter];
					note.play();
					
					var classToLog:Class;
					var volToLog:Number;
					
					// Always pass the primary timbre to the MIDI logging system.
					if (getQualifiedClassName(note.classType).substr(0,1) == "_")
					{
						classToLog = getDefinitionByName(getQualifiedClassName(note.classType).substr(1)) as Class;
						volToLog = note.volume * Snowflake._volumeMod;
					}
					else
					{
						classToLog = note.classType;
						volToLog = note.volume;
					}
						
					MIDI.log(classToLog, volToLog);
					flamCounter++;
					flamTimer.reset(flamRate);
				}
				else
				{
					flamRate = Helper.randInt(25, 75);		// Fluctuate the arpeggio rate.
					flamCounter = 0;
					flamNotes = [];
					flamTimer.abort();
				}
			}
			
			// Spawn snowflakes when timer expires.
			spawnTimer.callback = function():void
			{						
				if (spawnRate <= BLIZZARD)
					spawnRate = BLIZZARD;
					
				spawnTimer.reset(spawnRate);			
				Snowflake.manage();
				
				if (onAutoPilot)
				{
					if (player.tongueUp)
					{
						if (Helper.chanceRoll(2))
							player.tongueUp = !player.tongueUp;
					}
					else
					{
						if (Helper.chanceRoll(10))
								player.tongueUp = true;
					}
					
					if (Helper.chanceRoll(2))
						autoPilotMovement = Helper.pickFrom("Left", "Right", "Still"); 
				}
			}
							
			super.update();
			
			// Loop Sky Background
			if (sky.x < -716) sky.x = 0;
			
			// Collision Check
			if (player.tongueUp) FlxG.overlap(snow, player, onLick);
			
			// Key input checks for advanced features!.
			if (FlxG.keys.justPressed("PLUS"))		moreSnow();
			if (FlxG.keys.justPressed("MINUS"))		lessSnow();
			
			if (FlxG.keys.justPressed("K"))			Key.cycle();
			if (FlxG.keys.justPressed("COMMA"))		Mode.cycle("Left");
			if (FlxG.keys.justPressed("PERIOD"))	Mode.cycle("Right");
			if (FlxG.keys.justPressed("SLASH")) 	Scale.toPentatonic();
			if (FlxG.keys.justPressed("P")) 		Pedal.toggle();
			
			if (FlxG.keys.justPressed("LBRACKET"))	Playback.cycle("Left");
			if (FlxG.keys.justPressed("RBRACKET"))	Playback.cycle("Right");
			if (FlxG.keys.justPressed("ENTER")) 	Playback.polarity();
			if (FlxG.keys.justPressed("BACKSLASH"))	Playback.resetRestart();
			
			if (FlxG.keys.justPressed("SHIFT"))		Playback.staccato();
			if (FlxG.keys.justPressed("I"))			improvise();
			if (FlxG.keys.justPressed("ZERO"))		autoPilot();
			
			if (FlxG.keys.justPressed("H"))			HUD.toggle();
			if (FlxG.keys.justPressed("M"))			HUD.midi();
			
			// Keep MIDI Timer in check, to get appropriate time values for logging.
			if (Note.lastAbsolute != null)
				MIDI.timer += FlxG.elapsed;
			if (MIDI.logged == true)
			{
				MIDI.timer = 0;
				MIDI.logged = false;
			}
		}
		
		/**
		 * Called when the player's tongue is up, and hits a snowflake.
		 *  
		 * @param SnowRef		The Snowflake licked.
		 * @param PlayerRef		The Player sprite.
		 * 
		 */
		public function onLick(SnowRef: Snowflake, PlayerRef: Player):void
		{									
			SnowRef.onLick();
			
			if (Playback.mode == "Repeat")
				feedback.onLick(SnowRef);

			spawnRate -= SPAWNRATE_DECREMENTER;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// ADVANCED FEATURES /////////////////////////////////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private static function moreSnow():void
		{
			if (spawnRate <= SHOWER)
			{
				spawnRate = BLIZZARD;
				feedback.show("Blizzard");
			}
			else
			{
				spawnRate = SHOWER;
				feedback.show("Shower");
			}
		}
		
		private static function lessSnow():void
		{			
			if (spawnRate < SHOWER)
			{
				spawnRate = SHOWER;
				feedback.show("Shower");
			}
			else
			{
				spawnRate = FLURRY;
				feedback.show("Flurry");
			}
		}
		
		private static function autoPilot():void
		{
			onAutoPilot = !onAutoPilot;
			
			if (onAutoPilot)
			{
				feedback.show("Auto Pilot On");
				player.tongueUp = true;
			}
			else
			{
				feedback.show("Auto Pilot Off");
				player.tongueUp = false;
			}
		}
		
		private function improvise():void
		{
			inImprovMode = !inImprovMode;
			
			if (inImprovMode)
				feedback.show("Improv Mode On");
			else
				feedback.show("Improv Mode Off");
		}
	}
}