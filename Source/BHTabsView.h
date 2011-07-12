#import <UIKit/UIKit.h>

@class BHTabStyle;

@interface BHTabsView : UIView {
  NSArray *tabViews;
  BHTabStyle *style;
}

@property (nonatomic, retain) NSArray *tabViews;
@property (nonatomic, retain) BHTabStyle *style;


@end
