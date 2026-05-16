#include <raylib.h>
#include <stdio.h>

#define SIZE 81

int grid[SIZE][SIZE] = { 0 };

void sierpinski_carpet(int square_x, int square_y, int size, int depth);

int main() {
    sierpinski_carpet(0, 0, SIZE, 4);

    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            printf("%c", (grid[i][j] ? ' ' : '1'));
        }
        printf("\n");
    }
    return 0;
}



void sierpinski_carpet(int square_x, int square_y, int size, int depth) {
    printf("sx: %d, sy: %d, size: %d, depth: %d\n", square_x, square_y, size, depth);
    if (!depth) return;
    
    int subsize = size / 3;
    int start_x = square_x + subsize;
    int start_y = square_y+ subsize;

    for (int y = start_y; y < start_y + subsize; y++) {
        for (int x = start_x; x < start_x + subsize; x++) {
            grid[y][x] = 1;
        }
    }

    if (depth == 1) return;
    sierpinski_carpet(square_x,             square_y,           size / 3, depth-1);
    sierpinski_carpet(square_x+subsize,     square_y,           size / 3, depth-1);
    sierpinski_carpet(square_x+2*subsize,   square_y,           size / 3, depth-1);

    sierpinski_carpet(square_x,             square_y+subsize,   size / 3, depth-1);
    sierpinski_carpet(square_x+2*subsize,   square_y+subsize,   size / 3, depth-1);

    sierpinski_carpet(square_x,             square_y+2*subsize, size / 3, depth-1);
    sierpinski_carpet(square_x+subsize,     square_y+2*subsize, size / 3, depth-1);
    sierpinski_carpet(square_x+2*subsize,   square_y+2*subsize, size / 3, depth-1);
}
