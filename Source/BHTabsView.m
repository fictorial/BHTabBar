#import "BHTabsView.h"
#import "BHTabStyle.h"

@implementation BHTabsView

@synthesize tabViews;
@synthesize style;

- (void)layoutSubviews {
  NSUInteger N = [self.tabViews count];
  
  CGFloat W = self.frame.size.width / N;
  NSUInteger overlap = W * self.style.overlapAsPercentageOfTabWidth;
  W = (self.frame.size.width + overlap * (N-1)) / N;
  
  NSUInteger tabIndex = 0;
  
  for (UIView *tabView in self.tabViews) {
    CGRect tabFrame = CGRectMake(tabIndex * W,
                                 self.style.tabsViewHeight - self.style.tabHeight - self.style.tabBarHeight,
                                 W, self.style.tabHeight);
    
    if (tabIndex > 0)
      tabFrame.origin.x -= tabIndex * overlap;
    
    tabView.frame = tabFrame;
    
    tabIndex++;
  }
}

- (void)dealloc {
  self.tabViews = nil;
  self.style = nil;

  [super dealloc];
}

@end
