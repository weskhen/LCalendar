//
//  LCalendarContentView.m
//  LCalendar
//
//  Created by wujian on 2019/8/17.
//  Copyright © 2019 wesk痕. All rights reserved.
//

#import "LCalendarContentView.h"
#import "LCalendarCollectionFlowLayout.h"
#import "LCalendarAppearance.h"
#import "LCalendarBaseCell.h"
#import "LCalendarDayItem.h"

#define NUMBER_PAGES_LOADED [LCalendarAppearance share].numPageLoaded
#define KCollectionMargin [LCalendarAppearance share].collectionMarginPadding/2.0
#define KCollectionWidth (LScreenWidth-[LCalendarAppearance share].collectionMarginPadding)

@interface LCalendarContentView ()<UICollectionViewDelegate, UICollectionViewDataSource>

/// 当前时间
@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, strong) UICollectionView *collectionView;

/// 遮罩
@property (nonatomic, strong) UIView *maskView;

/// YES:点击日期改变页数  NO:滑动日期改变页数
@property (nonatomic, assign) BOOL isClickChangePage;
/// 是否是上一页
@property (nonatomic, assign) BOOL isLoadPrevious;
/// 是否是下一页
@property (nonatomic, assign) BOOL isLoadNext;
/// 当前视图的月份
@property (nonatomic, assign) NSInteger currentMonthIndex;

/// 月视图展示的数据 (7* 行数)
@property (nonatomic, strong) NSArray<NSArray<LCalendarDayItem *> *> *daysInMonth;

/// 周视图展示的数据 (7* 行数)
@property (nonatomic, strong) NSArray<NSArray<LCalendarDayItem *> *> *daysInWeeks;

/// 当前选中indexPath.item值 即位置
@property (nonatomic, assign) NSInteger currentSelectedItem;

@end
@implementation LCalendarContentView

- (instancetype)initWithFrame:(CGRect)frame currentDate:(NSDate *)date
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentDate = date;

        self.backgroundColor = [LCalendarAppearance share].calendarBgColor;
        [self addSubview:self.collectionView];
        
        [self reloadDateDatas];
        [self addSubview:self.maskView];
    }
    return self;
}

#pragma mark - publicMethod
- (void)setSingleWeek:(BOOL)singleWeek {
    [LCalendarAppearance share].isShowSingleWeek = singleWeek;
    [self reloadDateDatas];
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadData];
    }];
}

- (CGFloat)singleWeekOffsetY {
    return self.currentSelectedItem/7*[LCalendarAppearance share].weekDayHeight;
}

- (void)loadNextPage{
    self.isLoadPrevious = NO;
    self.isLoadNext = YES;
    [self.collectionView setContentOffset:CGPointMake(KCollectionWidth*(round(NUMBER_PAGES_LOADED/2)+1), 0) animated:YES];
    
}
- (void)loadPreviousPage{
    self.isLoadPrevious = YES;
    self.isLoadNext = NO;
    [self.collectionView setContentOffset:CGPointMake(KCollectionWidth*(round(NUMBER_PAGES_LOADED/2)-1), 0) animated:YES];
}

- (void)reloadAppearance {
    [self reloadDateDatas];
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadData];
    }];
}

- (void)showDayViewWithDate:(NSDate *)date {
    self.currentDate = date;
    [self reloadAppearance];
    [self checkRefreshFrame];
}


- (void)setUpVisualRegion {
    UIBezierPath *bpath = [UIBezierPath bezierPathWithRoundedRect:self.maskView.bounds cornerRadius:0];
    NSCalendar *calendar = [LCalendarAppearance share].calendar;
    NSDateComponents *components =[calendar components:NSCalendarUnitWeekOfMonth fromDate:self.currentDate];
    CGFloat orignY = (components.weekOfMonth-1)*[LCalendarAppearance share].weekDayHeight;
    CGRect frame = CGRectMake(0 , orignY, self.bounds.size.width, [LCalendarAppearance share].weekDayHeight);
    //贝塞尔曲线 画一个圆形
    [bpath appendPath:[[UIBezierPath bezierPathWithRect:frame] bezierPathByReversingPath]];
    ((CAShapeLayer *)self.maskView.layer.mask).path = bpath.CGPath;
}

