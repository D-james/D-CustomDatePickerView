//
//  CustomDatePickerViewModel.m
//  D-CustomDatePickerView
//
//  Created by duanshengwu on 2019/7/30.
//  Copyright © 2019 D-James. All rights reserved.
//

#import "CustomDatePickerViewModel.h"
#import "NSDate+Category.h"

@interface CustomDatePickerViewModel ()




@end



@implementation CustomDatePickerViewModel

/*
 如果是分钟只显示半点和整点，也就是显示0和30。根据当前时间，就要判断以下几点：
 1.当前日期，时间的分钟数>0且<30那么分钟只显示30
 2.如果大于30，那么小时数也要+1
 3.如果小时数+1的时候是23点，那么日期天数要+1
 
 只有当前日期有这个判断，其他日期不会
 
 */

- (NSDateFormatter *)dateFormatterWithStr:(NSString *)dateFormater {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = dateFormater;
    
    return dateFormatter;
}

- (NSInteger)nowMinute {
    
    NSDateFormatter *minuteFormatter = [self dateFormatterWithStr:@"mm"];
    
    return [minuteFormatter stringFromDate:[NSDate date]].integerValue;
}


- (NSInteger)nowHour {
    
    NSDateFormatter *hourFormatter = [self dateFormatterWithStr:@"HH"];
    
    return [hourFormatter stringFromDate:[NSDate date]].integerValue;
}


- (bool)nowHourEqual23 {
   
    return [self nowHour] == 23;
}


- (bool)nowMinuteBig30 {
    
    return [self nowMinute] > 30;
}


#pragma mark - 日期数据源方法
- (NSMutableArray *)setUpDataStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    
//    如果现在是晚上23：30以后那么日期要加30minute
    if ([self nowHourEqual23] && [self nowMinuteBig30] && self.dateType == D_YearMouthDayHourHalfMinute) {
        startDate = [NSDate dateWithTimeIntervalSince1970:([NSDate date].timeIntervalSince1970+60*30)];
    }
    
    NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate];
    if (timeInterval < 0) {
        return nil;
    }
    
    //    计算开始结束日期之间相差几个月
    NSInteger monthInterval;
    
    NSDateComponents *startComponents = [startDate getDateComponents];
    NSDateComponents *endComponents = [endDate getDateComponents];
    
    NSInteger startYear = startComponents.year;
    NSInteger endYear = endComponents.year;
    
    NSInteger startMonth = startComponents.month;
    NSInteger endMonth = endComponents.month;
    
    monthInterval = (endYear - startYear) * 12 + (endMonth - startMonth) + 1;
    
    
    NSMutableArray *dateArray = [NSMutableArray new];
    
    
    for (int i = 0; i < monthInterval; i++) {
        
        
        NSDateComponents *newComponent = [NSDateComponents new];
        NSInteger nowYear = startYear + (startMonth + i)/12;
        newComponent.year = nowYear;
        
        NSInteger monthYu = (startMonth + i) % 12;
        NSInteger nowMonth = monthYu ? monthYu : 12;
        newComponent.month = nowMonth;
        newComponent.day = 1;
        
        NSDate *newDate = [[NSCalendar currentCalendar]dateFromComponents:newComponent];
        
        //        本月第一天是周几
//        NSInteger weekFirstDay = [newDate getFirstWeekInMonth];
        
        
        //        添加有数据的数据模型
        NSInteger daysMonth = [newDate getDayNumOfMouth];
        
        for (int k = 1; k <= daysMonth ; k++) {

            if (i == 0) {
                if (k < startComponents.day) {
                    continue;
                }
            }
            
            NSString *dateStr = [NSString stringWithFormat:@"%d年%d月%d日",nowYear,nowMonth,k];
            
            [dateArray addObject:dateStr];
        }
        
    }
    
    return dateArray;
}


