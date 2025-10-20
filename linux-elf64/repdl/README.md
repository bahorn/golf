# repdl (137 bytes)

A BGGP6 entry, implementing BGGP 4 and 5.

A while back I attempted BGGP4, contained in replicate in this repo, and I also
had a curl based ELF64 for BGGP5.
This entry combines them both into a single one.

## Details

* standard elf64 template, using all the normal cavities.
* when it execve()'s curl, it passes an domain that doesn't resolve so curl
  returns 6.
