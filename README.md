# MAME ROM-hack software lists

I find MAME’s software list XML files convenient, but the upstream
project has a policy against accepting ROM hacks.  Makes sense, the
shear scope of them balloons out of control quickly.

That’s why I’ll do it anyway.  Of course starting out with ones I care
about, but potentially everything on ROMhacking.net would be fair
game, as well as any other sources.

## Usage

Software list definitions (the *.xml files in hash) are exclusionary
to same-named definition files later in the hashpath.  While you could
permanently override them, and if you only care about ROM hacks, might
be reasonable, it is better to launch MAME with custom parameters, eg:
`mame -hashpath ~/.mame/romhacks/hash -rompath ~/.mame/romhacks/roms`

This presumes that your directory structure for mame lives in
`~/.mame` and you create a `romhacks` subdirectory, itself containing
a `hash` subdirectory (from this repository), and a `roms`
subdirectory mimicking the regular MAME software list ROMs.

You can also combine these with launch parameters.  For example, to
launch Sonic 3 Complete: `mame -hashpath ~/.mame/romhacks/hash
-rompath ~/.mame/romhacks/roms genesis s3c`

For convenience sake, `mamerh.func` is an example bash function that
you can source into your environment (eg, in `~/.bashrc`) to provide a
`mamerh` command that automatically sets hashpath and rompath.  Feel
free to customize it to your preferences.

For some systems (eg, Game Boy), you may need to copy system ROMs to
this ROM path as well.

## Gathering/naming ROMs

Given that these are the same format software list XML files as
upstream MAME, tools like clrmamepro work fine to automatically
rename/sort the ROM hacks into where MAME will expect them when using
a custom hashpath.
