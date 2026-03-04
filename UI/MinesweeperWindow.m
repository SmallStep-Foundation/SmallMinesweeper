//
//  MinesweeperWindow.m
//  SmallMinesweeper
//

#import "MinesweeperWindow.h"
#import "MinesweeperGridView.h"
#import "SSWindowStyle.h"

static const CGFloat kMargin = 16.0;

@interface MinesweeperWindow () <MinesweeperGridViewDelegate>
@property (nonatomic, retain) MinesweeperGridView *gridView;
@end

@implementation MinesweeperWindow
#if defined(GNUSTEP) && !__has_feature(objc_arc)
@synthesize gridView = _gridView;
#endif

- (instancetype)init {
    MinesweeperGridView *grid = [[MinesweeperGridView alloc] initWithFrame:NSZeroRect];
    [grid setRows:9];
    [grid setColumns:9];
    [grid setMineCount:10];
    [grid setDelegate:self];

    CGFloat cellSize = 24.0;
    CGFloat contentW = 9 * cellSize + 2 * kMargin;
    CGFloat contentH = 9 * cellSize + 2 * kMargin;
    NSRect frame = NSMakeRect(100, 100, contentW, contentH);

    NSUInteger style = [SSWindowStyle standardWindowMask];
    self = [super initWithContentRect:frame
                             styleMask:style
                               backing:NSBackingStoreBuffered
                                 defer:NO];
    if (self) {
        [self setTitle:@"SmallMinesweeper"];
        [self setReleasedWhenClosed:NO];
        _gridView = grid;
        [grid setFrame:NSMakeRect(kMargin, kMargin,
                                 (CGFloat)([grid columns] * cellSize),
                                 (CGFloat)([grid rows] * cellSize))];
        [grid setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin];
        [[self contentView] addSubview:grid];
        [grid newGame];
#if defined(GNUSTEP) && !__has_feature(objc_arc)
        [grid release];
#endif
    }
    return self;
}

- (void)newGame {
    [_gridView newGame];
    [self setTitle:@"SmallMinesweeper"];
}

- (void)minesweeperGridViewDidWin:(MinesweeperGridView *)view {
    (void)view;
    [self setTitle:@"SmallMinesweeper — You won!"];
}

- (void)minesweeperGridViewDidLose:(MinesweeperGridView *)view {
    (void)view;
    [self setTitle:@"SmallMinesweeper — Game over"];
}

#if defined(GNUSTEP) && !__has_feature(objc_arc)
- (void)dealloc {
    [_gridView release];
    [super dealloc];
}
#endif

@end
