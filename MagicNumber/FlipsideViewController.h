@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController <ADBannerViewDelegate> {

	id <FlipsideViewControllerDelegate> delegate;

	UISegmentedControl *metricSegmentedControl;
	UIButton *linkButton;
	ADBannerView *bannerView;

	int pageNumber;
	BOOL animating;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;

@property (nonatomic, retain) IBOutlet UISegmentedControl *metricSegmentedControl;
@property (nonatomic, retain) IBOutlet UIButton *linkButton;
@property (nonatomic, retain) ADBannerView *bannerView;

- (IBAction)done;
- (IBAction)metric;
- (IBAction)link;

@end

@protocol FlipsideViewControllerDelegate

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;

@end
