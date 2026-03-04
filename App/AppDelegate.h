//
//  AppDelegate.h
//  SmallMinesweeper
//
//  App lifecycle and menu; creates the main game window.
//

#import <Foundation/Foundation.h>
#if !TARGET_OS_IPHONE
#import <AppKit/AppKit.h>
#endif
#import "SSAppDelegate.h"

@class MinesweeperWindow;

@interface AppDelegate : NSObject <SSAppDelegate>
{
    MinesweeperWindow *_mainWindow;
}
@end
