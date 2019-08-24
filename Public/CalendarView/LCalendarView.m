//
//  LCalendarView.m
//  LCalendar
//
//  Created by wujian on 2019/8/17.
//  Copyright © 2019 wesk痕. All rights reserved.
//

#import "LCalendarView.h"
#import "LCalendarContentView.h"
#import "LCalendarBottomArrowView.h"
#import "LCalendarWeekTipView.h"
#import "LCalendarAppearance.h"
#import <Masonry/Masonry.h>

#define KCalendarWeekTipHeight [LCalendarAppearance share].weekTipHeight
#define KCalendarMovingPadding [LCalendarAppearance share].calendarScollChangeMinPadding
#define KCalendarBottomArrowViewHeight [LCalendarAppearance share].bottomArrowViewHeight
#define KCalendarViewHeight [LCalendarAppearance share].weekDayHeight*[LCalendarAppearance share].weeksToDisplay
#define KTableCountDistance [LCalendarAppearance share].weekDayHeight*([LCalendarAppearance share].weeksToDisplay-1)

@interface LCalendarView ()<LCalendarBottomArrowViewDelegate,UIScrollViewDelegate,LCalendarContentViewDelegate,LCalendarBottomArrowViewDelegate>

@property (nonatomic, strong) LCalendarWeekTipView  *weekTipView;

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) LCalendarContentView *calendarView;
@property (nonatomic, strong) LCalendarBottomArrowView  *arrowView;
@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, weak) id <LCalendarViewDelegate> delegate;

@end
@implementation LCalendarView

- (instancetype)initWithFrame:(CGRect)frame tableView:(UITableView *)tableView delegate:(id <LCalendarViewDelegate> )delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        self.tableView = tableView;
        [self addSubview:self.weekTipView];
        [self addSubview:self.scrollView];
        
        [self.scrollView addSubview:self.calendarView];
        [self.scrollView addSubview:self.arrowView];
        [self.scrollView addSubview:self.tableView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KCalendarWeekTipHeight);
            make.left.right.bottom.mas_equalTo(0);
        }];
        [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.calendarView);
            make.height.mas_equalTo(KCalendarBottomArrowViewHeight);
            make.bottom.equalTo(self.tableView.mas_top);
        }];
        _tableView.scrollEnabled = [LCalendarAppearance share].isShowSingleWeek;
        
        CGFloat tableHeight = CGRectGetHeight(self.scrollView.frame)-KCalendarBottomArrowViewHeight-([LCalendarAppearance share].isShowSingleWeek ? [LCalendarAppearance share].weekDayHeight : KTableCountDistance);
        _tableView.frame = CGRectMake(0, KCalendarViewHeight+KCalendarBottomArrowViewHeight, LScreenWidth, tableHeight);
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.contentSize = CGSizeMake(0, CGRectGetHeight(self.scrollView.frame)+KTableCountDistance);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    ///表需要滑动的距离
    CGFloat tableCountDistance = KTableCountDistance;
    // 周视图和月视图 不在固定的点触发(说明处于滚动过程中或代码Bug了) 不响应事件
    if ([LCalendarAppearance share].isShowSingleWeek) {
        if (self.scrollView.contentOffset.y != tableCountDistance) {
            return  nil;
        }
    }
    if (![LCalendarAppearance share].isShowSingleWeek) {
        if (self.scrollView.contentOffset.y != 0 ) {
            return  nil;
        }
    }
    
    return  [super hitTest:point withEvent:event];
}

#pragma mark - publicMethod
- (void)showSignleWeekView {
    [self scrollToSingleWeek];
}

- (void)showMonthView {
    [self scrollToAllWeek];
}

- (void)loadPreviousPage {
    [self.calendarView loadPreviousPage];
}

- (void)loadNextPage {
    [self.calendarView loadNextPage];
}

- (void)loadAssignDayViewWithDate:(NSDate *)date {
    [self.calendarView showDayViewWithDate:date];
}

#pragma mark - privateMethod
- (void)scrollToSingleWeek {
    if (self.scrollView.contentOffset.y == KTableCountDistance) {
        [self.calendarView setSingleWeek:YES];
        [self.arrowView changeBottomArrowState:YES];
    }
    [self.scrollView setContentOffset:CGPointMake(0, KTableCountDistance) animated:YES];
}

- (void)scrollToAllWeek {
    if (self.scrollView.contentOffset.y == 0) {
        [self.calendarView setSingleWeek:NO];
        [self.arrowView changeBottomArrowState:NO];
    }
    /// 滑动到顶点
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}


