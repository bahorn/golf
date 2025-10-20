nasm -f bin repdl.asm && chmod +x ./repdl
rm 6
strace ./repdl
shasum ./6 ./repdl
