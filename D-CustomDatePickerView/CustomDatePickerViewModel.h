//
//  CustomDatePickerViewModel.h
//  D-CustomDatePickerView
//
//  Created by duanshengwu on 2019/7/30.
//  Copyright © 2019 D-James. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomDatePickerView.h"


NS_ASSUME_NONNULL_BEGIN

@interface CustomDatePickerViewModel : NSObject

@property (strong, nonatomic) NSMutableArray *yearArray;
@property (strong, nonatomic) NSMutableArray *monthArray;
@property (strong, nonatomic) NSMutableArray *dayArray;
@property (strong, nonatomic) NSMutableArray *weekArray;
@property (strong, nonatomic) NSMutableArray *hourArray;
@property (strong, nonatomic) NSMutableArray *minuteArray;
@property (strong, nonatomic) NSMutableArray *halfMinuteArray;

@property (strong, nonatomic) NSMutableArray *monthDayArray;

@property (assign, nonatomic) DatePickerType dateType;


- (NSMutableArray *)setUpDataStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

- (void)setHourArrayWithStartHour:(NSInteger)startHour ;

- (void)setMinuteArrayWithStartMinute:(NSInteger)startMinute;

- (void)setHalfMinuteArrayWithStartHalfMinute:(NSInteger)startHalfMinute ;


- (bool)nowHourEqual23;
- (bool)nowMinuteBig30;

- (NSInteger)nowMinute;
- (NSInteger)nowHour;

@end

NS_ASSUME_NONNULL_END
