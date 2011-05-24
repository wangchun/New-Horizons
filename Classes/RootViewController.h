@class PageView;

@interface RootViewController : UIViewController <UIScrollViewDelegate> {
@private
	UIPageControl *_pageControl;
	UIScrollView *_scrollView;
	PageView *_pageView;
	PageView *_nextPageView;
	PageView *_previousPageView;
	BOOL pageControlUsed;
}

@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) PageView *pageView;
@property (nonatomic, retain) PageView *nextPageView;
@property (nonatomic, retain) PageView *previousPageView;

@end
