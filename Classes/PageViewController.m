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
@synthesize aPopoverController;
@synthesize bPopoverController;
@synthesize aTableView;
@synthesize bTableView;
@synthesize backgroundImageName;

- (id)initWithPageNumber:(int)page {

	if (self = [super initWithNibName:UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad ? @"PageView" : @"PageView~ipad" bundle:nil]) {
		pageNumber = page;
		bodies = [[NSArray alloc] initWithObjects:@"New Horizons", @"Voyager 1", @"Voyager 2", @"Sun", @"Mercury", @"Venus", @"Earth", @"Moon", @"Mars", @"Jupiter", @"Saturn", @"Uranus", @"Neptune", @"Pluto", @"Charon", nil];
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

	[self reload];

	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		self.aActionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil] autorelease];
		self.bActionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil] autorelease];
		for (NSString *body in bodies) {
			[aActionSheet addButtonWithTitle:body];
			[bActionSheet addButtonWithTitle:body];
		}
		[aActionSheet addButtonWithTitle:@"Cancel"];
		aActionSheet.cancelButtonIndex = [bodies count];
		[bActionSheet addButtonWithTitle:@"Cancel"];
		bActionSheet.cancelButtonIndex = [bodies count];
	} else {
		UITableViewController *contentViewController;
		contentViewController = [[UITableViewController alloc] init];
		contentViewController.tableView.delegate = self;
		contentViewController.tableView.dataSource = self;
		self.aPopoverController = [[UIPopoverController alloc] initWithContentViewController:contentViewController];
		aPopoverController.delegate = self;
		aPopoverController.popoverContentSize = CGSizeMake(240.0, 600.0);
		self.aTableView = contentViewController.tableView;
		[contentViewController release];
		contentViewController = [[UITableViewController alloc] init];
		contentViewController.tableView.delegate = self;
		contentViewController.tableView.dataSource = self;
		self.bPopoverController = [[UIPopoverController alloc] initWithContentViewController:contentViewController];
		bPopoverController.delegate = self;
		bPopoverController.popoverContentSize = CGSizeMake(240.0, 600.0);
		self.bTableView = contentViewController.tableView;
		[contentViewController release];
	}
}

- (void)viewDidUnload {

	self.backgroundImageView = nil;
	self.dateLabel = nil;
	self.rangeLabel = nil;
	self.aButton = nil;
	self.bButton = nil;
	self.aActionSheet = nil;
	self.bActionSheet = nil;
	self.aPopoverController = nil;
	self.bPopoverController = nil;
	self.aTableView = nil;
	self.bTableView = nil;
	self.backgroundImageName = nil;
}

- (void)reload {

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

	NSString *a = [[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] objectForKey:@"a"];
	NSString *b = [[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] objectForKey:@"b"];
	[aButton setTitle:[NSString stringWithFormat:@" %@ ", a] forState:UIControlStateNormal];
	[bButton setTitle:[NSString stringWithFormat:@" %@ ", b] forState:UIControlStateNormal];
	if ([a isEqualToString:@"New Horizons"] || [b isEqualToString:@"New Horizons"]) {
		if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
			self.backgroundImageName = @"NH.png";
		} else {
			self.backgroundImageName = @"NH~ipad.png";
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
			self.backgroundImageName = @"NH.png";
		} else {
			self.backgroundImageName = @"NH~ipad.png";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

	if (indexPath.section == 0) {
		if (tableView == aTableView) {
			NSString *a = [bodies objectAtIndex:indexPath.row];
			if ([appDelegate.bodies objectForKey:a] != nil) {
				[[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] setObject:a forKey:@"a"];
				[appDelegate saveSettings];
				[self reload];
			}
			[aPopoverController dismissPopoverAnimated:YES];
		}
		if (tableView == bTableView) {
			NSString *b = [bodies objectAtIndex:indexPath.row];
			if ([appDelegate.bodies objectForKey:b] != nil) {
				[[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:pageNumber] setObject:b forKey:@"b"];
				[appDelegate saveSettings];
				[self reload];
			}
			[bPopoverController dismissPopoverAnimated:YES];
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *identifier = @"identifier";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
	}

	if (indexPath.section == 0) {
		cell.textLabel.text = [bodies objectAtIndex:indexPath.row];
	}

	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	if (section == 0) {
		return [bodies count];
	}

	return 0;
}

- (IBAction)aTouched {

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		[aActionSheet showInView:appDelegate.mainViewController.view];
	} else {
		[aPopoverController presentPopoverFromRect:aButton.frame inView:[aButton superview] permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
	}
}

- (IBAction)bTouched {

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		[bActionSheet showInView:appDelegate.mainViewController.view];
	} else {
		[bPopoverController presentPopoverFromRect:bButton.frame inView:[bButton superview] permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
	}
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
	[aPopoverController release];
	[bPopoverController release];
	[aTableView release];
	[bTableView release];
	[backgroundImageName release];

	[bodies release];

	[super dealloc];
}

@end
