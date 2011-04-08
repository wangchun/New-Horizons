@class MainViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
@private
	UIWindow *_window;
	UIImageView *_backgroundImageView;
	MainViewController *_mainViewController;
	NSString *_backgroundImageName;

	NSDictionary *_bodies;
	NSMutableDictionary *_settings;
	NSDate *_date;
	NSMutableDictionary *_data;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) MainViewController *mainViewController;

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
