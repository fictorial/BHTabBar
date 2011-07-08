#import "BHTabView.h"
#import "BHTabStyle.h"

// It's best to reference the visual guide to the path of the tab.
// See the Docs/tab-analysis.png file.
// The view width is divided into 4 horizontal sections.
// Each section is divided by a 20 x 16 grid.
// The control points were visually laid out atop this grid.

#define kHorizontalSectionCount           4
#define kGridWidthInSection               16
#define kGridHeight                       20
#define kTabHeightInGridUnits             17
#define kBottomControlPointDXInGridUnits  8
#define kBottomControlPointDYInGridUnits  1
#define kTopControlPointDXInGridUnits     10

static inline CGFloat radians(CGFloat degrees) {
  return degrees * M_PI/180;
}

@interface BHTabView ()

@property (nonatomic, retain, readwrite) UILabel *titleLabel;

- (CGFloat)_sectionWidth;
- (CGSize)_gridSize;
- (CGRect)_tabRect;
- (CGMutablePathRef)_makeTabPath;

@end

@implementation BHTabView

@synthesize titleLabel, delegate, selected, style;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title {
  if ((self = [super initWithFrame:frame])) {
    self.userInteractionEnabled = YES;

    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.style = [BHTabStyle defaultStyle];

    CGRect labelFrame = [self _tabRect];
    self.titleLabel = [[[UILabel alloc] initWithFrame:labelFrame] autorelease];
    self.titleLabel.text = title;
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    self.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = self.style.unselectedTitleTextColor;
    self.titleLabel.shadowColor = self.style.unselectedTitleShadowColor;
    self.titleLabel.shadowOffset = self.style.unselectedTitleShadowOffset;
    [self addSubview:self.titleLabel];

    [self addGestureRecognizer:[[[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(_onTap:)] autorelease]];
  }

  return self;
}

- (void)_configureTitleLabel {
  if (self.selected) {
    self.titleLabel.textColor    = self.style.selectedTitleTextColor;
    self.titleLabel.shadowColor  = self.style.selectedTitleShadowColor;
    self.titleLabel.shadowOffset = self.style.selectedTitleShadowOffset;
    self.titleLabel.font         = self.style.selectedTitleFont;
  } else {
    self.titleLabel.textColor    = self.style.unselectedTitleTextColor;
    self.titleLabel.shadowColor  = self.style.unselectedTitleShadowColor;
    self.titleLabel.shadowOffset = self.style.unselectedTitleShadowOffset;
    self.titleLabel.font         = self.style.unselectedTitleFont;
  }
}

- (void)_onTap:(UIGestureRecognizer *)gesture {
  UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *) gesture;
  if (tapGesture.state == UIGestureRecognizerStateEnded) {
    if ([self.delegate respondsToSelector:@selector(didTapTabView:)]) {
      [self.delegate didTapTabView:self];
    }
  }
}

- (CGFloat)_sectionWidth {
  return self.frame.size.width / kHorizontalSectionCount;
}

- (CGSize)_gridSize {
  return CGSizeMake([self _sectionWidth] / kGridWidthInSection,
                    self.frame.size.height / kGridHeight);
}

- (CGRect)_tabRect {
  CGFloat tabHeight = [self _gridSize].height * kTabHeightInGridUnits;
  return CGRectMake(0, self.frame.size.height - tabHeight + 0.5,
                    self.frame.size.width - 0.5, tabHeight);
}

- (CGMutablePathRef)_makeTabPath {
  CGFloat sectionWidth = [self _sectionWidth];
  CGSize  gridSize     = [self _gridSize];
  CGRect  tabRect      = [self _tabRect];

  CGFloat tabLeft   = tabRect.origin.x + 0.5;
  CGFloat tabRight  = tabRect.origin.x + tabRect.size.width - 0.5;
  CGFloat tabTop    = tabRect.origin.y + 0.5;
  CGFloat tabBottom = tabRect.origin.y + tabRect.size.height - 0.5;

  CGFloat bottomControlPointDX = gridSize.width  * kBottomControlPointDXInGridUnits;
  CGFloat bottomControlPointDY = gridSize.height * kBottomControlPointDYInGridUnits;
  CGFloat topControlPointDX    = gridSize.width  * kTopControlPointDXInGridUnits;

  CGMutablePathRef path = CGPathCreateMutable();

  CGPathMoveToPoint(path, NULL, tabLeft, tabBottom);

  CGPathAddCurveToPoint(path, NULL,
                        bottomControlPointDX, tabBottom - bottomControlPointDY,
                        sectionWidth - topControlPointDX, tabTop,
                        sectionWidth, tabTop);

  CGPathAddLineToPoint(path, NULL, tabRight - sectionWidth, tabTop);

  CGPathAddCurveToPoint(path, NULL,
                        tabRight - sectionWidth + topControlPointDX, tabTop,
                        tabRight - bottomControlPointDX, tabBottom - bottomControlPointDY,
                        tabRight, tabBottom);

  return path;
}

- (void)drawRect:(CGRect)rect {
  CGMutablePathRef path = [self _makeTabPath];

  CGContextRef context = UIGraphicsGetCurrentContext();

  // Configure a linear gradient which adds a simple white highlight on the top.

  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGFloat locations[] = { 0.0, 0.4 };

  CGColorRef tabColor = (self.selected
                         ? self.style.selectedTabColor.CGColor
                         : self.style.unselectedTabColor.CGColor);

  CGColorRef startColor = [UIColor whiteColor].CGColor;
  CGColorRef endColor   = tabColor;
  NSArray    *colors    = [NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];

  CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, locations);

  CGRect  tabRect    = [self _tabRect];
  CGPoint startPoint = CGPointMake(CGRectGetMidX(tabRect), tabRect.origin.y);
  CGPoint endPoint   = CGPointMake(CGRectGetMidX(tabRect), tabRect.origin.y + tabRect.size.height);

  // Fill with current tab color

  CGContextSaveGState(context);
  CGContextAddPath(context, path);
  CGContextSetFillColorWithColor(context, tabColor);
  CGContextSetShadow(context, CGSizeMake(0, -1), self.style.shadowRadius);
  CGContextFillPath(context);
  CGContextRestoreGState(context);

  // Render the interior of the tab path using the gradient.

  CGContextSaveGState(context);
  CGContextAddPath(context, path);
  CGContextClip(context);
  CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
  CGContextRestoreGState(context);
  CGGradientRelease(gradient);
  CGColorSpaceRelease(colorSpace);

  CFRelease(path);

  [self _configureTitleLabel];
}

- (void)setSelected:(BOOL)isSelected {
  selected = isSelected;
  [self setNeedsDisplay];
}

- (void)dealloc {
  self.titleLabel = nil;
  self.style = nil;

  [super dealloc];
}

@end
