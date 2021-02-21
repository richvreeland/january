# January

This (original) version of January is no longer being updated. Development continues at https://github.com/richvreeland/hf-january, where desktop builds are available.

January is a generative music tool. You walk around and lick snowflakes with your tongue, and the tool uses a set of rules to make choices about what the next note (or notes) will be. It also gives the player freedom to play various types of chords, and choose when and how notes will be played. There are a bunch of advanced features, which you can explore below. It was made with [Flixel](http://www.flixel.org) and Flash/AS3. Feel free to shoot me an e-mail if you'd like to know more.

Controls: Arrow Keys or WASD. Look Up!

## Compatibility

January was created in Adobe Flash Builder 4.6.

If you are using 4.7, Brian Kelly has graciously created a fork that will work off the bat: https://github.com/spilth/january/tree/flash-builder-4.7

We're working on setting this repository up to work in non Flash Builder settings by default, so people don't have to go out and buy Flash Builder. But in the interim, you could run the Flash Builder 4.6 trial: http://www.adobe.com/support/flex/downloads_updaters.html#flex4_6_trial

## Advanced Controls

- `[` and `]` - Use Brackets to Toggle Through Game Modes.
  - "Write" - default mode
  - "Repeat" - repeat up to the last 8 notes from Write mode.
  - "Detour" - Generate notes freely without effecting your Repeat sequence.
- `H` - Bring up the HUD, which shows note information.
- `+` and `-` - Plus and minus will increase or decrease the amount of snowfall.
- `K` - Change the Musical Key!
- `<` and `>` - Toggle through modes (Ionian, Dorian, Lydian, Mixolydian, Aeolian)
- `SHIFT` - Change the note lengths (Full, Half, or Random)
- `P` - Pedal Point Mode. Adds a note underneath every regular note (not chords).
- `/` - Pentatonics Mode! Turn the current scale/mode into its Pentatonic version.
- `M` - Save your performance to a MIDI file!
- `\` - in Write mode, resets the sequence you're creating for Repeat mode. In Repeat mode, starts the sequence back at the beginning.
- `I` - Improv Move - January will periodically change things for you!
- `0` - Auto Pilot, if you want to see/hear the tool play itself!
- `CTRL` - Hold this to move really fast! (aka cheat)

---

I've made this open source in hopes that people will play with it and create interesting variations on the original code here. There are some features that could easily be expanded on (ie. Adding a Phrygian mode) but I felt it time to step away and let others have a go at it. Enjoy!

