# mame-shell-utils
###by Rodney Fisk <xizdaqrian@gmail.com>

This is a suite of useful shell scripts (possibly other languages) that will help you
manage MAME assets.

The last ROM pack I downloaded was 25,000 ROMS! That is nuts, so I have managed to
cull that down to a much smaller set.

For each ROM, there are a number of artwork, config, and documentation folders. Those
must be culled down to a matching set. Fortunately, the MAME designers made this
easy. The name of each associated asset has the same basename as the ROM.

The first utility in the set is **copy-assets.sh**
This script will read each ROM filename, and copy the assets matching it to
their respective folders.

Let's say you have downloaded all weekend, and you have all the latest ROMS,
progettosnaps files, manuals, and everything. You need a way to import **only**
the stuff you already have. That's where this script comes in. 

15-Aug-2016 - copy-assets has basic functionality. Not much in the way of
options. More robustness is to come.
