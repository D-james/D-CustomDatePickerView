//
//  CustomDatePickerView.h
//  D-CustomDatePickerView
//
//  Created by duanshengwu on 2019/7/30.
//  Copyright © 2019 D-James. All rights reserved.
//

#import <UIKit/UIKit.h>

//NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    D_YearMouthDayHourHalfMinute,//日期，小时，半点
    D_MouthDayHour,//日期，小时
    D_MouthDayHourMinute,//日期，小时，分钟
//    D_YearMouthDayHour,
//    D_YearMouthDay,
//    D_YearMouthDayHourMinute,
} DatePickerType;

@interface CustomDatePickerView : UIView

@property (assign, nonatomic) DatePickerType dateType;


@property (copy, nonatomic) void (^cancelBtnEventBlock)();
@property (copy, nonatomic) void (^doneBtnEventBlock)(NSDate *selectDate);

- (instancetype)initWithFrame:(CGRect)frame withType:(DatePickerType)dateType;

@end

//NS_ASSUME_NONNULL_END
