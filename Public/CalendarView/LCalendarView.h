//
//  LCalendarView.h
//  LCalendar
//
//  Created by wujian on 2019/8/17.
//  Copyright © 2019 wesk痕. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LCalendarViewDelegate <NSObject>

/// 日期发生改变的回调
- (void)currentViewDateChanged:(NSDate *)date;

/// 日期下部分 展示的文案
- (NSString *)calendarTipStringWithDate:(NSDate *)date;

@end

@interface LCalendarView : UIView

@property (nonatomic, weak) id <LCalendarViewDelegate> calendarDelegate;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/// tableView 传入不能为空
- (instancetype)initWithFrame:(CGRect)frame tableView:(UITableView *)tableView;

/// 展示周视图
- (void)showSignleWeekView;

/// 展示月视图
- (void)showMonthView;

/// 上一页
- (void)loadPreviousPage;

/// 下一页
- (void)loadNextPage;

/// 展示View指定的日期
- (void)loadAssignDayViewWithDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