#pragma mark - privateMethod
/// 刷新数据
- (void)reloadDateDatas {
    NSCalendar *calendar = [LCalendarAppearance share].calendar;
    if (self.currentDate == nil) {
        self.currentDate = [NSDate date];
    }
    
    if ([LCalendarAppearance share].isShowSingleWeek) {
        NSMutableArray *daysInWeeks = [[NSMutableArray alloc] init];
        for(int i = 0; i < NUMBER_PAGES_LOADED; i++){
            NSDateComponents *dayComponent = [NSDateComponents new];
            if (i == NUMBER_PAGES_LOADED/2) {
                // 中间的数据用当月的视图数据
                dayComponent.month = 0;
                NSDate *monthDate = [calendar dateByAddingComponents:dayComponent toDate:self.currentDate options:0];
                monthDate = [self beginningOfMonth:monthDate];
                [daysInWeeks addObject:[self getDaysOfMonth:monthDate]];
            } else {
                dayComponent.weekOfYear = i - NUMBER_PAGES_LOADED / 2;
                // 获取前两周和后两周的日期
                NSDate *weakDate = [calendar dateByAddingComponents:dayComponent toDate:[self beginningOfWeek:self.currentDate] options:0];
                self.currentMonthIndex = [self monthIndexForDate:self.currentDate];
                NSMutableArray *tempList = [[NSMutableArray alloc] init];
                NSArray<LCalendarDayItem *> *list = [self getDaysOfWeek:weakDate];
                for (NSInteger i = 0; i<[LCalendarAppearance share].weeksToDisplay; i++) {
                    [tempList addObjectsFromArray:list];
                }
                [daysInWeeks addObject:tempList];
            }
            
        }
        self.daysInWeeks = daysInWeeks;
    }else{
        NSMutableArray *daysInMonths = [[NSMutableArray alloc] init];
        for(int i = 0; i < NUMBER_PAGES_LOADED; i++){
            NSDateComponents *dayComponent = [NSDateComponents new];
            dayComponent.month = i - NUMBER_PAGES_LOADED / 2;
            //当前日期前两个月  与  后两个月
            NSDate *monthDate = [calendar dateByAddingComponents:dayComponent toDate:self.currentDate options:0];
            monthDate = [self beginningOfMonth:monthDate];
            [daysInMonths addObject:[self getDaysOfMonth:monthDate]];
        }
        
        self.daysInMonth = daysInMonths;
    }
    
    ///滚动到中间的位置，停止滚动后 始终滚动是在中间
    [self.collectionView setContentOffset:CGPointMake(KCollectionWidth*round(NUMBER_PAGES_LOADED/2), 0)];
}

/// 更新页面
- (void)updatePageWithNewDate:(BOOL)isNew
{
    //如果是显示周 默认 选中该周第一天
    //如果是月 默认 选中已选天数的日 若没有该日 则选中该月最后一天
    NSDate *currentDate = [self getNewCurrentDate];
    if (!currentDate) {
        currentDate = self.currentDate;
    }
    
    if (!isNew) {
        currentDate = self.currentDate;
    }
    
    self.currentDate = currentDate;
    [self reloadDateDatas];
}

/// 根据规则获取高亮的那天
- (NSDate *)getNewCurrentDate{
    CGFloat pageWidth = KCollectionWidth;
    CGFloat fractionalPage = self.collectionView.contentOffset.x / pageWidth;
    
    int currentPage = roundf(fractionalPage);
    
    if (currentPage == round(NUMBER_PAGES_LOADED / 2) && [LCalendarAppearance share].isShowSingleWeek){
        self.collectionView.scrollEnabled = YES;
        return nil;
    }
    
    NSCalendar *calendar = [LCalendarAppearance share].calendar;
    NSDateComponents *dayComponent = [NSDateComponents new];
    NSDate *currentDate;
    if ([LCalendarAppearance share].isShowSingleWeek) {
        // 如果是周 滑动到下一周默认选中该周
        dayComponent.weekOfYear = currentPage - (NUMBER_PAGES_LOADED / 2);
        currentDate = [calendar dateByAddingComponents:dayComponent toDate:self.currentDate options:0];
    } else {
        
        dayComponent.day = 0;
        dayComponent.month = currentPage - (NUMBER_PAGES_LOADED / 2);
        currentDate = [calendar dateByAddingComponents:dayComponent toDate:[self firstDayInMonth:self.currentDate] options:0];
    }
    
    return currentDate;
}

