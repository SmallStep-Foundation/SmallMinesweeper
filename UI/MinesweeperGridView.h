//
//  MinesweeperGridView.h
//  SmallMinesweeper
//
//  Custom view that draws the Minesweeper grid and handles mouse input.
//

#import <AppKit/AppKit.h>

@class MinesweeperGridView;

@protocol MinesweeperGridViewDelegate <NSObject>
@optional
- (void)minesweeperGridViewDidWin:(MinesweeperGridView *)view;
- (void)minesweeperGridViewDidLose:(MinesweeperGridView *)view;
@end

@interface MinesweeperGridView : NSView
{
    NSInteger _rows;
    NSInteger _columns;
    NSInteger _mineCount;
    void *_cells;  // Cell * (opaque to avoid forward decl)
    BOOL _gameStarted;
    BOOL _gameOver;
    BOOL _gameWon;
    NSInteger _firstClickRow;
    NSInteger _firstClickCol;
    id _delegate;
}

@property (nonatomic, assign) NSInteger rows;    // default 9
@property (nonatomic, assign) NSInteger columns; // default 9
@property (nonatomic, assign) NSInteger mineCount; // default 10
#if defined(GNUSTEP) && !__has_feature(objc_arc)
@property (nonatomic, assign) id<MinesweeperGridViewDelegate> delegate;
#else
@property (nonatomic, weak) id<MinesweeperGridViewDelegate> delegate;
#endif

/// Start a new game (resets grid, places mines after first click).
- (void)newGame;

/// Returns whether the game is over (won or lost).
- (BOOL)isGameOver;

@end
