#import "RootView.h"

@implementation RootView

- (id)init {
	self = [self initWithFrame:CGRectZero];
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 2304.0, 1024.0)];
			imageView.image = [UIImage imageNamed:@"New Horizons~ipad.jpg"];
			self.contentSize = CGSizeMake(2304.0, 1024.0);
			[self addSubview:imageView];
			[imageView release];
		} else {
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 960.0, 480.0)];
			imageView.image = [UIImage imageNamed:@"New Horizons.jpg"];
			self.contentSize = CGSizeMake(960.0, 480.0);
			[self addSubview:imageView];
			[imageView release];
		}
	}
	return self;
}

@end
