# grml-custom

**Current status:** expirimental  – *take care before using!

NOTE: This project was deprecated in favor for https://gitlab.com/blurayne/grml-iso-remaster

## Abstract

We use a grml live iso and an overlay to build diff, and then put it on a custom grml iso by using grml2iso. Finall we use a little shell script inside grml to mount modified diff as overay. This is faster than rebuilding with grml-live and just an experiment with overlay filesystem so far.

Improvements in future are possible by rewriting the grml squashfs image and rebuilding the iso.

## Usage

First we init a new custom grml project
```bash
$ grml-custom init
```
This will create a folder ./import for importing files later in the chroot.

Next step ist to mount ISO image, setup an Overlay FS (AUFS) and the chroot into grml:

```bash
$ grml-custom chroot
```
There you do whatever you want to build your custom grml, like installing new packages, modifying default config. Keep in mind that /etc/config is not

After that we have diff and just need to rebuild the uso by using grml2iso:

```bash
$ grml-custom iso
```

That's it! Burn it to a CD and have ou custom grml flavor.
