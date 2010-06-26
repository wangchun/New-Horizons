#import "FlipsideViewController.h"

#import "AppDelegate.h"

@implementation FlipsideViewController

@synthesize delegate;

@synthesize metricSegmentedControl;

- (id)initWithPageNumber:(int)page {

	if (self = [super initWithNibName:@"FlipsideView" bundle:nil]) {
		pageNumber = page;
	}
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		return NO;
	} else {
		return interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown;
	}
}

- (void)viewDidLoad {

	[super viewDidLoad];

	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

	if ([[[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] objectForKey:@"metric"] boolValue]) {
		metricSegmentedControl.selectedSegmentIndex = 0;
	} else {
		metricSegmentedControl.selectedSegmentIndex = 1;
	}
}

- (IBAction)done {

	[self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)metric {

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

	if (metricSegmentedControl.selectedSegmentIndex == 0) {
		[[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] setObject:[NSNumber numberWithBool:YES] forKey:@"metric"];
		[appDelegate saveSettings];
	}
	if (metricSegmentedControl.selectedSegmentIndex == 1) {
		[[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] setObject:[NSNumber numberWithBool:NO] forKey:@"metric"];
		[appDelegate saveSettings];
	}
}

- (IBAction)link {

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://pluto.jhuapl.edu/"]];
}

- (void)dealloc {

	[metricSegmentedControl release];

	[super dealloc];
}

@end
