#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

@synthesize window=_window;
@synthesize backgroundImageView=_backgroundImageView;
@synthesize mainViewController=_mainViewController;
@synthesize bodies=_bodies;
@synthesize settings=_settings;
@synthesize date=_date;
@synthesize data=_data;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
	[self.window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)dealloc
{
	[_window release];
	[_backgroundImageView release];
	[_mainViewController release];
	[_bodies release];
	[_settings release];
	[_date release];
	[_data release];
	[super dealloc];
}

@end
