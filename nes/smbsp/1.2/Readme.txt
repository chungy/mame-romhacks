                           Super Mario Bros. Special
                            35th Anniversary Edition
                                      v1.2

                              Presented by Frantik
                                      2021


Super Mario Bros. Special is a follow-up to Super Mario Bros, originally 
released in Japan in 1986 for the home computer market.  The game features 32 
all new levels, 5 new enemies and 5 new power-ups.  Due to limitations of the PC 
hardware, the game engine was quite poor in comparison to the Famicom/NES 
original.  Most notable was the lack of scrolling; the PC version would instead 
show each screen one at a time.  

This port brings the levels, new enemies and power-ups back to the Famicom/NES 
engine.  Also included are most of the unique background changes and other 
features not possible with the original SMB engine.  The end result is a much 
more playable game that feels like a legitimate sequel.  


New Enemies
=============
None of these enemies can be stomped!

Sidestepper / Chockichoki 
   *A crab-like enemy
   *Originally from Mario Bros
    
Fighter Fly / Makaji 
   * Jumping fly enemy that will chase after Mario  
   * Originally from Mario Bros
    
Icicle / Tarusaur 
   * A falling spike made of ice 
   * Originally from Mario Bros
    
Fireball / Sigebo 
   * A fireball that moves along the ground
   * Originally from Donkey Kong
    
Barrel / Tsurara 
   * A barrel that rolls along the ground
   * Originally from Donkey Kong
    
    
New Power-Ups
===============

Hachisuke - The bee from the Hudson Soft logo, gives 8000 points
    
Hammer - Hammer from Donkey Kong, kills enemies it touches
    
Clock - Adds 100 ticks to the game clock
    
Wing - Gives Mario the ability to fly 
    
Lucky Star - Kills all enemies on the screen 

Search for these power-ups!


Special Features
==================

There are two "special features accessible from the main title screen:

* Press B to select the starting world 

* Press UP+Select to swap between X1-style and original NES/Famicom colors


History and Commentary
========================

In the late 2000s, relatively little was known about Super Mario Bros Special 
outside of Japan.  The most widely available emulator/rom combination at the 
time was the inferior PC-88 version.  In addition to being nearly unplayable, 
the level data was corrupted at World 4-3, so there was no knowledge of the 
areas past this.  

Luckily, Karatorian was able to patch the file to correct the level data and 
then managed to decode all the levels and create some of the first known 
complete maps of the game.  Frantik used these maps and began iterpreting the 
levels into standard Super Mario Bros format, while making some minor changes to 
the engine to more closely resemble 'Special'.  Karatorian took the new level 
data and wrote tools to combine the extra data and other changes into one custom 
file.  

The aim was simply to recreate the similar feel of the original, but not actually add the 
new power-ups or enemies. Karatorian did set up some of the inital framework for 
the hidden power-ups, though they were repreented by 1ups instead of custom 
power-ups.  It was hoped that perhaps someone in the future would add the 
missing features.  Frantik and Karatorian released this version in 2008-2009.

Two other significant versions of the game were created from the initial 
Frantik/Karatorian project.  First was the Messatu X1 version in 2012, which 
added a much more accurate title screen, as well as made some attempts at 
looking closer to the X1 version.  A modified palette was used for the 
overworld, and some tiles had dithering added.  A second was TRIFORCE89's 
version in 2017 which retained the new title screen and restored the original 
Famicom/NES color palette, while also swapping in a mix of tiles from SMB2j.  

Unsatisfied with either of these approaches, Frantik decided in 2021 to revist 
Super Mario Bros Special, and to finally implement the missing power-ups and new 
enemies.  This work snowballed into an attempt to recreate as many of the other 
unique features and changes as possible.  Features were added such as support 
for multiple power-ups on the screen at one time, more flexibility with mixing 
elements, variable pipe exit heights, the list goes on.  Many of the changes are 
subtle and may not be noticed except by those familiar with the engine.


Big thanks to these folks for their help during development and beta testing!
===============================================================================
TRIFORCE89
ShadowOne333
mahou
Baggins
shanem
Agahnim
CasualChris
diablo666
Vanya
Dracula X
Hacker65xx
PowerPanda
Superjustinbros
thanksgoogle
MathUser2929

And, of course:  Huge Thanks To Karatorian!


Version History
=================


Version 1.2
   
   * Released 19 July 2021

   * Fixed a bug with NES color mode when near Bowser
   
Version 1.1

   * Released 16 July 2021
      
   * Optimized code and enemy placement to reduce lag issues/HUD flicker
   * Fixed water bubble not showing
   * Fixed hammer showing when supposed to be off screen on some emulators 
   * Changed castle color scheme
   * Added blue shadow to all text with black background 
   * Fixed Castle/Cloud issue in 7-2
   * Fixed Spelling of Famicom
   * Lengthened time after you beat game before Congratulations message appears
   * Fixed music restarting in 3-1 after you touch flag pole
   * Re-enabled fireworks
   * Fixed bug where you could enter sideways pipe too low (inside wall)
   * Fixed/enabled 1-2 "warp zone" area
   * Fixed blue bar on very top of screen in water areas 
   * Fixed bugs with color swap and moved option to title screen   
   * Allowed for Bowser to be killed by the hammer
   * Added a little bit of time to hammer and wing power ups
   * Slow the clock down to orininal SMB1 speed
   * Fixed bug that caused display buffer overflow when getting too many coins
   * Other misc bug fixes and edits        


Version 1.0 

   * Released 25 June 2021
   
   * Limited public release primarily for beta testing
 
 