/// 返回该日期周开始的第一天
- (NSDate *)beginningOfWeek:(NSDate *)date{
    NSCalendar *calendar = [LCalendarAppearance share].calendar;
    NSDateComponents *componentsCurrentDate =[calendar components:NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
    NSInteger index = componentsCurrentDate.weekday-[LCalendarAppearance share].calendar.firstWeekday%7;
    if (index < 0) {
        index += 7;
    } else {
        
    }
    NSTimeInterval first = date.timeIntervalSince1970-index*24*3600;
    return [NSDate dateWithTimeIntervalSince1970:first];
}

- (NSDate *)firstDayInMonth:(NSDate *)date{
    NSCalendar *calendar = [LCalendarAppearance share].calendar;
    NSDateComponents *componentsCurrentDate =[calendar components:NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
    NSInteger index = componentsCurrentDate.day-1;
    NSTimeInterval first = date.timeIntervalSince1970-index*24*3600;
    return [NSDate dateWithTimeIntervalSince1970:first];
}

/// 返回该日期处于哪一个月
- (NSInteger)monthIndexForDate:(NSDate *)date
{
    NSCalendar *calendar = [LCalendarAppearance share].calendar;
    NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:date];
    return comps.month;
}

/// 比较日期是否相等
- (BOOL)isEqual:(NSDate *)date1 other:(NSDate *)date2{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = [LCalendarAppearance share].calendar.timeZone;
    dateFormatter.dateFormat = @"yyyy.MM.dd";
    return [[dateFormatter stringFromDate:date1] isEqualToString:[dateFormatter stringFromDate:date2]];
}

/// 返回该日期月数第一周开始的第一天
- (NSDate *)beginningOfMonth:(NSDate *)date{
    NSCalendar *calendar = [LCalendarAppearance share].calendar;
    NSDateComponents *componentsCurrentDate =[calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month;
    componentsNewDate.weekOfMonth = 1;
    componentsNewDate.weekday = calendar.firstWeekday;
    return [calendar dateFromComponents:componentsNewDate];
}

/// 获取该日期下 月的页面 展示的LCalendarDayItem天列表
- (NSArray<LCalendarDayItem *> *)getDaysOfMonth:(NSDate *)date
{
    NSDate *currentDate = date;
    NSCalendar *calendar = [LCalendarAppearance share].calendar;
    //每一月的 date
    NSMutableArray *daysOfMonth = [[NSMutableArray alloc] init];
    
    NSDateComponents *comps = [calendar components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
    //每月开始的第一天不是 1   则是上一个月的
    if(comps.day > 1){
        self.currentMonthIndex = (comps.month % 12) + 1;
    } else {
        self.currentMonthIndex = comps.month;
    }
    
    for (NSInteger i = 0; i<[LCalendarAppearance share].weeksToDisplay; i++) {
        NSDateComponents *dayComponent = [NSDateComponents new];
        dayComponent.day = 7;
        NSArray *array = [self getDaysOfWeek:currentDate];
        [daysOfMonth addObjectsFromArray:array];
        currentDate = [calendar dateByAddingComponents:dayComponent toDate:currentDate options:0];
    }
    return daysOfMonth;
}

/// 获取该日期下 周的页面 展示的LCalendarDayItem天列表
- (NSArray<LCalendarDayItem *> *)getDaysOfWeek:(NSDate *)date
{
    NSDate *currentDate = date;
    NSCalendar *calendar = [LCalendarAppearance share].calendar;
    //每一周的 date
    NSMutableArray *daysOfweek = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<7; i++) {
        NSDateComponents *comps = [calendar components:NSCalendarUnitMonth | NSCalendarUnitWeekOfMonth fromDate:currentDate];
        NSInteger monthIndex = comps.month;
        
        LCalendarDayItem *item = [LCalendarDayItem new];
        item.isOtherMonth = monthIndex != self.currentMonthIndex;
        item.date = currentDate;
        if ([self isEqual:currentDate other:self.currentDate]) {
            item.isSelected = YES;
            self.currentSelectedItem = (comps.weekOfMonth-1)*7+i;
        }
        
        if ([self isEqual:currentDate other:[NSDate date]]) {
            item.isToday = YES;
        }
        
        if ([self.delegate respondsToSelector:@selector(calendarTipStringWithDate:)]) {
            item.tipString = [self.delegate calendarTipStringWithDate:currentDate];
            if ([self.delegate respondsToSelector:@selector(calendarTipStringColorWithDate:)]) {
                item.tipColor = [self.delegate calendarTipStringColorWithDate:currentDate];
            }
        }
        
        NSDateComponents *dayComponent = [NSDateComponents new];
        dayComponent.day = 1;
        [daysOfweek addObject:item];
        currentDate = [calendar dateByAddingComponents:dayComponent toDate:currentDate options:0];
    }
    return  daysOfweek;
}

- (NSInteger)numWeekOfMonthWithDate:(NSDate *)date {
    NSCalendar *calendar = [LCalendarAppearance share].calendar;
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay fromDate:date];
    return comps.weekOfMonth;
}

- (void)checkRefreshFrame {
    if ([LCalendarAppearance share].isShowSingleWeek) {
        if ([self.delegate respondsToSelector:@selector(resetContentView)]) {
            [self.delegate resetContentView];
        }
    }
}

- (void)setCurrentDate:(NSDate *)currentDate {
    _currentDate = currentDate;
    if ([self.delegate respondsToSelector:@selector(currentCalendarDateChanged:)]) {
        [self.delegate currentCalendarDateChanged:currentDate];
    }
}

#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return NUMBER_PAGES_LOADED;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7*[LCalendarAppearance share].weeksToDisplay;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Class class = [LCalendarAppearance share].calendarCellClass;
    if (class == nil) {
        class = [LCalendarBaseCell class];
    }
    LCalendarBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(class) forIndexPath:indexPath];
    NSArray<NSArray<LCalendarDayItem *> *> *dataSource = self.daysInMonth;
    if ([LCalendarAppearance share].isShowSingleWeek) {
        dataSource = self.daysInWeeks;
    }
    LCalendarDayItem *item = [[dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
    
    [cell reloadContentViewWithItem:item];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LCalendarBaseCell *cell = (LCalendarBaseCell*)[collectionView cellForItemAtIndexPath:indexPath];
    NSInteger section = indexPath.section;
    BOOL isShowSingleWeek = [LCalendarAppearance share].isShowSingleWeek;
    NSArray<NSArray<LCalendarDayItem *> *> *dataSource = self.daysInMonth;
    if (isShowSingleWeek) {
        dataSource = self.daysInWeeks;
    }
    LCalendarDayItem *itemLast = [[dataSource objectAtIndex:section] objectAtIndex:self.currentSelectedItem];
    LCalendarDayItem *itemCurrent = [[dataSource objectAtIndex:section] objectAtIndex:indexPath.item];
    
    if (itemLast == itemCurrent) {
        /// 点击同一个item 不刷新
        return;
    }
    self.isClickChangePage = YES;
    if ([self.delegate respondsToSelector:@selector(calendarDidSelectedDate:)]) {
        [self.delegate calendarDidSelectedDate:itemCurrent.date];
    }

    itemLast.isSelected = NO;
    itemCurrent.isSelected = YES;
    [cell reloadContentViewWithItem:itemCurrent];
    
    NSDateComponents *comps = [[LCalendarAppearance share].calendar components:NSCalendarUnitMonth | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday fromDate:itemCurrent.date];
    NSInteger touchMonthIndex = [self monthIndexForDate:itemCurrent.date];
    NSInteger currentMonth = [self monthIndexForDate:self.currentDate];
    
    if (touchMonthIndex == currentMonth || isShowSingleWeek) {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:self.currentSelectedItem inSection:section];
        LCalendarBaseCell *lastCell = (LCalendarBaseCell*)[collectionView cellForItemAtIndexPath:lastIndexPath];
        [lastCell reloadContentViewWithItem:itemLast];
    }
    
    touchMonthIndex = touchMonthIndex % 12;
    if (isShowSingleWeek) {
        if(touchMonthIndex == (currentMonth + 1) % 12){
            /// 展示后一页的月视图数据, 并只展示该周位置
            self.currentSelectedItem = indexPath.item%7;
            [self showDayViewWithDate:itemCurrent.date];
        } else if(touchMonthIndex == (currentMonth + 12 - 1) % 12){
            /// 展示前一页的月视图数据, 并只展示该周位置
            NSInteger weekIndex = [self numWeekOfMonthWithDate:itemCurrent.date];
            self.currentSelectedItem = indexPath.item%7+(weekIndex-1)*7;
            [self showDayViewWithDate:itemCurrent.date];
        } else {
            self.currentSelectedItem = indexPath.item;
            self.currentDate = itemCurrent.date;
        }
    } else {
        NSInteger index = comps.weekday-[LCalendarAppearance share].calendar.firstWeekday%7;
        if (index < 0) {
            index += 7;
        }
        self.currentSelectedItem = (comps.weekOfMonth-1)*7+index;
        if(touchMonthIndex == (currentMonth + 1) % 12){
            _currentDate = itemCurrent.date;
            [self loadNextPage];
        } else if(touchMonthIndex == (currentMonth + 12 - 1) % 12){
            _currentDate = itemCurrent.date;
            [self loadPreviousPage];
        } else {
            self.currentDate = itemCurrent.date;
        }
    }
}

