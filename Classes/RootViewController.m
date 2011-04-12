#import "RootViewController.h"
#import "RootView.h"

@implementation RootViewController

@synthesize rootView=_rootView;

- (void)loadView {
	UIView *view = [[[UIView alloc] init] autorelease];
	view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
	self.rootView = [[[RootView alloc] init] autorelease];
	[view addSubview:self.rootView];
	self.view = view;
}

- (void)viewDidUnload {
	[super viewDidUnload];
	self.rootView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return UIInterfaceOrientationIsPortrait(interfaceOrientation);
	} else {
		return interfaceOrientation == UIInterfaceOrientationPortrait;
	}
}

- (void)dealloc {
	self.rootView = nil;
	[super dealloc];
}

@end
