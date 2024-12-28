                 Knuckles the Echidna in Sonic the Hedgehog Rev 01

This is a modification of Sonic 1 to allow play as Knuckles. It was created using 
Hivebrain's Sonic 1 disassembly, and my own Sonic and Knuckles "upmem" disassembly.
It not only contains a fully playable Knuckles, but also a new title screen, new
demos, Knuckles in the continue and ending sequences, and Knuckles equivalants
of all other sprites that refer to the character's identity. Testing on actual
hardware was conducted by LocalH

This modification was created by Stealth (MStealthA@aol.com)
http://stealth.emulationzone.org/



Data Modifications and Tools/Credits:

-SonED2 used to trace over life icon, level sign, continue icon, title logo art,
 and large ending sequence sprite to make suitable for S1 Sonic palette
-Patcher program made to patch Knuckles art data to use S1 Sonic palette, with
 manually-created table
-Mappings conversion program made to convert S2K mappings to S1 format
-"Knuckles the Echidna In" for ending manually drawn and converted to tiles by
 SonED2
-New frames for Knuckles in ending made by Liz, converted to tiles by SonED2
-Mappings for "Knuckles Has Passed" and new ending sprites created with Lost
 Library
-Some levels slightly modified to prevent impasses and errors that wouldn't
 "realistically" happen, using SonED2
-New demos created with info from drx on the built-in demo recorder, and a demo
 playback bugfix created by me


Revision 0:

- First release

Revision 1:

- Fixed player sprite tile loading to accomodate for all of Knuckles' tiles on
  all animations
- Fixed a bug that allowed player to climb down through floors when solidity on
  the wall didn't end
- Fixed a bug that freaked out the camera between a boss and the end of the level
- Fixed a bug that freaked out the camera during the title screen after the game
  ended under certain circumstances
- Fixed a bug that allowed immediate skidding after hitting a horizontal spring
- Fixed a bug that disallowed spindashing through monitors that are right beside
  the player
- Fixed a bug that allowed running/skidding on waterslides by pressing left/right
- Fixed a bug that disallowed panning the screen up/down (look up/down)
- Fixed a bug that sent player to the right after striking a pushable block when
  gliding left
- Fixed a bug that caused the camera to pan to the right if the player is too far
  to the left
- Fixed a bug that caused player not to be pushed down properly by solid sprites
  when not moving up
- Fixed a bug that caused player to stop at the edge of conveyor belts instead of
  falling off
- Fixed a bug that caused player to enter walking/pushing animation when spindashing
  beside moving solid sprites
- Fixed a bug that caused player to enter walking animation when jumping beside
  solid sprites
- Fixed a bug that caused player to keep spinning against pushable blocks that still
  have room to move
- Fixed bugs that caused player to keep pushing animation when a wall or solid object
  that was in his way was removed
- Fixed a bug that gave Caterkiller bodyparts one additional frame to damage player
  after the head was destroyed
- "Fixed" "spike bug"
- Fixed tile error in GHZ
- Lowered switch in MZ3
- Lowered Special Stage Ring in SYZ1
- Removed unused Caterkiller tiles from SYZ so Roller enemy displays properly
- Implemented revision 1 scrolling effects
- Implemented dust sprites for spindash, skidding, and sliding
- Implemented player state reset after exiting debug mode
- Enabled entering more than one code per titlescreen sequence
- Implemented small bonus feature, activated by code:     BBBBUDLR
- Implemented cheat for bonus feature (also activates): BBBBBBUDLR
