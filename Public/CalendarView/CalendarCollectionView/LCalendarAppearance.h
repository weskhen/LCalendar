//
//  LCalendarAppearance.h
//  LCalendar
//
//  Created by wujian on 2019/8/17.
//  Copyright © 2019 wesk痕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define LScreenWidth [UIScreen mainScreen].bounds.size.width
#define LScreenHeight [UIScreen mainScreen].bounds.size.height

NS_ASSUME_NONNULL_BEGIN

@interface LCalendarAppearance : NSObject

/// 每一周视图的高度
@property (nonatomic, assign) CGFloat weekDayHeight;
/// 每个月视图显示多少周 
@property (nonatomic, assign) NSInteger weeksToDisplay;
/// 是否展示单周
@property (nonatomic, assign) BOOL isShowSingleWeek;
/// 日历背景颜色
@property (nonatomic, strong) UIColor *calendarBgColor;
/// 日历滚动区域的背景色
@property (nonatomic, strong) UIColor  *calendarScollBgColor;

/// 周视图和月视图 上下滑动需要改变状态的最小距离 默认20
@property (nonatomic, assign) CGFloat calendarScollChangeMinPadding;

/// 一次加载多少页数据(需是奇数)
@property (nonatomic, assign) NSUInteger numPageLoaded;

/// 日历距控件的左右两边的保留间距 左边保留间距=右边保留间距=collectionMarginPadding/2.0
@property (nonatomic, assign) CGFloat collectionMarginPadding;

/// 星期提示视图高度 默认42
@property (nonatomic, assign) CGFloat weekTipHeight;
/// 星期提示文案颜色 (日、一、二、三...)
@property (nonatomic, strong) UIColor  *weekTipColor;

/// 底部箭头视图的高度 默认36
@property (nonatomic, assign) CGFloat bottomArrowViewHeight;

#pragma mark - itemCell 颜色属性
/// 自定义Item对应的cell 必须是LCalendarBaseCell的子类 默认为空
@property (nonatomic, strong) Class calendarCellClass;

// 颜色选中优先级(选中>今日>当月/其他月)
/// 日历item中的日期在当前月显示的颜色
@property (nonatomic, strong) UIColor  *itemCurrentMonthColor;
/// 日历月视图下 item中的日期在其他月显示的颜色
@property (nonatomic, strong) UIColor  *itemOtherMonthColor;
/// 日历item中的日期在当日(未选中)显示的颜色
@property (nonatomic, strong) UIColor  *itemTodayColor;
/// 日历item中的日期在选中显示的颜色
@property (nonatomic, strong) UIColor  *itemSelectedColor;

/// 日历item中的日期在选中背景圆显示的颜色
@property (nonatomic, strong) UIColor  *itemCircleBgColor;

/// 日历副标题颜色
@property (nonatomic, strong) UIColor  *itemTipColor;

+ (instancetype)share;


- (NSCalendar *)calendar;

@end

NS_ASSUME_NONNULL_END
