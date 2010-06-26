#import "PageViewController.h"

#import "AppDelegate.h"

@implementation PageViewController

@synthesize backgroundImageView;
@synthesize contentView;
@synthesize dateLabel;
@synthesize rangeLabel;
@synthesize aButton;
@synthesize bButton;
@synthesize aActionSheet;
@synthesize bActionSheet;
@synthesize backgroundImageName;

- (id)initWithPageNumber:(int)page {

	if (self = [super initWithNibName:@"PageView" bundle:nil]) {
		pageNumber = page;
	}
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown;
	} else {
		return NO;
	}
}

- (void)viewDidLoad {

	[self reload];

	self.aActionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"New Horizons", @"Voyager 1", @"Voyager 2", @"Sun", @"Mercury", @"Venus", @"Earth", @"Moon", @"Mars", @"Jupiter", @"Saturn", @"Uranus", @"Neptune", @"Pluto", @"Charon", nil] autorelease];
	self.bActionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"New Horizons", @"Voyager 1", @"Voyager 2", @"Sun", @"Mercury", @"Venus", @"Earth", @"Moon", @"Mars", @"Jupiter", @"Saturn", @"Uranus", @"Neptune", @"Pluto", @"Charon", nil] autorelease];
}

- (void)viewDidUnload {

	self.backgroundImageView = nil;
	self.dateLabel = nil;
	self.rangeLabel = nil;
	self.aButton = nil;
	self.bButton = nil;
	self.aActionSheet = nil;
	self.bActionSheet = nil;
	self.backgroundImageName = nil;
}

- (void)reload {

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

	NSString *a = [[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] objectForKey:@"a"];
	NSString *b = [[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] objectForKey:@"b"];
	[aButton setTitle:a forState:UIControlStateNormal];
	[bButton setTitle:b forState:UIControlStateNormal];
	if ([a isEqualToString:@"New Horizons"] || [b isEqualToString:@"New Horizons"]) {
		if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
			self.backgroundImageName = @"Default.png";
		} else {
			self.backgroundImageName = @"Default~ipad.png";
		}
	} else if ([a isEqualToString:@"Voyager 1"] || [b isEqualToString:@"Voyager 1"]) {
		if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
			self.backgroundImageName = @"Voyager.png";
		} else {
			self.backgroundImageName = @"Voyager~ipad.png";
		}
	} else if ([a isEqualToString:@"Voyager 2"] || [b isEqualToString:@"Voyager 2"]) {
		if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
			self.backgroundImageName = @"Voyager.png";
		} else {
			self.backgroundImageName = @"Voyager~ipad.png";
		}
	} else {
		if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
			self.backgroundImageName = @"Default.png";
		} else {
			self.backgroundImageName = @"Default~ipad.png";
		}
	}
	backgroundImageView.image = [UIImage imageNamed:backgroundImageName];
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
			[self reload];
		}
	}
	if (actionSheet == bActionSheet && buttonIndex != actionSheet.cancelButtonIndex) {
		NSString *b = [actionSheet buttonTitleAtIndex:buttonIndex];
		if ([appDelegate.bodies objectForKey:b] != nil) {
			[[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] setObject:b forKey:@"b"];
			[appDelegate saveSettings];
			[self reload];
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

	[backgroundImageView release];
	[dateLabel release];
	[rangeLabel release];
	[aButton release];
	[bButton release];
	[aActionSheet release];
	[bActionSheet release];
	[backgroundImageName release];

	[super dealloc];
}

@end
