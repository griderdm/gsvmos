// bios.c

#include "drivers\video.c"
#include "idt.c"
#include "drivers\gsbio.c"
#include "drivers\keyboard.c"
#include "biosinterrupts.c"
#include "biosinfo.c"
#include "POST\post.c"
#include "memory.c"
#include "boot.c"
#include "config.c"

asm
{
    nop
    nop
    nop
    nop
    nop
};

void main(void)
{
    asm { mov svm, VIDEO };

    init_idt();
    initbiosidt();
    
    installKeyboard();

    drawLogo();
    printVers();
    newline();

    post();

    delay(100);

    asm
    {
        jmp boot
        hlt
    };
}