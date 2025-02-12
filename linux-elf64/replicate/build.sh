nasm -f bin replicate.asm && chmod +x ./replicate
rm 4
strace ./replicate
shasum ./4 ./replicate
