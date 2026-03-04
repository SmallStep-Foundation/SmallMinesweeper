//
//  MinesweeperGridView.m
//  SmallMinesweeper
//
//  Grid state and drawing: cells, mines, reveal, flag. Left click = reveal,
//  right click = toggle flag. Mines are placed after first click so first
//  click is always safe.
//

#import "MinesweeperGridView.h"
#import <stdlib.h>
#import <string.h>
#import <time.h>

typedef enum {
    CellHidden = 0,
    CellRevealed,
    CellFlagged
} CellState;

typedef struct {
    BOOL hasMine;
    int adjacentMines;  // 0–8
    CellState state;
} Cell;

@interface MinesweeperGridView ()
@end

static const CGFloat kCellSize = 24.0;

@implementation MinesweeperGridView
#if defined(GNUSTEP) && !__has_feature(objc_arc)
@synthesize rows = _rows;
@synthesize columns = _columns;
@synthesize mineCount = _mineCount;
@synthesize delegate = _delegate;
#endif

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        _rows = 9;
        _columns = 9;
        _mineCount = 10;
        _cells = NULL;
        _gameStarted = NO;
        _gameOver = NO;
        _gameWon = NO;
    }
    return self;
}

- (void)dealloc {
    if (_cells) free(_cells);
#if defined(GNUSTEP) && !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)newGame {
    if (_cells) free(_cells);
    _cells = (Cell *)calloc((size_t)(_rows * _columns), sizeof(Cell));
    _gameStarted = NO;
    _gameOver = NO;
    _gameWon = NO;
    [self setNeedsDisplay:YES];
}

- (BOOL)isGameOver {
    return _gameOver;
}

- (NSInteger)cellIndexForRow:(NSInteger)row col:(NSInteger)col {
    if (row < 0 || row >= _rows || col < 0 || col >= _columns)
        return -1;
    return row * _columns + col;
}

- (Cell *)cellAtRow:(NSInteger)row col:(NSInteger)col {
    NSInteger idx = [self cellIndexForRow:row col:col];
    if (idx < 0) return NULL;
    return &((Cell *)_cells)[idx];
}

- (void)placeMinesExcludingRow:(NSInteger)excludeRow col:(NSInteger)excludeCol {
    static BOOL seeded = NO;
    int i;
    NSInteger total, safe, placed, idx, r, c;
    NSInteger row, col, nr, nc;
    Cell *cell;
    Cell *neighbor;
    int count;
    static const int dr[] = { -1, -1, -1, 0, 0, 1, 1, 1 };
    static const int dc[] = { -1, 0, 1, -1, 1, -1, 0, 1 };
    BOOL neighborFlag;

    if (!seeded) {
        srandom((unsigned)time(NULL));
        seeded = YES;
    }
    total = _rows * _columns;
    safe = 0;
    for (i = 0; i < 8; i++) {
        r = excludeRow + dr[i];
        c = excludeCol + dc[i];
        if (r >= 0 && r < _rows && c >= 0 && c < _columns) safe++;
    }
    safe += 1;
    if (_mineCount > total - safe) return;

    placed = 0;
    while (placed < _mineCount) {
        idx = (NSInteger)(random() % total);
        r = idx / _columns;
        c = idx % _columns;
        if ([self cellAtRow:r col:c]->hasMine) continue;
        if (r == excludeRow && c == excludeCol) continue;
        neighborFlag = NO;
        for (i = 0; i < 8; i++) {
            if (r == excludeRow + dr[i] && c == excludeCol + dc[i]) {
                neighborFlag = YES;
                break;
            }
        }
        if (neighborFlag) continue;
        [self cellAtRow:r col:c]->hasMine = YES;
        placed++;
    }

    for (row = 0; row < _rows; row++) {
        for (col = 0; col < _columns; col++) {
            cell = [self cellAtRow:row col:col];
            if (cell->hasMine) continue;
            count = 0;
            for (i = 0; i < 8; i++) {
                nr = row + dr[i];
                nc = col + dc[i];
                neighbor = [self cellAtRow:nr col:nc];
                if (neighbor && neighbor->hasMine) count++;
            }
            cell->adjacentMines = count;
        }
    }
}

