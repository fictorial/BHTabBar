#import "BHTabsFooterView.h"
#import "BHTabStyle.h"

@implementation BHTabsFooterView

@synthesize style;

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();

  // We don't want to see the shadow anywhere but above the top edge.
  // But the shadow only looks good when we _fill_ a path so we just
  // use a rect whose left/right/bottom aren't visible.

  CGFloat bigValue = 1e6;

  CGRect r = CGRectMake(-bigValue, self.frame.size.height - self.style.tabBarHeight - 0.5,
                        self.frame.size.width + bigValue, bigValue);

  CGContextSaveGState(context);
  CGContextSetShadow(context, CGSizeZero, self.style.shadowRadius);
  CGContextSetFillColorWithColor(context, self.style.selectedTabColor.CGColor);
  CGContextFillRect(context, r);
  CGContextRestoreGState(context);

  CGContextSaveGState(context);
  CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.05].CGColor);
  CGContextMoveToPoint(context, 0, self.frame.size.height - 0.5);
  CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height - 0.5);
  CGContextStrokePath(context);
  CGContextRestoreGState(context);
}

- (void)dealloc {
  [style release];
  [super dealloc];
}

@end
