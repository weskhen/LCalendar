//
//  LCalendarDayItem.h
//  LCalendar
//
//  Created by wujian on 2019/8/17.
//  Copyright © 2019 wesk痕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCalendarDayItem : NSObject

/// item日期
@property (nonatomic, strong) NSDate *date;
/// 是否是其他月份
@property (nonatomic, assign) BOOL isOtherMonth;
/// 日期是否是今天
@property (nonatomic, assign) BOOL isToday;
/// 是否是选中的日期
@property (nonatomic, assign) BOOL isSelected;
/// 展示的注释文案
@property (nonatomic, strong) NSString  *tipString;
/// 注释文案颜色
@property (nonatomic, strong) UIColor  *tipColor;

@end

NS_ASSUME_NONNULL_END
