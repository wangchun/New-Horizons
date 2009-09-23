#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	NSTimer *timer;
	UILabel *label;
}

@property (nonatomic, retain) IBOutlet UILabel *label;

- (IBAction)showInfo;

@end
