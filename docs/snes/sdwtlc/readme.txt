______________________________________________________________________

 Demo World : The Legend Continues (SNES)
 October 31, 2003
 Version 1.10

 FuSoYa's Niche
 http://fusoya.cg-games.net
______________________________________________________________________

 CONTENTS
______________________________________________________________________

 1. Introduction
 2. Instructions (Read before you patch!)
 3. Updates
 4. Legal Notice
 5. Contact Information


______________________________________________________________________

 1. Introduction
______________________________________________________________________


 Demo World is a hack to demonstrate how well Lunar Magic can modify
 Super Mario World.  There are 3 major versions of Demo World that
 have been released to date.

 The first version of Demo World was released on September 10, 2001.
 While it only contained a few short levels, it's primary purpose was
 to serve as an example for how to do custom block ASM.  To this end,
 it was the first hack to implement the animated "breakable brick"
 from Mario 3.  The brick could be broken only when Mario hit it from
 below when big or from the side with a cape.  It would also turn into
 a coin when a POW was hit. There were a few other custom blocks as
 well, such as a block that would break only when Mario hit it with a
 fireball, and a Mario 3 style frozen coin.

 A second unofficial version of Demo World was later released by
 Bouche, called "Demo World 3".  It was identical to Demo World other
 than the music, which was replaced with Mario 3 tunes.

 The third version of Demo World was released on September 21, 2003.
 Called "Demo World : The Legend Continues" (DWTLC), it's a full hack
 of Mario World that's complete right to the end.  It showcases many
 of the features in Lunar Magic, including the new tile and palette
 animation feature included in version 1.60.  And as with the original
 Demo World, it has new custom blocks such as screen-scrolling type
 pipes that are similar to what you'd see in Mario 3.  A version 1.1
 update was released about a month later to fix a few bugs.


 DWTLC was done by both myself (FuSoYa) and Zero-G (my brother).
 Although we had long planned to make a complete hack of Demo World,
 towards the end of last year we had only gotten the first 2 worlds
 of it done.  It then remained inactive for about half a year, until
 we finally set a deadline for ourselves of getting the hack out
 there, ready or not, before the next version of Lunar Magic was 
 released near the end of September.  What followed was a frantic
 two months of level creation and coding, the result of which is this
 hack.

 We were both a little surprised by how well it turned out, given the
 time limit.  I'm very grateful to Zero-G, who deserves most of the
 credit for the levels, as he made about 4/5 of them.

 Anyway, have fun playing DWTLC!  ^^


______________________________________________________________________

 2. Instructions
______________________________________________________________________

 First off, DO NOT patch the original ROM with the included IPS file!

 The reason is that I used DWTLC to test LM with ROMs greater than 
 4 MB.  But since this involves moving the banks around, an IPS file
 for the hack would include most of the original ROM in it.  To avoid
 the issue, I've included a patch meant to be applied to a ROM that
 has already been expanded to 6 MB.

 Thus, you should take the original Mario World US ROM and use Lunar
 Expand (included in this zip file for convenience) to convert the
 ROM to a 48 Mbit ExHiROM (it's the top right option in the program).
 THEN apply the IPS file to it.

 And that's all there is to it!  ^^


______________________________________________________________________

 3. Updates
______________________________________________________________________


Version 1.10 October 31, 2003

-fixed SRAM saving and loading for Snes9x 1.40+.  Should also fix it 
 for copiers.
-several minor adjustments to the screen scrolling pipe ASM to fix a
 few issues.  The changes were significant enough to force us to redo
 the title screen demo sequence.
-modified Secret Star World level so that you can't just use Yoshi to
 get to the keyhole.
-removed useless key from Ship Graveyard. (VortexMilitia)
-fixed an entrance BG init position in #3 Water Castle. (Proto K)
-adjusted a few water levels to prevent swimming in dirt. (Maticolotto)
-fixed another BG init bug with a MagiKoopa level. (Sendy)
-a few other relatively minor changes and fixes here and there.


Version 1.00 September 21, 2003

-First Release.


______________________________________________________________________

 4. Legal Notice
______________________________________________________________________

 The Demo World patch (hereafter referred to as the "Patch") is not
 official or supported by Nintendo or any other commercial entity.

 The Patch is freeware thus it can be distributed freely provided
 the following conditions hold:(1) This document is supplied with the
 Patch and the document is not modified in any way, (2) The Patch is
 not distributed with or as part of any ROM image in any format, and
 (3) No goods, services, or money can be charged for the Patch in any
 form, nor may it be included in conjunction with any other offer or
 monetary exchange.

 The Patch is provided AS IS, and its use is at your own risk.
 Anyone mentioned in this document will not be held liable for any
 damages, direct or otherwise, arising from its use or presence.


______________________________________________________________________

 5. Contact Information
______________________________________________________________________

 FuSoYa
   www:   http://fusoya.cg-games.net (was http://fusoya.cjb.net)
   ???:   06942508
______________________________________________________________________
