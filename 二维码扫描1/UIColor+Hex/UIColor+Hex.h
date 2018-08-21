
#import <UIKit/UIKit.h>

#define ALTERNATIVE_THEME (0)

#define DGYellowColor [UIColor colorWithHex:0xFFD600]
#define DGYellowColorWithAlpha(a) [UIColor colorWithHex:0xFFD600 alpha:a]

#if ALTERNATIVE_THEME

#define DGMainColor [UIColor colorWithHex:0xEA423C]
#define DGMainColorWithAlpha(a) [UIColor colorWithHex:0xEA423C alpha:a]
#define DGContentColor [UIColor colorWithHex:0xFFE8D1]
#define DGContentColorWithAlpha(a) [UIColor colorWithHex:0xFFE8D1 alpha:a]

#else

#define DGMainColor DGYellowColor
#define DGMainColorWithAlpha(a) DGYellowColorWithAlpha(a)
#define DGContentColor [UIColor colorWithHex:0x000000]
#define DGContentColorWithAlpha(a) [UIColor colorWithHex:0x000000 alpha:a]

#endif

@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(NSInteger)hexValue;
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (NSString *)hexFromUIColor:(UIColor *)color;

@end
