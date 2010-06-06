#import "MainViewController.h"

#import "AppDelegate.h"
#import "PageViewController.h"

@implementation MainViewController

@synthesize scrollView;
@synthesize pageControl;
@synthesize viewControllers;

- (void)viewDidLoad {

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

	NSUInteger numberOfPages = [[appDelegate.settings objectForKey:@"pages"] count];

	NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:numberOfPages];
	for (unsigned i = 0; i < numberOfPages; ++i) {
		[controllers addObject:[NSNull null]];
	}
	self.viewControllers = controllers;

	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * numberOfPages, scrollView.frame.size.height);
	scrollView.scrollsToTop = NO;

	pageControl.numberOfPages = numberOfPages;
	pageControl.currentPage = 0;

	[self loadScrollViewWithPage:0];
	[self loadScrollViewWithPage:1];
}

- (void)viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];

	timer = [NSTimer scheduledTimerWithTimeInterval:0.100 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
	[self timerFired:timer];
}

- (void)viewDidDisappear:(BOOL)animated	{

	[super viewDidDisappear:animated];

	[timer invalidate];
	timer = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {

	if (pageControlUsed) {
		return;
	}

	int page = round(scrollView.contentOffset.x / scrollView.frame.size.width);
	pageControl.currentPage = page;

	[self loadScrollViewWithPage:page];
	[self loadScrollViewWithPage:page - 1];
	[self loadScrollViewWithPage:page + 1];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

	pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

	pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {

	int page = pageControl.currentPage;

	[self loadScrollViewWithPage:page];
	[self loadScrollViewWithPage:page - 1];
	[self loadScrollViewWithPage:page + 1];

	CGRect frame = scrollView.frame;
	frame.origin.x = frame.size.width * page;
	frame.origin.y = 0;
	[scrollView scrollRectToVisible:frame animated:YES];

	pageControlUsed = YES;
}

- (void)loadScrollViewWithPage:(int)page {

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

	NSUInteger numberOfPages = [[appDelegate.settings objectForKey:@"pages"] count];

	if (!(page >= 0 && page < numberOfPages)) {
		return;
	}

	PageViewController *controller = [viewControllers objectAtIndex:page];
	if ((NSNull *)controller == [NSNull null]) {
		controller = [[PageViewController alloc] initWithPageNumber:page];
		[viewControllers replaceObjectAtIndex:page withObject:controller];
		[controller release];
	}

	if (controller.view.superview == nil) {
		CGRect frame = scrollView.frame;
		frame.origin.x = frame.size.width * page;
		frame.origin.y = 0;
		controller.view.frame = frame;
		[scrollView addSubview:controller.view];
	}
}

- (void)timerFired:(NSTimer *)theTimer {

	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

	NSUInteger numberOfPages = [[appDelegate.settings objectForKey:@"pages"] count];

	[appDelegate calculate];

	for (unsigned i = 0; i < numberOfPages; ++i) {
		PageViewController *controller = [viewControllers objectAtIndex:i];
		if ([controller isKindOfClass:[PageViewController class]]) {
			[controller.dateLabel setText:[appDelegate.date description]];
			NSMutableData *data1 = [appDelegate.data objectForKey:[[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:i] objectForKey:@"a"]];
			NSMutableData *data2 = [appDelegate.data objectForKey:[[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:i] objectForKey:@"b"]];
			if (data1 != nil && data2 != nil) {
				double *vectors1 = [data1 mutableBytes];
				double *vectors2 = [data2 mutableBytes];
				double dx = vectors1[1] - vectors2[1];
				double dy = vectors1[2] - vectors2[2];
				double dz = vectors1[3] - vectors2[3];
				double distance = sqrt(dx * dx + dy * dy + dz * dz);
				if ([[[[appDelegate.settings objectForKey:@"pages"] objectAtIndex:i] objectForKey:@"metric"] boolValue]) {
					[controller.rangeLabel setText:[NSString stringWithFormat:@"%.f km", distance / 1000.0]];
				} else {
					[controller.rangeLabel setText:[NSString stringWithFormat:@"%.f mi", distance / 1609.344]];
				}
			} else {
				[controller.rangeLabel setText:@"No Data"];
			}
		}
	}
}

- (void)dealloc {

	[scrollView release];
	[pageControl release];
	[viewControllers release];

	[super dealloc];
}

@end
