@interface MainViewController : UIViewController <UIScrollViewDelegate> {

	UIScrollView *scrollView;
	UIPageControl *pageControl;
	NSMutableArray *viewControllers;
	NSTimer *timer;

	BOOL pageControlUsed;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;

- (IBAction)changePage:(id)sender;

- (void)loadScrollViewWithPage:(int)page;

- (void)timerFired:(NSTimer *)theTimer;

@end
