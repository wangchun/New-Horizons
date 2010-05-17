@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController {

	id <FlipsideViewControllerDelegate> delegate;

	UISegmentedControl *metricSegmentedControl;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;

@property (nonatomic, retain) IBOutlet UISegmentedControl *metricSegmentedControl;

- (IBAction)done;
- (IBAction)metric;
- (IBAction)link;

@end

@protocol FlipsideViewControllerDelegate

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;

@end
