#import "FlipsideViewController.h"

#import "AppDelegate.h"

@implementation FlipsideViewController

@synthesize delegate;

@synthesize metricSegmentedControl;

- (void)viewDidLoad {

	[super viewDidLoad];

	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];

	if ([[((AppDelegate *)[UIApplication sharedApplication].delegate).settings objectForKey:@"metric"] boolValue]) {
		metricSegmentedControl.selectedSegmentIndex = 0;
	} else {
		metricSegmentedControl.selectedSegmentIndex = 1;
	}
}

- (IBAction)done {

	[self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)metric {

	if (metricSegmentedControl.selectedSegmentIndex == 0) {
		[((AppDelegate *)[UIApplication sharedApplication].delegate).settings setObject:[NSNumber numberWithBool:YES] forKey:@"metric"];
	}
	if (metricSegmentedControl.selectedSegmentIndex == 1) {
		[((AppDelegate *)[UIApplication sharedApplication].delegate).settings setObject:[NSNumber numberWithBool:NO] forKey:@"metric"];
	}

	NSString *settingsPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Settings.plist"];
	[[NSPropertyListSerialization dataFromPropertyList:((AppDelegate *)[UIApplication sharedApplication].delegate).settings format:NSPropertyListBinaryFormat_v1_0 errorDescription:nil] writeToFile:settingsPath atomically:YES];
}

- (IBAction)link {

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://pluto.jhuapl.edu/"]];
}

@end
