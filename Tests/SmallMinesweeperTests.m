//
//  SmallMinesweeperTests.m
//  SmallMinesweeper unit tests
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "SSTestMacros.h"
#import "../App/AppDelegate.h"

static void testAppDelegateMenuBuild(void)
{
    CREATE_AUTORELEASE_POOL(pool);
    AppDelegate *delegate = [[AppDelegate alloc] init];
    [delegate buildMenu];
    SS_TEST_ASSERT(YES, "AppDelegate buildMenu did not crash");
#if defined(GNUSTEP) && !__has_feature(objc_arc)
    [delegate release];
#endif
    RELEASE(pool);
}

int main(int argc, char **argv)
{
    (void)argc;
    (void)argv;
    CREATE_AUTORELEASE_POOL(pool);
    [NSApplication sharedApplication];
    testAppDelegateMenuBuild();
    SS_TEST_SUMMARY();
    RELEASE(pool);
    return SS_TEST_RETURN();
}
