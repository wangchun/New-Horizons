#import "PageViewController.h"

#import "AppDelegate.h"

@implementation PageViewController

@synthesize dateLabel;
@synthesize rangeLabel;
@synthesize aButton;
@synthesize bButton;
@synthesize aActionSheet;
@synthesize bActionSheet;

- (id)initWithPageNumber:(int)page {

	if (self = [super initWithNibName:@"PageView" bundle:nil]) {
		pageNumber = page;
	}
	return self;
}

- (void)viewDidLoad {

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

	[aButton setTitle:[[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] objectForKey:@"a"] forState:UIControlStateNormal];
	[bButton setTitle:[[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] objectForKey:@"b"] forState:UIControlStateNormal];
	self.aActionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"New Horizons", @"Sun", @"Mercury", @"Venus", @"Earth", @"Moon", @"Mars", @"Jupiter", @"Saturn", @"Uranus", @"Neptune", @"Pluto", @"Charon", nil] autorelease];
	self.bActionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"New Horizons", @"Sun", @"Mercury", @"Venus", @"Earth", @"Moon", @"Mars", @"Jupiter", @"Saturn", @"Uranus", @"Neptune", @"Pluto", @"Charon", nil] autorelease];
}

- (void)viewDidUnload {

	self.aButton = nil;
	self.bButton = nil;
	self.aActionSheet = nil;
	self.bActionSheet = nil;
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

	[appDelegate.mainViewController dismissModalViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

	if (actionSheet == aActionSheet && buttonIndex != actionSheet.cancelButtonIndex) {
		NSString *a = [actionSheet buttonTitleAtIndex:buttonIndex];
		if ([appDelegate.bodies objectForKey:a] != nil) {
			[[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] setObject:a forKey:@"a"];
			[appDelegate saveSettings];
			[aButton setTitle:[[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] objectForKey:@"a"] forState:UIControlStateNormal];
		}
	}
	if (actionSheet == bActionSheet && buttonIndex != actionSheet.cancelButtonIndex) {
		NSString *b = [actionSheet buttonTitleAtIndex:buttonIndex];
		if ([appDelegate.bodies objectForKey:b] != nil) {
			[[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] setObject:b forKey:@"b"];
			[appDelegate saveSettings];
			[bButton setTitle:[[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] objectForKey:@"b"] forState:UIControlStateNormal];
		}
	}
}

- (IBAction)aTouched {

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

	[aActionSheet showInView:appDelegate.mainViewController.view];
}

- (IBAction)bTouched {

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

	[bActionSheet showInView:appDelegate.mainViewController.view];
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
	[rangeLabel release];
	[aButton release];
	[bButton release];
	[aActionSheet release];
	[bActionSheet release];

	[super dealloc];
}

@end
