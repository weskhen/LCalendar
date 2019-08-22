//
//  LCalendarBottomArrowView.h
//  LCalendar
//
//  Created by wujian on 2019/8/17.
//  Copyright © 2019 wesk痕. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LCalendarBottomArrowViewDelegate <NSObject>

// 展示月视图
- (void)executeShowMonthView;
// 展示周视图
- (void)executeShowWeekView;

@end



@interface LCalendarBottomArrowView : UIView

@property (nonatomic, weak) id <LCalendarBottomArrowViewDelegate> delegate;

/// 改变底部图标 isSigleWeek 是否展示的是周视图
- (void)changeBottomArrowState:(BOOL)isWeekView;

@end

NS_ASSUME_NONNULL_END
