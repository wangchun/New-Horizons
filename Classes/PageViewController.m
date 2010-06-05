#import "PageViewController.h"

#import "AppDelegate.h"

@implementation PageViewController

@synthesize dateLabel;
@synthesize aLabel;
@synthesize bLabel;
@synthesize rangeLabel;

- (id)initWithPageNumber:(int)page {

	if (self = [super initWithNibName:@"PageView" bundle:nil]) {
		pageNumber = page;
	}
	return self;
}

- (void)viewDidLoad {

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

	aLabel.text = [[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] objectForKey:@"a"];
	bLabel.text = [[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] objectForKey:@"b"];
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

	[appDelegate.mainViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo {

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithPageNumber:pageNumber];
	controller.delegate = self;
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[appDelegate.mainViewController presentModalViewController:controller animated:YES];
	[controller release];
}

- (void)dealloc {

	[dateLabel release];
	[aLabel release];
	[bLabel release];
	[rangeLabel release];

	[super dealloc];
}

@end
