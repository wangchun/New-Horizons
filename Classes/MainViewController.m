#import "MainViewController.h"
#import "MainView.h"

@implementation MainViewController

@synthesize label;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	timer = [NSTimer scheduledTimerWithTimeInterval:0.200 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated	{
	[super viewDidDisappear:animated];
	[timer invalidate];
	timer = nil;
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo {
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

- (void)timerFireMethod:(NSTimer *)theTimer {
	[label setText:[[NSDate date] description]];
}

@end
