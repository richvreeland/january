package january.music
{
	import january.*;
	
	public class Scale
	{
		public static const MAJOR_PENTATONIC	: Object = {name: "majorpentatonic", positions: [1, 4, 5]};
		public static const MINOR_PENTATONIC	: Object = {name: "minorpentatonic", positions: [1, 4]};
		public static var isPentatonic: Boolean;
		
		MAJOR_PENTATONIC.logic =	[
			/* 00 one1 */	["six1", "thr1", "fiv1", "one2", "thr2"],
			/* 01 two1 */	["thr1", "one1", ],
			/* 02 thr1 */	["fiv1", "thr2", "one1"],
							["one2", "one3"],
			/* 04 fiv1 */	["one1", "thr1", "six1", "one2", "thr2"],
			/* 05 six1 */	["fiv1", "one2", "two2", "thr2"],
							["one2", "one3"],
			/* 07 one2 */	["one1", "two2", "thr2", "fiv2", "thr3", "six1"],
			/* 08 two2 */	["one2", "thr2"],
			/* 09 thr2 */	["two2", "fiv2", "one3", "one2", "six1", "fiv1"],
							["one2", "one3"],
			/* 11 fiv2 */	["one2", "thr2", "six2", "thr3", "two3"],
			/* 12 six2 */	["fiv2", "one3"],
							["one2", "one3"],
			/* 14 one3 */	["one2", "two3", "thr3", "fiv3", "thr2", "six2"],
			/* 15 two3 */	["one3", "thr3"],
			/* 16 thr3 */	["fiv2", "two3", "fiv3", "one3"],
							["one2", "one3"],
			/* 18 fiv3 */	["one3", "thr3", "six3", "one4"],
			/* 19 six3 */	["fiv3", "one4"],
							["one2", "one3"],
			/* 21 one4 */	["one2", "thr3", "fiv3", "one3"],
			/* 22 else */	["one2", "one3"] ];
		
		MINOR_PENTATONIC.logic = [
			/* 00 one1 */	["thr1", "for1", "fiv1", "sev1", "one2", "thr2", "for2", "fiv2"],
							["one1", "one2", "one3"],
			/* 02 thr1 */	["one1", "for1", "fiv1", "sev1", "one2", "thr2", "fiv2"],
			/* 03 for1 */	["fiv1", "thr1", "thr2"],
			/* 04 fiv1 */	["thr1", "sev1", "one2", "thr2", "for2", "fiv2"],
							["one1", "one2", "one3"],
			/* 06 sev1 */	["fiv1", "one2"],
			/* 07 one2 */	["one1", "thr1", "for1", "fiv1", "sev1", "thr2", "for2", "fiv2", "sev2", "one3", "thr3", "for3", "fiv3"],
							["one1", "one2", "one3"],
			/* 09 thr2 */	["thr1", "fiv1", "sev1", "one2", "for2", "fiv2", "sev2", "one3"],
			/* 10 for2 */	["one2", "thr2", "fiv2"],
			/* 11 fiv2 */	["thr1", "fiv1", "sev1", "one2", "thr2", "for2", "sev2", "one3", "thr3"],
							["one1", "one2", "one3"],
			/* 13 sev2 */	["thr2", "fiv2", "one3"],
			/* 14 one3 */	["one1", "for1", "fiv1", "one2", "thr2", "fiv2", "sev2", "thr3", "for3", "fiv3", "one4"],
							["one1", "one2", "one3"],
			/* 16 thr3 */	["thr2", "fiv2", "sev2", "one3", "for3", "fiv3", "sev3"],
			/* 17 for3 */	["one3", "thr3", "fiv3"],	
			/* 18 fiv3 */	["thr2", "fiv2", "sev2", "one3", "thr3", "for3", "sev3", "one4"],
							["one1", "one2", "one3"],
			/* 20 sev3 */	["fiv3", "one4"],
			/* 21 one4 */	["one3", "thr3", "for3", "fiv3", "sev3"],
			/* 22 else */	["one1", "one2", "one3"] ];
		
		public static function toPentatonic():void
		{
			isPentatonic = !isPentatonic;
			
			if (isPentatonic)
				Game.feedback.show("Pentatonics On");
			else
				Game.feedback.show("Pentatonics Off");
			
			HUD.logMode();
		}
		
	}
}