@interface PageView : UIView {
@private
	NSInteger _page;
}

@property (nonatomic, assign, readonly) NSInteger page;

- (id)initWithPage:(NSInteger)page;

@end