- (NSMutableArray *)yearArray {
    if (!_yearArray) {
        _yearArray = [NSMutableArray array];
        NSInteger thisYear = [[NSDate date]getDateComponents].year;
        for (int i = 0; i < 100; i++) {
            [_yearArray addObject:@(thisYear+i)];
        }
    }
    
    return _yearArray;
}


- (NSMutableArray *)monthArray {
    if (!_monthArray) {
        _monthArray = [NSMutableArray array];
        NSInteger thisMonth = [[NSDate date]getDateComponents].month;
        NSInteger mounthIndex = thisMonth;
        for (int i = 0; i < 12; i ++) {
            mounthIndex = thisMonth + i;
            if (mounthIndex > 12) {
                mounthIndex = 1;
            }
            [_monthArray addObject:@(mounthIndex)];
        }
    }
    
    return _monthArray;
}


//- (NSMutableArray *)dayArray {
//    if (!_dayArray) {
//        _dayArray = [NSMutableArray array];
//
//        NSInteger thisDay = [[NSDate date]getDateComponents].day;
//        NSInteger dayIndex = thisDay;
//
//
//        for (int i = 0; i < 12; i ++) {
//            dayIndex = thisDay + i;
//            if (dayIndex > 12) {
//                dayIndex = 1;
//            }
//            [_dayArray addObject:@(dayIndex)];
//        }
//    }
//
//    return _dayArray;
//}


- (NSMutableArray *)hourArray {
    if (!_hourArray) {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"HH";
        NSInteger nowHour = [dateFormatter stringFromDate:[NSDate date]].integerValue;
        
        if (self.dateType == D_YearMouthDayHourHalfMinute) {
            if ([self nowHourEqual23] && [self nowMinuteBig30]) {
                nowHour = 0;
            }else if ([self nowMinuteBig30]) {
                nowHour += 1;
            }
        }
        
        [self setHourArrayWithStartHour:nowHour];
    }
    
    return _hourArray;
}


- (NSMutableArray *)minuteArray {
    if (!_minuteArray) {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"mm";
        NSInteger nowMinute = [dateFormatter stringFromDate:[NSDate date]].integerValue;
        [self setMinuteArrayWithStartMinute:nowMinute];
    }
    
    return _minuteArray;
}


- (NSMutableArray *)halfMinuteArray {
    if (!_halfMinuteArray) {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"mm";
        NSInteger nowMinute = [dateFormatter stringFromDate:[NSDate date]].integerValue;
        if ([self nowMinuteBig30] && self.dateType == D_YearMouthDayHourHalfMinute) {
            nowMinute = 0;
        }
        [self setHalfMinuteArrayWithStartHalfMinute:nowMinute];
    }
    
    return _halfMinuteArray;
}



- (NSMutableArray *)weekArray {
    if (!_weekArray) {
        _weekArray = [NSMutableArray array];
        
    }
    
    return _weekArray;
}


- (void)setHourArrayWithStartHour:(NSInteger)startHour  {
    if (startHour > 23) {
        startHour = 0;
    }
    NSMutableArray *hourArray = [NSMutableArray array];
    for (NSInteger i = startHour; i < 24; i++) {
        [hourArray addObject:@(i)];
    }
    
    self.hourArray = hourArray;
}


- (void)setMinuteArrayWithStartMinute:(NSInteger) startMinute {
    NSMutableArray *minuteArray = [NSMutableArray array];
    for (NSInteger i = startMinute; i < 60; i++) {
        [minuteArray addObject:@(i)];
    }
    
    self.minuteArray = minuteArray;
    
}



- (void)setHalfMinuteArrayWithStartHalfMinute:(NSInteger)startHalfMinute {
    NSMutableArray *halfMinuteArray = [NSMutableArray array];
    if (startHalfMinute == 0) {
        [halfMinuteArray addObject:@0];
    }
    if (startHalfMinute <= 30) {
        [halfMinuteArray addObject:@30];
    }
    
    self.halfMinuteArray = halfMinuteArray;
    
}


@end
