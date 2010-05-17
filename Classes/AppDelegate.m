#include <sqlite3.h>

#import "AppDelegate.h"

#import "MainViewController.h"

@implementation AppDelegate

@synthesize date;
@synthesize data;
@synthesize settings;
@synthesize window;
@synthesize mainViewController;

- (id)init {

	if (self = [super init]) {
		data = [[NSMutableDictionary alloc] init];
		NSString *settingsPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Settings.plist"];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		id plist = nil;
		if ([fileManager fileExistsAtPath:settingsPath]) {
			plist = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:settingsPath] mutabilityOption:0 format:NULL errorDescription:nil];
		}
		if ([plist isKindOfClass:[NSDictionary class]]) {
			settings = [plist mutableCopy];
		} else {
			settings = [[NSMutableDictionary alloc] init];
		}
		if ([settings objectForKey:@"metric"] != nil) {
			[settings setObject:[NSNumber numberWithBool:[[settings objectForKey:@"metric"] boolValue]] forKey:@"metric"];
		} else {
			[settings setObject:[NSNumber numberWithBool:YES] forKey:@"metric"];
		}
	}
	return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	[self reloadData];

	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
	[window makeKeyAndVisible];

	return YES;
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {

	[self reloadData];
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

	[data removeAllObjects];

	self.date = [NSDate dateWithTimeIntervalSinceReferenceDate:floor([[NSDate date] timeIntervalSinceReferenceDate] / 86400.0) * 86400.0];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *today = [dateFormatter stringFromDate:date];
	NSString *massPath = [[NSBundle mainBundle] pathForResource:@"Mass" ofType:@"plist"];
	NSDictionary *mass = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:massPath] mutabilityOption:0 format:NULL errorDescription:nil];
	NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"sqlite"];
	sqlite3 *database;
	if (sqlite3_open([dataPath UTF8String], &database) == SQLITE_OK) {
		NSString *sql = [NSString stringWithFormat:@"SELECT object, x, y, z, vx, vy, vz FROM data WHERE date = '%@'", today];
		sqlite3_stmt *statement;
		if (sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			double vectors[7];
			while (sqlite3_step(statement) == SQLITE_ROW) {
				NSNumber *key = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
				vectors[0] = [[mass objectForKey:[key stringValue]] doubleValue];
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

	[mainViewController release];
	[window release];
	[settings release];
	[data release];
	[date release];
	[super dealloc];
}

@end
