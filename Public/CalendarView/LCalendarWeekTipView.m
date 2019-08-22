//
//  LCalendarWeekTipView.m
//  LCalendar
//
//  Created by wujian on 2019/8/17.
//  Copyright © 2019 wesk痕. All rights reserved.
//

#import "LCalendarWeekTipView.h"
#import "LCalendarAppearance.h"

#define KDayOfWeekLabelWidth (LScreenWidth-[LCalendarAppearance share].collectionMarginPadding)/7.0


@interface LCalendarWeekTipView ()

@property (nonatomic, strong) NSArray  *dayOfWeekList;

@end

@implementation LCalendarWeekTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i = 0; i < self.dayOfWeekList.count; i ++) {
            NSString *day = [self.dayOfWeekList objectAtIndex:i];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10+i*KDayOfWeekLabelWidth, 0, KDayOfWeekLabelWidth, frame.size.height)];
            label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
            label.textColor = [LCalendarAppearance share].weekTipColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = day;
            [self addSubview:label];
        }
    }
    return self;
}

#pragma mark - getter
- (NSArray *)dayOfWeekList {
    if (!_dayOfWeekList) {
        _dayOfWeekList = [[NSArray alloc] initWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
    }
    return _dayOfWeekList;
}


@end