- (void)scrollViewCheckToStop:(UIScrollView *)scrollView {
    ///表需要滑动的距离
    CGFloat tableCountDistance = KTableCountDistance;
    //point.y<0向上
    CGPoint point = [scrollView.panGestureRecognizer translationInView:scrollView];
    
    if (point.y <= 0) {
        if (scrollView.contentOffset.y >= KCalendarMovingPadding) {
            [self scrollToSingleWeek];
        }else{
            [self scrollToAllWeek];
        }
    }else{
        if (scrollView.contentOffset.y < (tableCountDistance - KCalendarMovingPadding)) {
            [self scrollToAllWeek];
        }else{
            [self scrollToSingleWeek];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView != self.scrollView) {
        return;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    ///表需要滑动的距离
    CGFloat tableCountDistance = KTableCountDistance;
    if (offsetY > tableCountDistance) {
        self.scrollView.contentOffset = CGPointMake(0, tableCountDistance);
        return;
    }
    
    ///日历需要滑动的距离
    CGFloat calendarCountDistance = [self.calendarView singleWeekOffsetY];
    CGFloat scale = calendarCountDistance/tableCountDistance;
    
    CGRect calendarFrame = self.calendarView.frame;
    self.calendarView.maskView.alpha = offsetY/tableCountDistance;
    self.calendarView.maskView.hidden = NO;
    calendarFrame.origin.y = offsetY-offsetY*scale;
    _calendarView.frame = calendarFrame;
    
    if(ABS(offsetY) >= tableCountDistance) {
        self.tableView.scrollEnabled = YES;
        self.calendarView.maskView.hidden = YES;
    } else {
        _tableView.scrollEnabled = NO;
    }
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = CGRectGetHeight(self.scrollView.frame)-CGRectGetHeight(calendarFrame)-KCalendarBottomArrowViewHeight+offsetY;
    _tableView.frame = tableFrame;
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.scrollView != scrollView) {
        return;
    }
    
    ///表示需要滑动的距离   调用setContentOffset 触发
    CGFloat tableCountDistance = KTableCountDistance;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= tableCountDistance) {
        [self.calendarView setSingleWeek:YES];
        [self.arrowView changeBottomArrowState:YES];
    }
    if (offsetY <= 0) {
        [self.calendarView setSingleWeek:NO];
        [self.arrowView changeBottomArrowState:NO];
    }
}

/// 开始减速
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self.scrollView != scrollView) {
        return;
    }
    [self scrollViewCheckToStop:scrollView];
}

/// scrollView 结束拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.scrollView != scrollView) {
        return;
    }
    /// 非减速
    if (!decelerate) {
        [self scrollViewCheckToStop:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.calendarView setUpVisualRegion];
}


#pragma mark - XHXCalendarContentViewDelegate

/// 该日期需要展示的提示文案
- (NSString *)calendarTipStringWithDate:(NSDate *)date {
    if ([self.delegate respondsToSelector:@selector(calendarTipStringWithDate:)]) {
        return [self.delegate calendarTipStringWithDate:date];
    }
    return nil;
}

- (void)calendarDidSelectedDate:(NSDate *)date {
    NSLog(@"当前日期手动选中:::%@",date);
}

- (void)currentCalendarDateChanged:(NSDate *)date {
    if ([self.delegate respondsToSelector:@selector(currentViewDateChanged:)]) {
        [self.delegate currentViewDateChanged:date];
    }
}

- (void)calendarDidLoadPageCurrentDate:(NSDate *)date {
    NSLog(@"当前日期滑动选中:::%@",date);
}

- (void)resetContentView {
    ///日历需要强制到指定的位置
    CGFloat calendarCountDistance = [self.calendarView singleWeekOffsetY];
    CGRect calendarFrame = self.calendarView.frame;
    calendarFrame.origin.y = KTableCountDistance-calendarCountDistance;
    self.calendarView.frame = calendarFrame;
}

#pragma mark - LCalendarBottomArrowViewDelegate

- (void)executeShowMonthView {
    [self scrollToAllWeek];
}

- (void)executeShowWeekView {
    [self scrollToSingleWeek];
}


#pragma mark - getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, LScreenWidth, LScreenHeight)];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [LCalendarAppearance share].calendarScollBgColor;
    }
    return _scrollView;
}
- (LCalendarWeekTipView *)weekTipView {
    if (!_weekTipView) {
        _weekTipView = [[LCalendarWeekTipView alloc] initWithFrame:CGRectMake(0, 0, LScreenWidth, KCalendarWeekTipHeight)];
    }
    return _weekTipView;
}

- (LCalendarContentView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[LCalendarContentView alloc] initWithFrame:CGRectMake(0, 0, LScreenWidth, KCalendarViewHeight)];
        _calendarView.delegate = self;
        [_calendarView initContenWithStartDate:[NSDate date]];
    }
    return _calendarView;
}

- (LCalendarBottomArrowView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[LCalendarBottomArrowView alloc] initWithFrame:CGRectMake(0, 0, LScreenWidth, KCalendarBottomArrowViewHeight)];
        _arrowView.delegate = self;
    }
    return _arrowView;
}

@end
