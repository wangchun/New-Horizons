@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
@private
	UIWindow *_window;
	RootViewController *_rootViewController;
	NSDictionary *_bodies;
	NSMutableDictionary *_settings;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) RootViewController *rootViewController;
@property (nonatomic, assign, readonly) NSDictionary *bodies;
@property (nonatomic, assign, readonly) NSMutableDictionary *settings;

@end
