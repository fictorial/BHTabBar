#import "BHTabBarDemoAppDelegate.h"
#import "BHTabsViewController.h"
#import "BHTabStyle.h"

@implementation BHTabBarDemoAppDelegate

@synthesize window=_window;
@synthesize vc1 = _vc1;
@synthesize vc2 = _vc2;
@synthesize vc3 = _vc3;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSArray *vcs = [NSArray arrayWithObjects:self.vc1, self.vc2, nil];
  
  viewController = [[BHTabsViewController alloc] 
                    initWithViewControllers:vcs
                    style:[BHTabStyle defaultStyle]];

  UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
  iv.frame = self.window.frame;
  [self.window addSubview:iv];
  
  [self.window addSubview:viewController.view];
  [self.window makeKeyAndVisible];
  
  return YES;
}

- (void)dealloc {
  [viewController release];
  [_vc1 release];
  [_vc2 release];
  [_vc3 release];
  [_window release];
  [super dealloc];
}

@end
