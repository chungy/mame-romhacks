# MAME ROM-hack software lists

[MAME](https://www.mamedev.org/)’s built-in software list is
convenient, being able to browse through known pieces of software for
machines it emulates.  The upstream project has a policy against
accepting ROM hacks, which is reasonable enough given the sheer scope
of the category.

This project is my attempt at doing it anyway.  For the most part, it
represents ROM hacks I care about, and historically significant hacks,
but potentially everything on
[ROMHacking.net](https://www.romhacking.net/) is fair game, as well as
any other sources.

## Usage

[**Download the latest archive.**](/zip/trunk/mame-romhacks-trunk.zip)

Software list definitions (the *.xml files in hash) are exclusionary
to same-named definition files later in the hashpath.  While you could
permanently override them, it is better to launch MAME with custom
parameters, eg:

```
mame -hashpath ~/.mame/romhacks/hash -rompath ~/.mame/romhacks/roms
```

In this command, the following paths are assumed:

 * `~/.mame/romhacks/hash`: a directory to store the files from
   [/hash](/dir?ci=trunk&name=hash).
 * `~/.mame/romhacks/roms`: a directory that contains sub-directories
   for each system containing the ROM hacks themselves.  It may
   additionally contain system ROMs that MAME requires to run the
   system.
   * As an example, `~/.mame/romhacks/roms/megadriv` might itself
     contain either a `s3c.zip` file or `s3c` directory containing one
     or more versions of _Sonic 3 Complete_.

MAME can be launched with just these parameters, in which case you
will be able to browse systems and the software lists in the standard
user interface.  You can also directly run specific games, for
example, to launch Sonic 3 Complete:

```
mame genesis s3c -hashpath ~/.mame/romhacks/hash -rompath ~/.mame/romhacks/roms
```

For convenience’s sake,
[`mamerh.func`](/file?name=mamerh.func&ci=trunk) is a bash function
that you can source into your environment (eg, in `~/.bashrc`) to
provide a `mamerh` command that automatically sets hashpath and
rompath.  Feel free to customize it to your preferences.

## Gathering/naming ROMs

The files in [/hash](/dir?ci=trunk&name=hash) are in the same format
as MAME’s upstream software list files, so tools like
[clrmamepro](https://mamedev.emulab.it/clrmamepro/) can be used to
automatically rename and sort ROM hacks into where MAME will expect
them while using these custom files.

As for copyright, the original game developer/publisher maintains
copyright on all the games these hacks are built upon.  No files will
be officially provided by this project.

## Canonical repository URL

This repository is hosted in the [Fossil](https://fossil-scm.org/)
version control system, and hosted on Chisel at
[https://chiselapp.com/user/chungy/repository/mame-romhacks](https://chiselapp.com/user/chungy/repository/mame-romhacks).
If you are viewing this on a GitHub mirror, some links in this README
will not work and you need to clone/download the repository through
GitHub to get the same files.

Report issues or make suggestions on the Fossil repository itself,
pull requests on GitHub will be ignored.
