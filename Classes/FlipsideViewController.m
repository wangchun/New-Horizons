#import "FlipsideViewController.h"

#import "AppDelegate.h"

@implementation FlipsideViewController

@synthesize delegate;

@synthesize metricSegmentedControl;
@synthesize linkButton;
@synthesize adView;

- (id)initWithPageNumber:(int)page {

	if (self = [super initWithNibName:@"FlipsideView" bundle:nil]) {
		pageNumber = page;
	}
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		return interfaceOrientation == UIInterfaceOrientationPortrait;
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

	Class bannerViewClass = NSClassFromString(@"ADBannerView");
	if (bannerViewClass != nil) {
		adView.backgroundColor = [UIColor whiteColor];
		ADBannerView *bannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
		bannerView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifier320x50];
		bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
		[adView addSubview:bannerView];
	} else {
		adView.backgroundColor = [UIColor clearColor];
	}
}

- (void)viewDidUnload {

	self.metricSegmentedControl = nil;
	self.linkButton = nil;
	self.adView = nil;
}

- (void)viewWillAppear:(BOOL)animated {

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

	NSString *a = [[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] objectForKey:@"a"];
	NSString *b = [[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] objectForKey:@"b"];
	if ([a isEqualToString:@"New Horizons"] || [b isEqualToString:@"New Horizons"]) {
		[linkButton setTitle:@"http://pluto.jhuapl.edu/" forState:UIControlStateNormal];
	} else if ([a isEqualToString:@"Voyager 1"] || [b isEqualToString:@"Voyager 1"]) {
		[linkButton setTitle:@"http://voyager.jpl.nasa.gov/" forState:UIControlStateNormal];
	} else if ([a isEqualToString:@"Voyager 2"] || [b isEqualToString:@"Voyager 2"]) {
		[linkButton setTitle:@"http://voyager.jpl.nasa.gov/" forState:UIControlStateNormal];
	} else {
		[linkButton setTitle:@"http://pluto.jhuapl.edu/" forState:UIControlStateNormal];
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

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

	NSString *a = [[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] objectForKey:@"a"];
	NSString *b = [[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] objectForKey:@"b"];
	if ([a isEqualToString:@"New Horizons"] || [b isEqualToString:@"New Horizons"]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://pluto.jhuapl.edu/"]];
	} else if ([a isEqualToString:@"Voyager 1"] || [b isEqualToString:@"Voyager 1"]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://voyager.jpl.nasa.gov/"]];
	} else if ([a isEqualToString:@"Voyager 2"] || [b isEqualToString:@"Voyager 2"]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://voyager.jpl.nasa.gov/"]];
	} else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://pluto.jhuapl.edu/"]];
	}
}

- (void)dealloc {

	[metricSegmentedControl release];
	[linkButton release];
	[adView release];

	[super dealloc];
}

@end
