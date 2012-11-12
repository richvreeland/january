package january
{
	import january.snowflakes.*;
	
	public class Global
	{		
		// VARIABLES ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** Whether or not the player has exited the house. */
		public static var newGame: Boolean = false;
		/** The amount of time between Snowflake spawns. */
		public static var spawnRate: int = 25;//275
		/** Scores of various Snowflakes. */
		public static var scores: Object = {"Large": 0, "Chord": 0, "Harmony": 0, "Octave": 0, "Transpose": 0, "Vamp": 0};
		/** The highest flake score. */
		public static var mostLickedScore: int = 0;
		/** The type of flake licked most. */
		public static var mostLickedType: String = "";
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** Initial Score. */
		public static const SCORE_INIT: int = 1;
		/** Initial Camera X Position. */
		public static const CAMERA_X_INIT: int = 420;	//420 for Start. //2450 for End of Level.		
		/** Initial Player X Position. */
		public static const PLAYER_X_INIT: int = CAMERA_X_INIT + 25;
		/** Time before first Snowflake spawns. */
		public static const	SPAWNRATE_INIT: int = 6000;
		/** Time between Snowflake spawns when Score is Zero. */
		public static const SPAWNRATE_ATZERO: int = 12000;
		/** Time between Snowflake spawns after Exiting the House. */
		public static const SPAWNRATE_ATEXITHOUSE: int = 8000;
		/** Rate at which the time between Snowflake spawns is decremented by. */
		public static const SPAWNRATE_DECREMENTER: int = 6;
		/** The minimum amount of time allowed between Snowflake spawns. */
		public static const	SPAWNRATE_MINIMUM: int = 25;
		/** The number of seconds to hold alpha before beginning to fade. */
		public static const ALPHA_LIFESPAN: int = 1;
		/** The default color for fireflies in Record mode. */
		public static const RECORD_COLOR: uint = 0xFA0013;
		/** The default color for fireflies in Playback mode. */
		public static const PLAYBACK_COLOR: uint = 0x64E000;
		/** The loudest possible volume for a snowflake tone. */
		public static const NOTE_MAX_VOLUME: Number	= 0.75; //0.3
	}
}