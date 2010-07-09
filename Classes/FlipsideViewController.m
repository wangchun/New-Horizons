#import "FlipsideViewController.h"

#import "AppDelegate.h"

@implementation FlipsideViewController

@synthesize delegate;

@synthesize metricSegmentedControl;
@synthesize linkButton;
@synthesize bannerView;

- (id)initWithPageNumber:(int)page {

	if (self = [super initWithNibName:@"FlipsideView" bundle:nil]) {
		pageNumber = page;
		animating = NO;
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
		self.bannerView = [[[ADBannerView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 320.0) / 2.0, self.view.bounds.size.height, 320.0, 50.0)] autorelease];
		bannerView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifier320x50];
		bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
	}
}

- (void)viewDidUnload {

	self.metricSegmentedControl = nil;
	self.linkButton = nil;
	self.bannerView = nil;
}

- (void)viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];

	if (animated) {
		animating = YES;
	}

	Class bannerViewClass = NSClassFromString(@"ADBannerView");
	if (bannerViewClass != nil) {
		bannerView.delegate = self;
	}

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

- (void)viewDidAppear:(BOOL)animated {

	[super viewDidAppear:animated];

	if (animated) {
		animating = NO;
	}

	Class bannerViewClass = NSClassFromString(@"ADBannerView");
	if (bannerViewClass != nil) {
		[self.view addSubview:bannerView];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		if (bannerView.bannerLoaded) {
			bannerView.frame = CGRectMake((self.view.bounds.size.width - 320.0) / 2.0, self.view.bounds.size.height - 50.0, 320.0, 50.0);
			CGRect frame = linkButton.frame;
			frame.origin.y = bannerView.frame.origin.y - frame.size.height - 20;
			linkButton.frame = frame;
		} else {
			bannerView.frame = CGRectMake((self.view.bounds.size.width - 320.0) / 2.0, self.view.bounds.size.height, 320.0, 50.0);
			CGRect frame = linkButton.frame;
			frame.origin.y = bannerView.frame.origin.y - frame.size.height - 40;
			linkButton.frame = frame;
		}
		[UIView commitAnimations];
	}
}

- (void)viewWillDisappear:(BOOL)animated {

	[super viewWillDisappear:animated];

	if (animated) {
		animating = YES;
	}
}

- (void)viewDidDisappear:(BOOL)animated {

	[super viewDidDisappear:animated];

	if (animated) {
		animating = NO;
	}

	Class bannerViewClass = NSClassFromString(@"ADBannerView");
	if (bannerViewClass != nil) {
		[bannerView removeFromSuperview];
		bannerView.delegate = nil;
	}

	bannerView.frame = CGRectMake((self.view.bounds.size.width - 320.0) / 2.0, self.view.bounds.size.height, 320.0, 50.0);
	CGRect frame = linkButton.frame;
	frame.origin.y = bannerView.frame.origin.y - frame.size.height - 40;
	linkButton.frame = frame;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {

	if (!animating) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		bannerView.frame = CGRectMake((self.view.bounds.size.width - 320.0) / 2.0, self.view.bounds.size.height - 50.0, 320.0, 50.0);
		CGRect frame = linkButton.frame;
		frame.origin.y = bannerView.frame.origin.y - frame.size.height - 20;
		linkButton.frame = frame;
		[UIView commitAnimations];
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {

	if (!animating) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		bannerView.frame = CGRectMake((self.view.bounds.size.width - 320.0) / 2.0, self.view.bounds.size.height, 320.0, 50.0);
		CGRect frame = linkButton.frame;
		frame.origin.y = bannerView.frame.origin.y - frame.size.height - 40;
		linkButton.frame = frame;
		[UIView commitAnimations];
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
	[bannerView release];

	[super dealloc];
}

@end
