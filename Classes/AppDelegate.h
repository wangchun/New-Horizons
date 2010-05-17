double distance(void);

@class MainViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {

	NSDate *date;
	NSMutableDictionary *data;
	NSMutableDictionary *settings;
	UIWindow *window;
	MainViewController *mainViewController;
}

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSMutableDictionary *data;
@property (nonatomic, retain) NSMutableDictionary *settings;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

- (void)calculate;
- (void)reloadData;

@end
