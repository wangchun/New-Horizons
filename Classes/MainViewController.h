#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	NSTimer *timer;
	UILabel *label;
}

@property (nonatomic, retain) IBOutlet UILabel *label;

- (void)timerFireMethod:(NSTimer *)theTimer;

- (IBAction)showInfo;

@end
