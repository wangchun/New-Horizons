#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window=_window;
@synthesize rootViewController=_rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
	self.rootViewController = [[[RootViewController alloc] init] autorelease];
	[self.window addSubview:self.rootViewController.view];
	[self.window makeKeyAndVisible];
	return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[_bodies release];
	_bodies = nil;
	[_settings release];
	_settings = nil;
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	NSLog(@"applicationSignificantTimeChange:"); // XXX
}

- (NSDictionary *)bodies {
	if (_bodies == nil) {
		_bodies = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bodies" ofType:@"plist"]];
	}
	return _bodies;
}

- (NSMutableDictionary *)settings {
	if (_settings == nil) {
		_settings = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:1], @"version", nil];
		NSInteger page = 0;
		[_settings setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
		NSMutableArray *pages = [NSMutableArray array];
		[pages addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"New Horizons", @"a", @"Pluto", @"b", [NSNumber numberWithBool:YES], @"metric", nil]];
		[_settings setObject:pages forKey:@"pages"];
		NSString *applicationDocumentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
		NSData *data = [NSData dataWithContentsOfFile:[applicationDocumentsDirectory stringByAppendingPathComponent:@"Settings.plist"]];
		CFPropertyListRef propertyList = CFPropertyListCreateWithData(kCFAllocatorDefault, (CFDataRef)data, kCFPropertyListImmutable, NULL, NULL);
		if (propertyList != NULL) {
			NSInteger version;
			const void *_version;
			if (CFDictionaryGetValueIfPresent(propertyList, CFSTR("version"), &_version) && CFGetTypeID(_version) == CFNumberGetTypeID() && !CFNumberIsFloatType(_version) && CFNumberGetValue(_version, kCFNumberNSIntegerType, &version)) {
				if (version == 1) {
					NSInteger page;
					const void *_page;
					if (!(CFDictionaryGetValueIfPresent(propertyList, CFSTR("page"), &_page) && CFGetTypeID(_page) == CFNumberGetTypeID() && !CFNumberIsFloatType(_page) && CFNumberGetValue(_page, kCFNumberNSIntegerType, &page))) {
						page = 0;
					}
					NSMutableArray *pages = [NSMutableArray array];
					const void *_pages;
					if (CFDictionaryGetValueIfPresent(propertyList, CFSTR("pages"), &_pages) && CFGetTypeID(_pages) == CFArrayGetTypeID()) {
						for (CFIndex idx = 0; idx < CFArrayGetCount(_pages); idx++) {
							const void *_page = CFArrayGetValueAtIndex(_pages, idx);
							NSString *a = nil;
							NSString *b = nil;
							BOOL metric = YES;
							if (CFGetTypeID(_page) == CFDictionaryGetTypeID()) {
								const void *_a;
								if (CFDictionaryGetValueIfPresent(_page, CFSTR("a"), &_a) && CFGetTypeID(_a) == CFStringGetTypeID()) {
									a = (NSString *)_a;
								}
								const void *_b;
								if (CFDictionaryGetValueIfPresent(_page, CFSTR("b"), &_b) && CFGetTypeID(_b) == CFStringGetTypeID()) {
									b = (NSString *)_b;
								}
								const void *_metric;
								if (CFDictionaryGetValueIfPresent(_page, CFSTR("metric"), &_metric) && CFGetTypeID(_metric) == CFBooleanGetTypeID()) {
									metric = CFBooleanGetValue(_metric) ? YES : NO;
								}
							}
							if (!([self.bodies objectForKey:a] != nil && [self.bodies objectForKey:b] != nil)) {
								if (idx == page) {
									page = 0;
								} else if (idx < page) {
									page--;
								}
								continue;
							}
							[pages addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:a, @"a", b, @"b", [NSNumber numberWithBool:metric], @"metric", nil]];
						}
					}
					if ([pages count] > 0) {
						if ([pages count] > 9) {
							[pages removeObjectsInRange:NSMakeRange(9, [pages count] - 9)];
						}
						if (!(page >= 0 && page < [pages count])) {
							page = 0;
						}
						[_settings setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
						[_settings setObject:pages forKey:@"pages"];
					}
				}
			}
			CFRelease(propertyList);
		}
	}
	return _settings;
}

- (void)dealloc {
	self.window = nil;
	self.rootViewController = nil;
	[_bodies release];
	_bodies = nil;
	[_settings release];
	_settings = nil;
	[super dealloc];
}

@end
