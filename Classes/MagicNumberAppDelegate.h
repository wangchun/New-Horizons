//
//  MagicNumberAppDelegate.h
//  MagicNumber
//
//  Created by Wang Chun on 2009-09-16.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@class MainViewController;

@interface MagicNumberAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

@end

