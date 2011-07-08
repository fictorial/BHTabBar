#import <UIKit/UIKit.h>

@class BHTabView;
@class BHTabStyle;

@protocol BHTabViewDelegate <NSObject>
- (void)didTapTabView:(BHTabView *)tabView;
@end

@interface BHTabView : UIView

@property (nonatomic, retain, readonly) UILabel *titleLabel;
@property (nonatomic, assign) id <BHTabViewDelegate> delegate;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, retain) BHTabStyle *style;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
