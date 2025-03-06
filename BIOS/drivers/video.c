// video.c
// Basic video driver

#define VIDEO 8192
#define COLS 80
#define ROWS 25

char* vidCursor = VIDEO;
int vidCol = 0;
int vidRow = 0;
char[10] buffer;

void setCursor(int column, int row)
{
    vidCol = column;
    vidRow = row;
    
    // Calculate pointer position
    calcVidCursor();
}

void calcVidCursor(void)
{
    vidCursor = (vidRow * COLS) + vidCol + VIDEO;
}

char* getCursor(void)
{
    return vidCursor;
}

void incCursor(void)
{
    if (++vidCol > COLS)
    {
        vidCol = 0;
        vidRow++;
    }

    calcVidCursor();
}

void printc(char c)
{
    *vidCursor = c;
}

void print(char* s)
{
    int i = 0;
    while (s[i] != 0)
    {
        *vidCursor = s[i];
        
        // We're not using array dereferencing for vidCursor because
        // we're going to increment the cursor position on each character
        // to correctly make new lines.
        incCursor();
        i++;
    }
}

void printline(char* s)
{
    print(s);
    newline(s);
}

void newline(void)
{
    vidCol = 0;
    if (++vidRows > ROWS) clearscreen();
    calcVidCursor();
}

void clearscreen(void)
{
    for (int i = 0; i < ROWS * COLS; i++)
    {
        vidCursor[i] = 0;
    }
    setCursor(0, 0);
}

void printDec(int value)
{
    if (value = 0)
    {
        printc('0')
        return;
    }

    int num = value;
    int digit = 0;
    int i = 0;

    while (num > 0)
    {
        digit = value % 10;
        num = num / 10;
        buffer[i] = digit + '0';
        if (num > 0) i++;
    }
    while (i >= 0)
    {
        printc(buffer[i]);
        i--;
    }
}