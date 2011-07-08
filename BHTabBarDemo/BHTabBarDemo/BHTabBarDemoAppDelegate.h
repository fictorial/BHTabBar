#import <UIKit/UIKit.h>

@class BHTabsViewController;

@interface BHTabBarDemoAppDelegate : NSObject <UIApplicationDelegate> {
  UIViewController *_vc1;
  UIViewController *_vc2;
  UIViewController *_vc3;
  BHTabsViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *vc1;
@property (nonatomic, retain) IBOutlet UIViewController *vc2;
@property (nonatomic, retain) IBOutlet UIViewController *vc3;

@end
