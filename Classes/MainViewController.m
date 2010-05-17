#import "MainViewController.h"

#import "AppDelegate.h"
#import "MainView.h"

@implementation MainViewController

@synthesize timeLabel;
@synthesize distanceLabel;

- (void)viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];

	timer = [NSTimer scheduledTimerWithTimeInterval:0.100 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
	[self timerFireMethod:timer];
}

- (void)viewDidDisappear:(BOOL)animated	{

	[super viewDidDisappear:animated];

	[timer invalidate];
	timer = nil;
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {

	[self dismissModalViewControllerAnimated:YES];
}

- (void)timerFireMethod:(NSTimer *)theTimer {

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate calculate];
	[timeLabel setText:[appDelegate.date description]];
	NSMutableData *data1 = [appDelegate.data objectForKey:[NSNumber numberWithInt:-98]];
	NSMutableData *data2 = [appDelegate.data objectForKey:[NSNumber numberWithInt:999]];
	if (data1 != nil && data2 != nil) {
		double *vectors1 = [data1 mutableBytes];
		double *vectors2 = [data2 mutableBytes];
		double dx = vectors1[1] - vectors2[1];
		double dy = vectors1[2] - vectors2[2];
		double dz = vectors1[3] - vectors2[3];
		double distance = sqrt(dx * dx + dy * dy + dz * dz);
		if ([[((AppDelegate *)[UIApplication sharedApplication].delegate).settings objectForKey:@"metric"] boolValue]) {
			[distanceLabel setText:[NSString stringWithFormat:@"%.f km", distance / 1000.0]];
		} else {
			[distanceLabel setText:[NSString stringWithFormat:@"%.f mi", distance / 1609.344]];
		}
	} else {
		[distanceLabel setText:@"No Data"];
	}
}

- (IBAction)showInfo {

	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

@end
