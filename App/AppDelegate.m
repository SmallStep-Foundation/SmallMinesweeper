//
//  AppDelegate.m
//  SmallMinesweeper
//

#import "AppDelegate.h"
#import "MinesweeperWindow.h"
#import "SSAppDelegate.h"
#import "SSHostApplication.h"
#import "SSMainMenu.h"
#import "SSAboutPanel.h"

@implementation AppDelegate

- (void)applicationWillFinishLaunching {
    [self buildMenu];
}

- (void)applicationDidFinishLaunching {
    _mainWindow = [[MinesweeperWindow alloc] init];
    [_mainWindow makeKeyAndOrderFront:nil];
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(id)sender {
    (void)sender;
    return YES;
}

- (void)buildMenu {
#if !TARGET_OS_IPHONE
    SSMainMenu *menu = [[SSMainMenu alloc] init];
    [menu setAppName:@"SmallMinesweeper"];
    [menu setAboutAppName:@"SmallMinesweeper"];
    [menu setAboutVersion:@"1.0"];
    [menu setAboutTarget:self];
    NSArray *items = [NSArray arrayWithObjects:
        [SSMainMenuItem itemWithTitle:@"New Game" action:@selector(newGame:) keyEquivalent:@"n" modifierMask:NSCommandKeyMask target:self],
        nil];
    [menu buildMenuWithItems:items quitTitle:@"Quit SmallMinesweeper" quitKeyEquivalent:@"q"];
    [menu install];
#if defined(GNUSTEP) && !__has_feature(objc_arc)
    [menu release];
#endif
#endif
}

- (void)newGame:(id)sender {
    (void)sender;
    [_mainWindow newGame];
}

- (void)showAbout:(id)sender {
    (void)sender;
    [SSAboutPanel showWithAppName:@"SmallMinesweeper" version:@"1.0"];
}

#if defined(GNUSTEP) && !__has_feature(objc_arc)
- (void)dealloc {
    [_mainWindow release];
    [super dealloc];
}
#endif

@end
