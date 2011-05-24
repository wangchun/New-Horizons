#import "RootViewController.h"
#import "AppDelegate.h"
#import "PageView.h"

@implementation RootViewController

@synthesize pageControl=_pageControl;
@synthesize scrollView=_scrollView;
@synthesize pageView=_pageView;
@synthesize nextPageView=_nextPageView;
@synthesize previousPageView=_previousPageView;

- (void)loadView {
	self.pageControl = [[[UIPageControl alloc] initWithFrame:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? CGRectMake(0.0, 988.0, 768.0, 36.0) : CGRectMake(0.0, 444.0, 320.0, 36.0)] autorelease];
	[self.pageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
	self.scrollView = [[[UIScrollView alloc] initWithFrame:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? CGRectMake(0.0, 0.0, 768.0, 1024.0) : CGRectMake(0.0, 0.0, 320.0, 480.0)] autorelease];
	self.scrollView.pagingEnabled = YES;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.delegate = self;
	UIView *view = [[[UIView alloc] initWithFrame:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? CGRectMake(0.0, 0.0, 768.0, 1024.0) : CGRectMake(0.0, 0.0, 320.0, 480.0)] autorelease];
	[view addSubview:self.scrollView];
	[view addSubview:self.pageControl];
	self.view = view;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	NSMutableDictionary *settings = ((AppDelegate *)[UIApplication sharedApplication].delegate).settings;
	int numberOfPages = [[settings objectForKey:@"pages"] count];
	int page = [[settings objectForKey:@"page"] integerValue];
	self.pageControl.numberOfPages = numberOfPages;
	self.pageControl.currentPage = page;
	self.scrollView.contentSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? CGSizeMake(768.0 * numberOfPages, 1024.0) : CGSizeMake(320.0 * numberOfPages, 480.0);
	[self.scrollView scrollRectToVisible:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? CGRectMake(768.0 * page, 0.0, 768.0, 1024.0) : CGRectMake(320.0 * page, 0.0, 320.0, 480.0) animated:NO];
	self.pageView = [[[PageView alloc] initWithPage:page] autorelease];
	self.nextPageView = nil;
	if (page + 1 < numberOfPages) {
		self.nextPageView = [[[PageView alloc] initWithPage:page + 1] autorelease];
	}
	self.previousPageView = nil;
	if (page - 1 >= 0) {
		self.previousPageView = [[[PageView alloc] initWithPage:page - 1] autorelease];
	}
	if (self.previousPageView != nil) {
		[self.scrollView addSubview:self.previousPageView];
	}
	if (self.nextPageView != nil) {
		[self.scrollView addSubview:self.nextPageView];
	}
	[self.scrollView addSubview:self.pageView];
}

- (void)viewDidUnload {
	self.pageControl = nil;
	self.scrollView = nil;
	self.pageView = nil;
	self.nextPageView = nil;
	self.previousPageView = nil;
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? UIInterfaceOrientationIsPortrait(interfaceOrientation) : interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (self.scrollView != scrollView) {
		return;
	}
	if (pageControlUsed) {
		return;
	}
	NSMutableDictionary *settings = ((AppDelegate *)[UIApplication sharedApplication].delegate).settings;
	int numberOfPages = [[settings objectForKey:@"pages"] count];
	int oldPage = [[settings objectForKey:@"page"] integerValue];
	int newPage = MAX(MIN((int)round(self.scrollView.contentOffset.x / (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 768.0 : 320.0)), numberOfPages - 1), 0);
	if (oldPage == newPage) {
		return;
	}
	[self.pageView removeFromSuperview];
	[self.nextPageView removeFromSuperview];
	[self.previousPageView removeFromSuperview];
	if (oldPage + 1 == newPage) {
		self.previousPageView = self.pageView;
		self.pageView = self.nextPageView;
		self.nextPageView = nil;
		if (newPage + 1 < numberOfPages) {
			self.nextPageView = [[[PageView alloc] initWithPage:newPage + 1] autorelease];
		}
	} else if (oldPage - 1 == newPage) {
		self.nextPageView = self.pageView;
		self.pageView = self.previousPageView;
		self.previousPageView = nil;
		if (newPage - 1 >= 0) {
			self.previousPageView = [[[PageView alloc] initWithPage:newPage - 1] autorelease];
		}
	} else {
		self.pageView = [[[PageView alloc] initWithPage:newPage] autorelease];
		self.nextPageView = nil;
		if (newPage + 1 < numberOfPages) {
			self.nextPageView = [[[PageView alloc] initWithPage:newPage + 1] autorelease];
		}
		self.previousPageView = nil;
		if (newPage - 1 >= 0) {
			self.previousPageView = [[[PageView alloc] initWithPage:newPage - 1] autorelease];
		}
	}
	if (self.previousPageView != nil) {
		[self.scrollView addSubview:self.previousPageView];
	}
	if (self.nextPageView != nil) {
		[self.scrollView addSubview:self.nextPageView];
	}
	[self.scrollView addSubview:self.pageView];
	[settings setObject:[NSNumber numberWithInteger:newPage] forKey:@"page"];
	NSString *applicationDocumentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	[settings writeToFile:[applicationDocumentsDirectory stringByAppendingPathComponent:@"Settings.plist"] atomically:YES];
	self.pageControl.currentPage = newPage;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	if (self.scrollView != scrollView) {
		return;
	}
	pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if (self.scrollView != scrollView) {
		return;
	}
	pageControlUsed = NO;
}

- (void)pageChanged {
	NSMutableDictionary *settings = ((AppDelegate *)[UIApplication sharedApplication].delegate).settings;
	int numberOfPages = [[settings objectForKey:@"pages"] count];
	int page = self.pageControl.currentPage;
	[self.pageView removeFromSuperview];
	[self.nextPageView removeFromSuperview];
	[self.previousPageView removeFromSuperview];
	self.pageView = [[[PageView alloc] initWithPage:page] autorelease];
	self.nextPageView = nil;
	if (page + 1 < numberOfPages) {
		self.nextPageView = [[[PageView alloc] initWithPage:page + 1] autorelease];
	}
	self.previousPageView = nil;
	if (page - 1 >= 0) {
		self.previousPageView = [[[PageView alloc] initWithPage:page - 1] autorelease];
	}
	if (self.previousPageView != nil) {
		[self.scrollView addSubview:self.previousPageView];
	}
	if (self.nextPageView != nil) {
		[self.scrollView addSubview:self.nextPageView];
	}
	[self.scrollView addSubview:self.pageView];
	[settings setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
	NSString *applicationDocumentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	[settings writeToFile:[applicationDocumentsDirectory stringByAppendingPathComponent:@"Settings.plist"] atomically:YES];
	[self.scrollView scrollRectToVisible:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? CGRectMake(768.0 * page, 0.0, 768.0, 1024.0) : CGRectMake(320.0 * page, 0.0, 320.0, 480.0) animated:YES];
	pageControlUsed = YES;
}

- (void)dealloc {
	self.pageControl = nil;
	self.scrollView = nil;
	self.pageView = nil;
	self.nextPageView = nil;
	self.previousPageView = nil;
	[super dealloc];
}

@end
