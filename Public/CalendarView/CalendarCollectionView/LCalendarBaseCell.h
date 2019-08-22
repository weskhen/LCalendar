//
//  LCalendarBaseCell.h
//  LCalendar
//
//  Created by wujian on 2019/8/17.
//  Copyright © 2019 wesk痕. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCalendarDayItem;

NS_ASSUME_NONNULL_BEGIN

@interface LCalendarBaseCell : UICollectionViewCell

@property (nonatomic, strong) UIView  *circleSelectedView;
@property (nonatomic, strong) UILabel  *dayLabel;
@property (nonatomic, strong) UILabel  *tipLabel;

/// 控件刷新方法
- (void)reloadContentViewWithItem:(LCalendarDayItem *)item;

/// 可以重写控件的位置
- (void)setupContentViewFrame;
@end

NS_ASSUME_NONNULL_END
