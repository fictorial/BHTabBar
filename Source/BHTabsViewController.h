#import <UIKit/UIKit.h>
#import "BHTabView.h"

@class BHTabsViewController;
@class BHTabsFooterView;
@class BHTabStyle;

@protocol BHTabsViewControllerDelegate <NSObject>
@optional

- (BOOL)shouldMakeTabCurrentAtIndex:(NSUInteger)index
                         controller:(UIViewController *)viewController
                   tabBarController:(BHTabsViewController *)tabBarController;

- (void)didMakeTabCurrentAtIndex:(NSUInteger)index
                      controller:(UIViewController *)viewController
                tabBarController:(BHTabsViewController *)tabBarController;

@end

@interface BHTabsViewController : UIViewController <BHTabViewDelegate> {
  NSArray *tabViews;
  NSArray *viewControllers;
  UIView *contentView;
  UIView *tabsContainerView;
  BHTabsFooterView *footerView;
  BHTabStyle *tabStyle;
  NSUInteger tabWidth;
  NSUInteger currentTabIndex;
  id <BHTabsViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id <BHTabsViewControllerDelegate> delegate;
@property (nonatomic, assign, readonly) UIView *contentView;
@property (nonatomic, retain) BHTabStyle *style;

- (id)initWithViewControllers:(NSArray *)viewControllers
                        style:(BHTabStyle *)style;

@end