- (void)revealAtRow:(NSInteger)row col:(NSInteger)col {
    Cell *cell = [self cellAtRow:row col:col];
    if (!cell || cell->state == CellRevealed || cell->state == CellFlagged)
        return;
    if (!_gameStarted) {
        _gameStarted = YES;
        _firstClickRow = row;
        _firstClickCol = col;
        [self placeMinesExcludingRow:row col:col];
    }
    if (cell->hasMine) {
        cell->state = CellRevealed;
        _gameOver = YES;
        _gameWon = NO;
        [self revealAllMines];
        [self setNeedsDisplay:YES];
        if ([_delegate respondsToSelector:@selector(minesweeperGridViewDidLose:)])
            [_delegate minesweeperGridViewDidLose:self];
        return;
    }
    cell->state = CellRevealed;
    if (cell->adjacentMines == 0) {
        static const int dr[] = { -1, -1, -1, 0, 0, 1, 1, 1 };
        static const int dc[] = { -1, 0, 1, -1, 1, -1, 0, 1 };
        int i;
        for (i = 0; i < 8; i++)
            [self revealAtRow:row + dr[i] col:col + dc[i]];
    }
    [self setNeedsDisplay:YES];
    [self checkWin];
}

- (void)checkWin {
    NSInteger revealed = 0;
    NSInteger i;
    for (i = 0; i < _rows * _columns; i++) {
        if (((Cell *)_cells)[i].state == CellRevealed) revealed++;
    }
    if (revealed == _rows * _columns - _mineCount) {
        _gameOver = YES;
        _gameWon = YES;
        if ([_delegate respondsToSelector:@selector(minesweeperGridViewDidWin:)])
            [_delegate minesweeperGridViewDidWin:self];
    }
}

- (void)revealAllMines {
    NSInteger i;
    for (i = 0; i < _rows * _columns; i++) {
        if (((Cell *)_cells)[i].hasMine) ((Cell *)_cells)[i].state = CellRevealed;
    }
}

- (void)toggleFlagAtRow:(NSInteger)row col:(NSInteger)col {
    Cell *cell = [self cellAtRow:row col:col];
    if (!cell || cell->state == CellRevealed || _gameOver) return;
    if (cell->state == CellFlagged)
        cell->state = CellHidden;
    else
        cell->state = CellFlagged;
    [self setNeedsDisplay:YES];
}

- (NSInteger)rowColForPoint:(NSPoint)point {
    NSInteger col = (NSInteger)(point.x / kCellSize);
    NSInteger row = (NSInteger)((NSHeight([self bounds]) - point.y) / kCellSize);
    if (row < 0 || row >= _rows || col < 0 || col >= _columns)
        return -1;
    return row * _columns + col;
}

- (void)mouseDown:(NSEvent *)event {
    NSPoint loc = [self convertPoint:[event locationInWindow] fromView:nil];
    NSInteger idx = [self rowColForPoint:loc];
    if (idx < 0) return;
    NSInteger row = idx / _columns, col = idx % _columns;
    if ([event buttonNumber] == 0) {
        [self revealAtRow:row col:col];
    } else if ([event buttonNumber] == 1) {
        [self toggleFlagAtRow:row col:col];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    NSInteger row, col;
    CGFloat x, y;
    NSRect cellRect;
    Cell *cell;
    NSRect bounds = [self bounds];
    (void)dirtyRect;

    [[NSColor windowBackgroundColor] setFill];
    NSRectFill(bounds);

    for (row = 0; row < _rows; row++) {
        for (col = 0; col < _columns; col++) {
            x = (CGFloat)col * kCellSize;
            y = NSMaxY(bounds) - (CGFloat)(row + 1) * kCellSize;
            cellRect = NSMakeRect(x, y, kCellSize, kCellSize);
            cell = [self cellAtRow:row col:col];
            if (!cell) continue;

            if (cell->state == CellHidden || cell->state == CellFlagged) {
                [[NSColor controlHighlightColor] setFill];
                NSRectFill(cellRect);
                [[NSColor grayColor] setStroke];
                NSFrameRect(cellRect);
                if (cell->state == CellFlagged) {
                    [[NSColor redColor] setFill];
                    NSRectFill(NSInsetRect(cellRect, 6, 6));
                }
                continue;
            }

            [[NSColor controlBackgroundColor] setFill];
            NSRectFill(cellRect);
            [[NSColor grayColor] setStroke];
            NSFrameRect(cellRect);

            if (cell->hasMine) {
                [[NSColor blackColor] setFill];
                NSRectFill(NSInsetRect(cellRect, 4, 4));
                continue;
            }
            if (cell->adjacentMines > 0) {
                NSString *num = [NSString stringWithFormat:@"%d", cell->adjacentMines];
                NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSFont systemFontOfSize:14], NSFontAttributeName,
                    [NSColor blackColor], NSForegroundColorAttributeName,
                    nil];
                NSSize textSize = [num sizeWithAttributes:attrs];
                NSPoint pt = NSMakePoint(
                    x + (kCellSize - textSize.width) / 2.0f,
                    y + (kCellSize - textSize.height) / 2.0f - 1.0f
                );
                [num drawAtPoint:pt withAttributes:attrs];
            }
        }
    }
}

@end
