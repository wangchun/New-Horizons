#import "FlipsideViewController.h"

@interface PageViewController : UIViewController <FlipsideViewControllerDelegate> {

	UILabel *dateLabel;
	UILabel *aLabel;
	UILabel *bLabel;
	UILabel *rangeLabel;

	int pageNumber;
}

@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *aLabel;
@property (nonatomic, retain) IBOutlet UILabel *bLabel;
@property (nonatomic, retain) IBOutlet UILabel *rangeLabel;

- (id)initWithPageNumber:(int)page;

- (IBAction)showInfo;

@end
