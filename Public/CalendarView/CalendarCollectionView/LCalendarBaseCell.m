//
//  LCalendarBaseCell.m
//  LCalendar
//
//  Created by wujian on 2019/8/17.
//  Copyright © 2019 wesk痕. All rights reserved.
//

#import "LCalendarBaseCell.h"
#import "LCalendarDayItem.h"
#import "LCalendarAppearance.h"

@interface LCalendarBaseCell ()


@end
@implementation LCalendarBaseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.circleSelectedView];
        [self.contentView addSubview:self.dayLabel];
        [self.contentView addSubview:self.tipLabel];
        
        [self setupContentViewFrame];
    }
    return self;
}

- (void)setupContentViewFrame {
    CGRect bounds = self.contentView.bounds;
    _circleSelectedView.frame = CGRectMake((CGRectGetWidth(bounds)-24)/2.0, (CGRectGetHeight(bounds)-24)/2.0, 24, 24);
    _dayLabel.frame = _circleSelectedView.frame;
    _tipLabel.frame = CGRectMake(0, 34, CGRectGetWidth(bounds), 14);
}

#pragma mark - publicMethod
- (void)reloadContentViewWithItem:(LCalendarDayItem *)item {
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = [LCalendarAppearance share].calendar.timeZone;
        [dateFormatter setDateFormat:@"dd"];
    }
    NSString *dayNum = @"今";
    if (!item.isToday) {
        dayNum = [dateFormatter stringFromDate:item.date];
        if ([dayNum hasPrefix:@"0"]) {
            dayNum = [dayNum substringFromIndex:1];
        }
    }
    self.dayLabel.text = dayNum;
    
    if (item.isSelected) {
        self.dayLabel.textColor = [LCalendarAppearance share].itemSelectedColor;
    } else {
        if (item.isToday) {
            self.dayLabel.textColor = [LCalendarAppearance share].itemTodayColor;
        } else {
            if (item.isOtherMonth && ![LCalendarAppearance share].isShowSingleWeek) {
                self.dayLabel.textColor = [LCalendarAppearance share].itemOtherMonthColor;
            } else {
                self.dayLabel.textColor = [LCalendarAppearance share].itemCurrentMonthColor;
            }
        }
    }
    
    self.tipLabel.text = item.tipString;
    if (item.tipColor) {
        self.tipLabel.textColor = item.tipColor;
    }
    self.circleSelectedView.hidden = !item.isSelected;
    
}

#pragma mark - getter
- (UIView *)circleSelectedView {
    if (!_circleSelectedView) {
        _circleSelectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        _circleSelectedView.backgroundColor = [LCalendarAppearance share].itemCircleBgColor;
        _circleSelectedView.layer.cornerRadius = 12;
        _circleSelectedView.layer.masksToBounds = YES;
    }
    return _circleSelectedView;
}
- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [UILabel new];
        _dayLabel.textColor = [LCalendarAppearance share].itemCurrentMonthColor;
        _dayLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.backgroundColor = [UIColor clearColor];
    }
    return _dayLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.textColor = [LCalendarAppearance share].itemTipColor;
        _tipLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.backgroundColor = [UIColor clearColor];
    }
    return _tipLabel;
}


@end
