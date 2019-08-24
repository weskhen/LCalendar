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

#define KTopValue [UIApplication sharedApplication].statusBarFrame.size.height
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,LCalendarViewDelegate>

@property (nonatomic, strong) UILabel  *dateLael;
@property (nonatomic, strong) UIButton  *todayButton;
@property (nonatomic, strong) LCalendarView  *calendarView;
@property (nonatomic, strong) UITableView  *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LCalendarAppearance share].calendarCellClass = NSClassFromString(@"LCalendaeTestCell");
    // Do any additional setup after loading the view.
    [self.view addSubview:self.todayButton];
    [self.view addSubview:self.dateLael];
    [self.view addSubview:self.calendarView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.todayButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(KTopValue);
        }];
        [self.dateLael mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.todayButton);
            make.size.mas_equalTo(CGSizeMake(200, 40));
            make.centerX.mas_equalTo(0);
        }];
        [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KTopValue+44);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-49);
        }];
        [LCalendarAppearance share].isShowSingleWeek ? [self.calendarView showSignleWeekView]:[self.calendarView showMonthView];
    });
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
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
    
    self.dateLael.text = [dateFormatter stringFromDate:date];
}

- (NSString *)calendarTipStringWithDate:(NSDate *)date {
    return @"123";
}

#pragma mark - buttonEvent
- (void)todayButtonClicked:(id)sender {
    [self.calendarView loadAssignDayViewWithDate:[NSDate new]];
}

#pragma mark - getter
- (UILabel *)dateLael {
    if (!_dateLael) {
        _dateLael = [[UILabel alloc] init];
        _dateLael.textColor = [UIColor blackColor];
        _dateLael.font = [UIFont systemFontOfSize:17];
        _dateLael.textAlignment = NSTextAlignmentCenter;
    }
    return _dateLael;
}
- (UIButton *)todayButton {
    if (!_todayButton) {
        _todayButton = [[UIButton alloc] init];
        [_todayButton setTitle:@"今天" forState:UIControlStateNormal];
        [_todayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_todayButton addTarget:self action:@selector(todayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [[_todayButton titleLabel] setFont:[UIFont systemFontOfSize:13]];
    }
    return _todayButton;
}

- (LCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[LCalendarView alloc] initWithFrame:CGRectMake(0, 60, LScreenWidth, LScreenHeight) tableView:self.tableView delegate:self];
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
