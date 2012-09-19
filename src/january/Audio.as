package january
{	
	import january.snowflakes.*;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Audio
	{
		// Import Music Notes, in the Key of G Major Hexatonic
		[Embed(source="../assets/audio/notes/0_3.mp3")]  public static var SubThird:Class;		//B0
		[Embed(source="../assets/audio/notes/1_5.mp3")]  public static var SubFifth:Class;		//D0
		[Embed(source="../assets/audio/notes/2_6.mp3")]  public static var SubSixth:Class;		//E0
		[Embed(source="../assets/audio/notes/3_7.mp3")]  public static var SubSeventh:Class;	//F#0
		[Embed(source="../assets/audio/notes/4_1.mp3")]  public static var Root:Class;			//G1
		[Embed(source="../assets/audio/notes/5_2.mp3")]  public static var Second:Class;		//A1
		[Embed(source="../assets/audio/notes/6_3.mp3")]  public static var Third:Class;			//B1
		[Embed(source="../assets/audio/notes/7_5.mp3")]  public static var Fifth:Class;			//D1
		[Embed(source="../assets/audio/notes/8_6.mp3")]  public static var Sixth:Class;			//E1
		[Embed(source="../assets/audio/notes/9_7.mp3")]  public static var Seventh:Class;		//F#1
		[Embed(source="../assets/audio/notes/10_1.mp3")] public static var Octave:Class;		//G2
		[Embed(source="../assets/audio/notes/11_2.mp3")] public static var Ninth:Class;			//A2
		[Embed(source="../assets/audio/notes/12_3.mp3")] public static var UpperThird:Class;	//B2
		[Embed(source="../assets/audio/notes/13_5.mp3")] public static var UpperFifth:Class;	//D2
		[Embed(source="../assets/audio/notes/14_6.mp3")] public static var Thirteenth:Class;	//E2
		[Embed(source="../assets/audio/notes/15_7.mp3")] public static var UpperSeventh:Class;	//F#2
		[Embed(source="../assets/audio/notes/16_1.mp3")] public static var DoubleOctave:Class;	//G3
		[Embed(source="../assets/audio/notes/17_2.mp3")] public static var DoubleNinth:Class;	//A3
		
		public static var notes: Array = [SubThird, SubFifth, SubSixth, SubSeventh, Root, Second, Third, Fifth, Sixth, Seventh, Octave, Ninth, UpperThird, UpperFifth, Thirteenth, UpperSeventh, DoubleOctave, DoubleNinth];
		
		public static var keys: Array = ["E Minor", "G Major"];
		public static var keyID: int;	
		public static var previous: Class;
		
		/** Volume for the Next Tone. */
		private static var _volume: Number;
		
		/** Pan Value for the Next Tone. */
		private static var _pan: Number;
		
		/** The very first tone that's triggered. */
		private static var _initial: Class = notes[Helpers.randInt(0, notes.length - 1)];
		
		public static function generate(noteVolume: Number = 0, panX : Number = 0):void
		{																
			_volume = noteVolume;
			
			// Convert X position to pan position.
			_pan = 2 * (panX / FlxG.width) - 1;
						
			if (keyID == 0 || _initial == SubSixth || _initial == Sixth || _initial == Thirteenth)
			{
				keyID = 0;
				eMinor();
			} 	
			else
			{
				keyID = 1;
				gMajor();
			}
			
			if (previous == null)
			{
				FlxG.play(_initial, 0.5);
				previous = _initial;
			}
			
			FlxG.log("key: " + keyID);
			
		}
		
		private static function generateNextInterval(... options):void
		{			
			
			var _random: int = Helpers.randInt(0, options.length - 1);
			var _randomNote: Class = options[_random];
			
			if (_volume == 0)
				_volume = Helpers.rand(0.5, 1);			
						
			FlxG.play(_randomNote, _volume, Helpers.rand(-1, 1));
			
			previous = _randomNote;
		}
		
		public static function chord():void
		{			
			var _chordTone1: Class;
			var _chordTone2: Class;
			
			if (previous == SubThird)
			{
				_chordTone1 = SubFifth;
				_chordTone2 = Second;
			}
			else if (previous == SubFifth)
			{
				_chordTone1 = SubThird;
				_chordTone2 = SubSeventh;
			}
			else if (previous == SubSixth)
			{
				_chordTone1 = SubFifth;
				_chordTone2 = Root;
			}
			else if (previous == SubSeventh)
			{
				_chordTone1 = SubSixth;
				_chordTone2 = Second;
			}
			else if (previous == Root)
			{
				_chordTone1 = SubSeventh;
				_chordTone2 = Third;
			}
			else if (previous == Second)
			{
				_chordTone1 = Root;
				_chordTone2 = Fifth;
			}
			else if (previous == Third)
			{
				_chordTone1 = Second;
				_chordTone2 = Sixth;
			}
			else if (previous == Fifth)
			{
				_chordTone1 = Third;
				_chordTone2 = Seventh;
			}
			else if (previous == Sixth)
			{
				_chordTone1 = Fifth;
				_chordTone2 = Octave;
			}
			else if (previous == Seventh)
			{
				_chordTone1 = Sixth;
				_chordTone2 = Ninth;
			}
			else if (previous == Octave)
			{
				_chordTone1 = Seventh;
				_chordTone2 = UpperThird;
			}
			else if (previous == Ninth)
			{
				_chordTone1 = Octave;
				_chordTone2 = UpperFifth;
			}
			else if (previous == UpperThird)
			{
				_chordTone1 = Second;
				_chordTone2 = Sixth;
			}
			else if (previous == UpperFifth)
			{
				_chordTone1 = Third;
				_chordTone2 = Seventh;
			}
			else if (previous == Thirteenth)
			{
				_chordTone1 = Fifth;
				_chordTone2 = Octave;
			}
			else if (previous == UpperSeventh)
			{
				_chordTone1 = Sixth;
				_chordTone2 = Ninth;
			}
			else if (previous == DoubleOctave)
			{
				_chordTone1 = Seventh;
				_chordTone2 = UpperThird;
			}
			else if (previous == DoubleNinth)
			{
				_chordTone1 = Octave;
				_chordTone2 = UpperFifth;
			}
			
			FlxG.play(_chordTone1, Helpers.rand(0.5, 0.75), _pan);
			FlxG.play(_chordTone2, Helpers.rand(0.5, 0.75), _pan);
		}
		
		public static function octave():void
		{			
			var _octaveTone: Class;
			
				 if (previous == SubThird)		_octaveTone = Third;
			else if (previous == SubFifth)		_octaveTone = Fifth;
			else if (previous == SubSixth)		_octaveTone = Sixth;
			else if (previous == SubSeventh)	_octaveTone = Seventh;
			else if (previous == Root)			_octaveTone = Octave;
			else if (previous == Second)		_octaveTone = Ninth;
			else if (previous == Third)			_octaveTone = UpperThird;
			else if (previous == Fifth)			_octaveTone = UpperFifth;
			else if (previous == Sixth)			_octaveTone = Thirteenth;
			else if (previous == Seventh)		_octaveTone = UpperSeventh;
			else if (previous == Octave)		_octaveTone = DoubleOctave;
			else if (previous == Ninth)			_octaveTone = DoubleNinth;
			else if (previous == UpperThird)	_octaveTone = Third;
			else if (previous == UpperFifth)	_octaveTone = Fifth;
			else if (previous == Thirteenth)	_octaveTone = Sixth;
			else if (previous == UpperSeventh)	_octaveTone = Seventh;
			else if (previous == DoubleOctave)	_octaveTone = Octave;
			else if (previous == DoubleNinth) 	_octaveTone = Ninth;
			
			FlxG.play(_octaveTone, Helpers.rand(0.5, 0.75), _pan);
		}
		
		private static function eMinor():void
		{
			if (previous == SubThird)
			{
				generateNextInterval(SubFifth, Fifth, UpperFifth);
			}
			else if (previous == SubFifth)
			{
				generateNextInterval(SubSeventh, Seventh);
			}
			else if (previous == SubSixth)
			{
				generateNextInterval(Root, Third, Fifth, Seventh);
			}
			else if (previous == SubSeventh)
			{
				generateNextInterval(Root, Second, Fifth);
			}
			else if (previous == Root)
			{
				generateNextInterval(SubThird, SubFifth, SubSixth, SubSeventh, Second, Third, Fifth, Sixth, Seventh, Ninth, UpperThird, UpperFifth);
			}
			else if (previous == Second)
			{
				generateNextInterval(Third, Sixth, SubFifth);
			}
			else if (previous == Third)
			{
				generateNextInterval(Second, Seventh, Octave, Root, SubSixth, SubFifth);
			}
			else if (previous == Fifth)
			{
				generateNextInterval(SubSeventh, Seventh, Second, Third);
			}
			else if (previous == Sixth)
			{
				generateNextInterval(Octave, Seventh, Fifth, UpperThird);
			}
			else if (previous == Seventh)
			{
				generateNextInterval(Fifth, Third, Second, Octave, Ninth, UpperThird);
			}
			else if (previous == Octave)
			{
				generateNextInterval(UpperThird, Third, UpperSeventh, Thirteenth);
			}
			else if (previous == Ninth)
			{
				generateNextInterval(Fifth, Seventh, Octave, UpperSeventh);
			}
			else if (previous == UpperThird)
			{
				generateNextInterval(DoubleOctave, SubSixth, Octave);
			}
			else if (previous == UpperFifth)
			{
				generateNextInterval(UpperThird, UpperSeventh);
			}
			else if (previous == Thirteenth)
			{
				generateNextInterval(DoubleOctave, UpperSeventh);
			}
			else if (previous == UpperSeventh)
			{
				generateNextInterval(UpperFifth, DoubleOctave);
			}
			else if (previous == DoubleOctave)
			{
				generateNextInterval(Octave, DoubleNinth, UpperThird);
			}
			else if (previous == DoubleNinth)
			{
				generateNextInterval(Ninth, UpperFifth);
			}
		}
		
		private static function gMajor():void
		{
			if (previous == SubThird)
			{
				generateNextInterval(SubFifth, Fifth, UpperFifth);
			}
			else if (previous == SubFifth)
			{
				generateNextInterval(SubSeventh, Seventh);
			}
			else if (previous == SubSixth)
			{
				generateNextInterval(Root, Fifth);
			}
			else if (previous == SubSeventh)
			{
				generateNextInterval(Root, Second);
			}
			else if (previous == Root)
			{
				generateNextInterval(SubFifth, Second, Third);
			}
			else if (previous == Second)
			{
				generateNextInterval(Fifth, SubFifth, UpperFifth);
			}
			else if (previous == Third)
			{
				generateNextInterval(SubSeventh, Second, Fifth, Sixth, Seventh);
			}
			else if (previous == Fifth)
			{
				generateNextInterval(SubSeventh, Seventh);
			}
			else if (previous == Sixth)
			{
				generateNextInterval(Second, Fifth, Seventh, UpperThird);
			}
			else if (previous == Seventh)
			{
				generateNextInterval(Fifth, Octave, Ninth);
			}
			else if (previous == Octave)
			{
				generateNextInterval(UpperThird, Third, SubThird);
			}
			else if (previous == Ninth)
			{
				generateNextInterval(Fifth, Octave, UpperFifth, UpperSeventh);
			}
			else if (previous == UpperThird)
			{
				generateNextInterval(SubSixth, Octave, Sixth, Thirteenth);
			}
			else if (previous == UpperFifth)
			{
				generateNextInterval(UpperThird, UpperSeventh);
			}
			else if (previous == Thirteenth)
			{
				generateNextInterval(UpperSeventh);
			}
			else if (previous == UpperSeventh)
			{
				generateNextInterval(UpperFifth, DoubleOctave);
			}
			else if (previous == DoubleOctave)
			{
				generateNextInterval(Octave, DoubleNinth, UpperThird);
			}
			else if (previous == DoubleNinth)
			{
				generateNextInterval(Ninth, UpperFifth);
			}
		}
		
	}
	
}