//
//  LCalendarContentView.h
//  LCalendar
//
//  Created by wujian on 2019/8/17.
//  Copyright © 2019 wesk痕. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
@protocol LCalendarContentViewDelegate <NSObject>

@required
/// 周视图翻页,刷新需要重置位置
- (void)resetContentView;

@optional

/// 需要展示的提示文案
- (NSString *)calendarTipStringWithDate:(NSDate *)date;

/// 该日期需要展示的提示文案的颜色
- (UIColor *)calendarTipStringColorWithDate:(NSDate *)date;

/// 点击 日期后的执行的操作
- (void)calendarDidSelectedDate:(NSDate *)date;

/// 当前日历时间变化
- (void)currentCalendarDateChanged:(NSDate *)date;

/// 翻页完成后的操作
- (void)calendarDidLoadPageCurrentDate:(NSDate *)date;

@end

@interface LCalendarContentView : UIView
/// 事件代理
@property (nonatomic, weak) id <LCalendarContentViewDelegate> delegate;

/// date: 日历展示的时间
- (void)initContenWithStartDate:(NSDate *)date;

/// 滚动到单周需要的offset
- (CGFloat)singleWeekOffsetY;

/// singleWeek YES:设置为周视图 NO:设置为月视图
- (void)setSingleWeek:(BOOL)singleWeek;

/// 上一页
- (void)loadPreviousPage;

/// 下一页
- (void)loadNextPage;

/// 页面刷新
- (void)reloadAppearance;

/// 展示指定的某一天
- (void)showDayViewWithDate:(NSDate *)date;

/// 更新遮罩镂空的位置
- (void)setUpVisualRegion;

@end

NS_ASSUME_NONNULL_END
