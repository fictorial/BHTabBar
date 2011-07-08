#import <UIKit/UIKit.h>

@class BHTabStyle;

// Adds some space under the tabs so that the tabs don't jut right up atop the content view.

@interface BHTabsFooterView : UIView

@property (nonatomic, retain) BHTabStyle *style;

@end
