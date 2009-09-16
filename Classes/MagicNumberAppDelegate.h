@class MainViewController;

@interface MagicNumberAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

@end
