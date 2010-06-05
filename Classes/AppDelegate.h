@class MainViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {

	UIWindow *window;
	MainViewController *mainViewController;

	NSDictionary *bodies;
	NSMutableDictionary *settings;
	NSDate *date;
	NSMutableDictionary *data;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;

@property (nonatomic, retain) NSDictionary *bodies;
@property (nonatomic, retain) NSMutableDictionary *settings;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSMutableDictionary *data;

- (void)loadSettings;
- (void)saveSettings;

- (NSString *)applicationDocumentsDirectory;

- (void)calculate;
- (void)reloadData;

@end
