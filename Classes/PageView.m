#import "PageView.h"
#import "AppDelegate.h"

@implementation PageView

@synthesize page=_page;

- (id)initWithPage:(NSInteger)page {
	self = [super initWithFrame:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? CGRectMake(768.0 * page, 0.0, 768.0, 1024.0) : CGRectMake(320.0 * page, 0.0, 320.0, 480.0)];
	if (self) {
		_page = page;
	}
	return self;
}

- (void)drawRect:(CGRect)aRect {
	NSMutableDictionary *settings = ((AppDelegate *)[UIApplication sharedApplication].delegate).settings;
	NSString *a = [[[settings objectForKey:@"pages"] objectAtIndex:self.page] objectForKey:@"a"];
	NSString *b = [[[settings objectForKey:@"pages"] objectAtIndex:self.page] objectForKey:@"b"];
	if (([a isEqualToString:@"Voyager 1"] || [b isEqualToString:@"Voyager 1"]) || ([a isEqualToString:@"Voyager 2"] || [b isEqualToString:@"Voyager 2"])) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			[[UIImage imageNamed:@"Voyager~ipad.jpg"] drawInRect:CGRectMake(0.0, 0.0, 768.0, 1024.0)];
		} else {
			[[UIImage imageNamed:@"Voyager.jpg"] drawInRect:CGRectMake(0.0, 0.0, 320.0, 480.0)];
		}
	} else {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			[[UIImage imageNamed:@"New Horizons~ipad.jpg"] drawInRect:CGRectMake(0.0, 0.0, 768.0, 1024.0)];
		} else {
			[[UIImage imageNamed:@"New Horizons.jpg"] drawInRect:CGRectMake(0.0, 0.0, 320.0, 480.0)];
		}
	}
}

@end
