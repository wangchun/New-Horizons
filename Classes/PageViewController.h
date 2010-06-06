#import "FlipsideViewController.h"

@interface PageViewController : UIViewController <FlipsideViewControllerDelegate, UIActionSheetDelegate> {

	UILabel *dateLabel;
	UILabel *rangeLabel;
	UIButton *aButton;
	UIButton *bButton;
	UIActionSheet *aActionSheet;
	UIActionSheet *bActionSheet;

	int pageNumber;
}

@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *rangeLabel;
@property (nonatomic, retain) IBOutlet UIButton *aButton;
@property (nonatomic, retain) IBOutlet UIButton *bButton;
@property (nonatomic, retain) UIActionSheet *aActionSheet;
@property (nonatomic, retain) UIActionSheet *bActionSheet;

- (id)initWithPageNumber:(int)page;

- (IBAction)aTouched;
- (IBAction)bTouched;
- (IBAction)showInfo;

@end
