//
//  MinesweeperWindow.h
//  SmallMinesweeper
//
//  Main window containing the Minesweeper grid.
//

#import <AppKit/AppKit.h>

@class MinesweeperGridView;

@interface MinesweeperWindow : NSWindow
{
    MinesweeperGridView *_gridView;
}

- (void)newGame;

@end
