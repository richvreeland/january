package january.music
{
	public class Note
	{
		/** The very first note that's triggered. */
		public static var initial: Class = null;
		/** The last Play Note played. */
		public static var lastRecorded: Class = null;		
		/** The second to last Play Note played. */
		public static var secondToLastRecorded: Class = null;	
		/** The last Note played, regardless of whether in Play/Replay Mode **/
		public static var lastAbsolute: Class = null;
		/** The last Octave Note played. */
		public static var lastOctave: Class = null;
		/** The last Harmony Note played. */
		public static var lastHarmony: Class = null;
		
		// Embed the notes!
		[Embed(source="../assets/audio/notes/C1.mp3")]	public static const C1:Class;
		[Embed(source="../assets/audio/notes/C#1.mp3")]	public static const Cs1:Class;
		[Embed(source="../assets/audio/notes/D1.mp3")]	public static const D1:Class;
		[Embed(source="../assets/audio/notes/D#1.mp3")]	public static const Ds1:Class;
		[Embed(source="../assets/audio/notes/E1.mp3")]	public static const E1:Class;
		[Embed(source="../assets/audio/notes/F1.mp3")]	public static const F1:Class;
		[Embed(source="../assets/audio/notes/F#1.mp3")]	public static const Fs1:Class;
		[Embed(source="../assets/audio/notes/G1.mp3")]	public static const G1:Class;
		[Embed(source="../assets/audio/notes/G#1.mp3")]	public static const Gs1:Class;
		[Embed(source="../assets/audio/notes/A1.mp3")]	public static const A1:Class;
		[Embed(source="../assets/audio/notes/A#1.mp3")]	public static const As1:Class;
		[Embed(source="../assets/audio/notes/B1.mp3")]	public static const B1:Class;
		[Embed(source="../assets/audio/notes/C2.mp3")]	public static const C2:Class;
		[Embed(source="../assets/audio/notes/C#2.mp3")]	public static const Cs2:Class;
		[Embed(source="../assets/audio/notes/D2.mp3")]	public static const D2:Class;
		[Embed(source="../assets/audio/notes/D#2.mp3")]	public static const Ds2:Class;
		[Embed(source="../assets/audio/notes/E2.mp3")]	public static const E2:Class;
		[Embed(source="../assets/audio/notes/F2.mp3")]	public static const F2:Class;
		[Embed(source="../assets/audio/notes/F#2.mp3")]	public static const Fs2:Class;
		[Embed(source="../assets/audio/notes/G2.mp3")]	public static const G2:Class;
		[Embed(source="../assets/audio/notes/G#2.mp3")]	public static const Gs2:Class;
		[Embed(source="../assets/audio/notes/A2.mp3")]	public static const A2:Class;
		[Embed(source="../assets/audio/notes/A#2.mp3")]	public static const As2:Class;
		[Embed(source="../assets/audio/notes/B2.mp3")]	public static const B2:Class;
		[Embed(source="../assets/audio/notes/C3.mp3")]	public static const C3:Class;
		[Embed(source="../assets/audio/notes/C#3.mp3")]	public static const Cs3:Class;
		[Embed(source="../assets/audio/notes/D3.mp3")]	public static const D3:Class;
		[Embed(source="../assets/audio/notes/D#3.mp3")]	public static const Ds3:Class;
		[Embed(source="../assets/audio/notes/E3.mp3")]	public static const E3:Class;
		[Embed(source="../assets/audio/notes/F3.mp3")]	public static const F3:Class;
		[Embed(source="../assets/audio/notes/F#3.mp3")]	public static const Fs3:Class;
		[Embed(source="../assets/audio/notes/G3.mp3")]	public static const G3:Class;
		[Embed(source="../assets/audio/notes/G#3.mp3")]	public static const Gs3:Class;
		[Embed(source="../assets/audio/notes/A3.mp3")]	public static const A3:Class;
		[Embed(source="../assets/audio/notes/A#3.mp3")]	public static const As3:Class;
		[Embed(source="../assets/audio/notes/B3.mp3")]	public static const B3:Class;
		[Embed(source="../assets/audio/notes/C4.mp3")]	public static const C4:Class;
		[Embed(source="../assets/audio/notes/C#4.mp3")]	public static const Cs4:Class;
		[Embed(source="../assets/audio/notes/D4.mp3")]	public static const D4:Class;
		[Embed(source="../assets/audio/notes/D#4.mp3")]	public static const Ds4:Class;
		[Embed(source="../assets/audio/notes/E4.mp3")]	public static const E4:Class;
		[Embed(source="../assets/audio/notes/F4.mp3")]	public static const F4:Class;
		[Embed(source="../assets/audio/notes/F#4.mp3")]	public static const Fs4:Class;
		[Embed(source="../assets/audio/notes/G4.mp3")]	public static const G4:Class;
		[Embed(source="../assets/audio/notes/G#4.mp3")]	public static const Gs4:Class;
		[Embed(source="../assets/audio/notes/A4.mp3")]	public static const A4:Class;
		[Embed(source="../assets/audio/notes/A#4.mp3")]	public static const As4:Class;
		[Embed(source="../assets/audio/notes/B4.mp3")]	public static const B4:Class;
		
		/** An array of all of the Note sounds. */
		public static const DATABASE: Array /* of Class */ = [C1, Cs1, D1, Ds1, E1, F1, Fs1, G1, Gs1, A1, As1, B1, C2, Cs2, D2, Ds2, E2, F2, Fs2, G2, Gs2, A2, As2, B2, C3, Cs3, D3, Ds3, E3, F3, Fs3, G3, Gs3, A3, As3, B3, C4, Cs4, D4, Ds4, E4, F4, Fs4, G4, Gs4, A4, As4, B4];
	}
}