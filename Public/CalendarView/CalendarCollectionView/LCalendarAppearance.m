//
//  LCalendarAppearance.m
//  LCalendar
//
//  Created by wujian on 2019/8/17.
//  Copyright © 2019 wesk痕. All rights reserved.
//

#import "LCalendarAppearance.h"
#import <UIKit/UIKit.h>

@implementation LCalendarAppearance

+ (instancetype)share{
    static dispatch_once_t onceToken;
    static LCalendarAppearance *appearance;
    dispatch_once(&onceToken, ^{
        appearance = [LCalendarAppearance new];
    });
    return  appearance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _weekDayHeight = 48;
        _weeksToDisplay = 6;
        _isShowSingleWeek = NO;
        _calendarBgColor = [UIColor whiteColor];
        _calendarScollBgColor = [UIColor whiteColor];
        _calendarScollChangeMinPadding = 20;
        
        _numPageLoaded = 5;
        _collectionMarginPadding = 20;
        _weekTipHeight = 42.0f;
        _weekTipColor = [UIColor colorWithRed:107/255.0 green:120/255.0 blue:132/255.0 alpha:1];
        
        _bottomArrowViewHeight = 36.0f;
        
        _calendarCellClass = nil;
        _itemCurrentMonthColor = [UIColor blackColor];
        _itemOtherMonthColor = [UIColor lightGrayColor];
        _itemTodayColor = [UIColor greenColor];
        _itemSelectedColor = [UIColor whiteColor];
        _itemCircleBgColor = [UIColor greenColor];
        _itemTipColor = [UIColor redColor];
        
    }
    return self;
}

- (NSCalendar *)calendar
{
    static NSCalendar *calendar;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
#ifdef __IPHONE_8_0
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
#endif
        calendar.timeZone = [NSTimeZone localTimeZone];
    });
    
    return calendar;
}

- (CGFloat)safeAreaInsetTop {
    CGFloat safeAreaInsetTop = 0;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (@available(iOS 11.0, *)) {
        if (keyWindow) {
            safeAreaInsetTop = keyWindow.safeAreaInsets.top;
        }
    }
    
    return safeAreaInsetTop;
//    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
//        return safeAreaInset.left > 0.0f;
//    }else {
//        // 非刘海屏状态栏 20
//        return safeAreaInset.top > 20.0f;
//    }
}
@end