#pragma mark -- UIScrollView --

//setContentOffset产生的动画回调 点击滑动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updatePageWithNewDate:!self.isClickChangePage];
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadData];
    }];
    self.isClickChangePage = NO;
}

//手指滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isClickChangePage = NO;
    //如通过手指滑动更换月份  则默认选中 与当前日期相等的 日子
    //如果是按月份显示
    
    //如果是按周显示
    CGFloat pageWidth = KCollectionWidth;
    CGFloat fractionalPage = self.collectionView.contentOffset.x / pageWidth;
    
    int currentPage = roundf(fractionalPage);
    
    if (currentPage == round(NUMBER_PAGES_LOADED / 2)){
        return;
    };
    [self updatePageWithNewDate:YES];
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadData];
    }];
    /// 周视图左右滑动需要强制位置
    [self checkRefreshFrame];
    
    if ([self.delegate respondsToSelector:@selector(calendarDidLoadPageCurrentDate:)]) {
        [self.delegate calendarDidLoadPageCurrentDate:self.currentDate];
    }
}


#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        LCalendarCollectionFlowLayout *flowLayout = [LCalendarCollectionFlowLayout new];
        flowLayout.itemSize = CGSizeMake(KCollectionWidth/7.0, [LCalendarAppearance share].weekDayHeight);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemCountPerRow = 7;
        flowLayout.rowCount = [LCalendarAppearance share].weeksToDisplay;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(KCollectionMargin, 0, KCollectionWidth, [LCalendarAppearance share].weekDayHeight*[LCalendarAppearance share].weeksToDisplay) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor =  [UIColor clearColor];
        Class class = [LCalendarAppearance share].calendarCellClass;
        if (class == nil) {
            class = [LCalendarBaseCell class];
        }
        [_collectionView registerClass:class forCellWithReuseIdentifier:NSStringFromClass(class)];
    }
    return _collectionView;
}


- (UIView *)maskView {
    if (!_maskView) {
        CGRect maskBounds = self.bounds;
        _maskView = [[UIView alloc] initWithFrame:maskBounds];
        _maskView.backgroundColor = [LCalendarAppearance share].calendarBgColor;
        _maskView.alpha = 0;
        _maskView.hidden = YES;
        //创建一个CAShapeLayer 图层
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        //添加图层蒙板
        _maskView.layer.mask = shapeLayer;
    }
    return _maskView;
}



@end
