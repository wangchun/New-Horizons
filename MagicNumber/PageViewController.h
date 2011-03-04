#import "FlipsideViewController.h"

@interface PageViewController : UIViewController <FlipsideViewControllerDelegate, UIActionSheetDelegate, UIPopoverControllerDelegate, UITableViewDelegate, UITableViewDataSource> {

	UIImageView *backgroundImageView;
	UIView *contentView;
	UILabel *dateLabel;
	UILabel *rangeLabel;
	UIButton *aButton;
	UIButton *bButton;
	UIActionSheet *aActionSheet;
	UIActionSheet *bActionSheet;
	UIPopoverController *aPopoverController;
	UIPopoverController *bPopoverController;
	UITableView *aTableView;
	UITableView *bTableView;
	NSString *backgroundImageName;

	int pageNumber;
	NSArray *bodies;
}

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *rangeLabel;
@property (nonatomic, retain) IBOutlet UIButton *aButton;
@property (nonatomic, retain) IBOutlet UIButton *bButton;
@property (nonatomic, retain) UIActionSheet *aActionSheet;
@property (nonatomic, retain) UIActionSheet *bActionSheet;
@property (nonatomic, retain) UIPopoverController *aPopoverController;
@property (nonatomic, retain) UIPopoverController *bPopoverController;
@property (nonatomic, retain) UITableView *aTableView;
@property (nonatomic, retain) UITableView *bTableView;
@property (nonatomic, retain) NSString *backgroundImageName;

- (IBAction)aTouched;
- (IBAction)bTouched;
- (IBAction)showInfo;

- (id)initWithPageNumber:(int)page;

- (void)reload;

@end
