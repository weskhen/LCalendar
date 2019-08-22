//
//  LCalendarCollectionFlowLayout.h
//  LCalendar
//
//  Created by wujian on 2019/8/17.
//  Copyright © 2019 wesk痕. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCalendarCollectionFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) NSUInteger itemCountPerRow;

//    一页显示多少行
@property (nonatomic, assign) NSUInteger rowCount;

@end

NS_ASSUME_NONNULL_END
