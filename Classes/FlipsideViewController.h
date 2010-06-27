@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController {

	id <FlipsideViewControllerDelegate> delegate;

	UISegmentedControl *metricSegmentedControl;
	UIButton *linkButton;
	UIView *adView;

	int pageNumber;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;

@property (nonatomic, retain) IBOutlet UISegmentedControl *metricSegmentedControl;
@property (nonatomic, retain) IBOutlet UIButton *linkButton;
@property (nonatomic, retain) IBOutlet UIView *adView;

- (IBAction)done;
- (IBAction)metric;
- (IBAction)link;

@end

@protocol FlipsideViewControllerDelegate

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;

@end
