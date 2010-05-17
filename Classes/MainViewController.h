#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {

	NSTimer *timer;
	UILabel *timeLabel;
	UILabel *distanceLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UILabel *distanceLabel;

- (void)timerFireMethod:(NSTimer *)theTimer;

- (IBAction)showInfo;

@end
