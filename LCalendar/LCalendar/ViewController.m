//
//  ViewController.m
//  LCalendar
//
//  Created by wujian on 2019/8/17.
//  Copyright © 2019 wesk痕. All rights reserved.
//

#import "ViewController.h"
#import <LCalendar/LCalendarView.h>
#import <LCalendar/LCalendarAppearance.h>
#import <Masonry/Masonry.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,LCalendarViewDelegate>

@property (nonatomic, strong) LCalendarView  *calendarView;
@property (nonatomic, strong) UITableView  *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LCalendarAppearance share].calendarCellClass = NSClassFromString(@"LCalendaeTestCell");
    // Do any additional setup after loading the view.
    [self.view addSubview:self.calendarView];
    [_calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-49);
    }];
    [LCalendarAppearance share].isShowSingleWeek ? [self.calendarView showSignleWeekView]:[self.calendarView showMonthView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellIdentifier = NSStringFromSelector(_cmd);
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    NSInteger row = indexPath.row;
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - LCalendarViewDelegate

- (void)currentViewDateChanged:(NSDate *)date {
    NSLog(@"日期选择改变%@",date);
}

- (NSString *)calendarTipStringWithDate:(NSDate *)date {
    return @"123";
}

#pragma mark - getter
- (LCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[LCalendarView alloc] initWithFrame:CGRectMake(0, 60, LScreenWidth, LScreenHeight) tableView:self.tableView];
        _calendarView.calendarDelegate = self;
    }
    return _calendarView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat tableHeight = LScreenHeight-[LCalendarAppearance share].bottomArrowViewHeight-[LCalendarAppearance share].weekDayHeight;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LScreenWidth, tableHeight)];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


@end
