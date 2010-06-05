#import "AppDelegate.h"

#import "MainViewController.h"

#include <sqlite3.h>

static NSUInteger kNumberOfPages = 6;

@implementation AppDelegate

@synthesize window;
@synthesize mainViewController;

@synthesize date;
@synthesize data;
@synthesize bodies;
@synthesize settings;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	self.bodies = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bodies" ofType:@"plist"]];

	[self loadSettings];

	[self reloadData];

	[window addSubview:mainViewController.view];

	return YES;
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {

	[self reloadData];
}

- (void)loadSettings {

	NSString *path = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Settings.plist"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:path]) {
		NSString *defaultPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
		if (defaultPath) {
			NSError *error = nil;
			if (![fileManager copyItemAtPath:defaultPath toPath:path error:&error]) {
				NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
				abort();
			}
		}
	}
	NSDictionary *loadedSettings = [NSDictionary dictionaryWithContentsOfFile:path];
	NSMutableDictionary *localSettings = [NSMutableDictionary dictionary];
	NSMutableArray *localPages = [NSMutableArray array];
	for (unsigned i = 0; i < kNumberOfPages; ++i) {
		[localPages addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"New Horizons", @"a", @"Pluto", @"b", [NSNumber numberWithBool:YES], @"metric", nil]];
	}
	[localSettings setObject:[NSNumber numberWithInt:1] forKey:@"version"];
	if ([[loadedSettings objectForKey:@"version"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
		NSArray *loadedPages = [loadedSettings objectForKey:@"pages"];
		if ([loadedPages isKindOfClass:[NSArray class]]) {
			for (unsigned i = 0; i < [localPages count]; ++i) {
				NSDictionary *loadedPage = [loadedPages objectAtIndex:i];
				if ([loadedPage isKindOfClass:[NSDictionary class]]) {
					NSMutableDictionary *localPage = [NSMutableDictionary dictionary];
					NSString *a = [loadedPage objectForKey:@"a"];
					if (![a isKindOfClass:[NSString class]]) {
						continue;
					}
					if ([self.bodies objectForKey:a] == nil) {
						continue;
					}
					[localPage setObject:a forKey:@"a"];
					NSString *b = [loadedPage objectForKey:@"b"];
					if (![b isKindOfClass:[NSString class]]) {
						continue;
					}
					if ([self.bodies objectForKey:b] == nil) {
						continue;
					}
					[localPage setObject:b forKey:@"b"];
					NSNumber *metric = [loadedPage objectForKey:@"metric"];
					if (metric == nil) {
						metric = [NSNumber numberWithBool:YES];
					}
					if (![metric isKindOfClass:[NSNumber class]]) {
						continue;
					}
					[localPage setObject:[NSNumber numberWithBool:[metric boolValue]] forKey:@"metric"];
					[localPages replaceObjectAtIndex:i withObject:localPage];
				}
			}
		}
	}
	[localSettings setObject:localPages forKey:@"pages"];
	self.settings = localSettings;
}

- (void)saveSettings {

	NSString *path = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Settings.plist"];
	[self.settings writeToFile:path atomically:YES];
}

- (NSString *)applicationDocumentsDirectory {

	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)calculate {

	NSTimeInterval timeInterval1 = [date timeIntervalSinceReferenceDate];
	NSTimeInterval timeInterval2 = [[NSDate date] timeIntervalSinceReferenceDate];
	for (int i = 0; i < 144; ++i) {
		double interval = 0.0;
		if (fabs(timeInterval2 - timeInterval1) < 1e-12) {
			break;
		} else if (timeInterval2 - timeInterval1 > 0.0) {
			if (timeInterval2 - timeInterval1 < 600.0) {
				interval = timeInterval2 - timeInterval1;
			} else {
				interval = 600.0;
			}
		} else if (timeInterval2 - timeInterval1 < 0.0) {
			if (timeInterval2 - timeInterval1 > -600.0) {
				interval = timeInterval2 - timeInterval1;
			} else {
				interval = -600.0;
			}
		}
		NSArray *keys = [data allKeys];
		for (int a = [keys count] - 1; a >= 0; --a) {
			for (int b = a - 1; b >= 0; --b) {
				double *vectors1 = [[data objectForKey:[keys objectAtIndex:a]] mutableBytes];
				double *vectors2 = [[data objectForKey:[keys objectAtIndex:b]] mutableBytes];
				double x = vectors1[1] - vectors2[1];
				double y = vectors1[2] - vectors2[2];
				double z = vectors1[3] - vectors2[3];
				double rg = sqrt(x * x + y * y + z * z);
				double t = interval / (rg * rg * rg);
				double t1 = t * vectors2[0];
				double t2 = t * vectors1[0];
				vectors1[4] -= x * t1;
				vectors1[5] -= y * t1;
				vectors1[6] -= z * t1;
				vectors2[4] += x * t2;
				vectors2[5] += y * t2;
				vectors2[6] += z * t2;
			}
		}
		for (int a = [keys count] - 1; a >= 0; --a) {
			double *vectors = [[data objectForKey:[keys objectAtIndex:a]] mutableBytes];
			vectors[1] += vectors[4] * interval;
			vectors[2] += vectors[5] * interval;
			vectors[3] += vectors[6] * interval;
		}
		timeInterval1 += interval;
	}
	self.date = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval1];
}

- (void)reloadData {

	self.date = [NSDate dateWithTimeIntervalSinceReferenceDate:floor([[NSDate date] timeIntervalSinceReferenceDate] / 86400.0) * 86400.0];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *today = [dateFormatter stringFromDate:date];

	self.data = [[NSMutableDictionary alloc] init];
	NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"sqlite"];
	sqlite3 *database;
	if (sqlite3_open([dataPath UTF8String], &database) == SQLITE_OK) {
		NSString *sql = [NSString stringWithFormat:@"SELECT object, x, y, z, vx, vy, vz FROM data WHERE date = '%@'", today];
		sqlite3_stmt *statement;
		if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			double vectors[7];
			while (sqlite3_step(statement) == SQLITE_ROW) {
				NSString *key = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
				vectors[0] = [[[self.bodies objectForKey:key] objectForKey:@"mass"] doubleValue];
				vectors[1] = sqlite3_column_double(statement, 1);
				vectors[2] = sqlite3_column_double(statement, 2);
				vectors[3] = sqlite3_column_double(statement, 3);
				vectors[4] = sqlite3_column_double(statement, 4);
				vectors[5] = sqlite3_column_double(statement, 5);
				vectors[6] = sqlite3_column_double(statement, 6);
				[data setObject:[NSMutableData dataWithBytes:vectors length:sizeof(vectors)] forKey:key];
			}
		}
		sqlite3_finalize(statement);
	}
	sqlite3_close(database);
}

- (void)dealloc {

	[window release];
	[mainViewController release];

	[bodies release];
	[settings release];
	[date release];
	[data release];

	[super dealloc];
}

@end
