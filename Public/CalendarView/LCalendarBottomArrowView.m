//
//  LCalendarBottomArrowView.m
//  LCalendar
//
//  Created by wujian on 2019/8/17.
//  Copyright © 2019 wesk痕. All rights reserved.
//

#import "LCalendarBottomArrowView.h"
#import <Masonry/Masonry.h>

@interface LCalendarBottomArrowView ()

@property (nonatomic, strong) UIButton  *arrowButton;

@end
@implementation LCalendarBottomArrowView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.arrowButton];
        [_arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(57, 32));
            make.bottom.mas_equalTo(-4);
        }];
    }
    return self;
}

#pragma mark - publicMethod
- (void)changeBottomArrowState:(BOOL)isWeekView {
    [self.arrowButton setSelected:isWeekView];
    [_arrowButton setImage:[UIImage imageNamed:isWeekView?@"LCalendarView_downArrow":@"LCalendarView_upArrow"] forState:UIControlStateNormal];
}

#pragma mark - buttonEvent
- (void)arrowButtonClicked:(id)sender {
    BOOL isSelected = self.arrowButton.isSelected;
    if (isSelected) {
        if ([self.delegate respondsToSelector:@selector(executeShowMonthView)]) {
            [self.delegate executeShowMonthView];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(executeShowWeekView)]) {
            [self.delegate executeShowWeekView];
        }
    }
}

#pragma mark - getter
- (UIButton *)arrowButton {
    if (!_arrowButton) { // 17 8
        _arrowButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 32)];
        [_arrowButton setImage:[UIImage imageNamed:@"LCalendarView_downArrow"] forState:UIControlStateNormal];
        [_arrowButton setImageEdgeInsets:UIEdgeInsetsMake(12, 20, 12, 20)];
        [_arrowButton addTarget:self action:@selector(arrowButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrowButton;
}

@end
