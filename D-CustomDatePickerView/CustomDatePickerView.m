//
//  CustomDatePickerView.m
//  D-CustomDatePickerView
//
//  Created by duanshengwu on 2019/7/30.
//  Copyright © 2019 D-James. All rights reserved.
//

#import "CustomDatePickerView.h"
#import "CustomDatePickerViewModel.h"
#import "NSDate+Category.h"


@interface CustomDatePickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) CustomDatePickerViewModel *viewModel;


@property (strong, nonatomic) NSMutableArray *dateArray;


@property (weak, nonatomic) UIPickerView *pickerView;

@property (strong, nonatomic) NSString *selectedDateStr;

//记录UIPickerView每个component的row的位置
@property (assign, nonatomic) NSInteger index1;
@property (assign, nonatomic) NSInteger index2;
@property (assign, nonatomic) NSInteger index3;


@end

@implementation CustomDatePickerView



- (instancetype)initWithFrame:(CGRect)frame withType:(DatePickerType)dateType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dateType = dateType;
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI {
    
    
    self.backgroundColor = [UIColor whiteColor];
    CGFloat width = self.frame.size.width;
    
    UIView *toolView = [UIView new];
    [self addSubview:toolView];
    toolView.frame = CGRectMake(0, 0, width, 44);
    toolView.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolView addSubview:cancelBtn];
    
    cancelBtn.frame = CGRectMake(0, 0, 80, 44);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolView addSubview:doneBtn];
    
    doneBtn.frame = CGRectMake(width-80, 0, 80, 44);
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    
    
    UIPickerView *pickerView = [UIPickerView new];
    [self addSubview:pickerView];
    self.pickerView = pickerView;
    pickerView.frame = CGRectMake(0, 44, width, self.frame.size.height-90);
    
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    self.dateArray = [self.viewModel setUpDataStartDate:[NSDate date] endDate:[NSDate dateWithTimeIntervalSince1970:([NSDate date].timeIntervalSince1970 + 60*60*24*100)]];
    
}

- (void)cancelBtnEvent {
    
    if (self.cancelBtnEventBlock) {
        self.cancelBtnEventBlock();
    }
}

- (void)doneBtnEvent {
    
//    NSLog(@"%@",self.selectedDateStr);//2019年10月2日 0:30
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm";
    
    NSDate *selectDate = [dateFormatter dateFromString:self.selectedDateStr];
    
    if (self.doneBtnEventBlock) {
        self.doneBtnEventBlock(selectDate);
    }
}


- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {

    switch (self.dateType) {
        case D_MouthDayHourMinute:
            return 3;
            break;
        case D_YearMouthDayHourHalfMinute:
            return 3;
            break;
        case D_MouthDayHour:
            return 2;
            break;
        default:
            return 3;
            break;
    }

}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (self.dateType == D_YearMouthDayHourHalfMinute) {
        if (component == 0) {
            return self.dateArray.count;
        }else if (component == 1) {
            return self.viewModel.hourArray.count;
        }else if (component == 2) {
            return self.viewModel.halfMinuteArray.count;
        }
    }else if (self.dateType == D_MouthDayHourMinute || self.dateType == D_MouthDayHour) {
        if (component == 0) {
            return self.dateArray.count;
        }else if (component == 1) {
            return self.viewModel.hourArray.count;
        }else if (component == 2) {
            return self.viewModel.minuteArray.count;
        }
    }
    
    
    return 1;
}


- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (self.dateType == D_YearMouthDayHourHalfMinute) {
        if (component == 0) {
            NSString *dateStr = [NSString stringWithFormat:@"%@",self.dateArray[row]];
            dateStr = [dateStr substringFromIndex:5];
            return dateStr;
            
        }else if (component == 1) {
            return [NSString stringWithFormat:@"%@",self.viewModel.hourArray[row]];
            
        }else if (component == 2) {
            return [NSString stringWithFormat:@"%@",self.viewModel.halfMinuteArray[row]];
        }
    }else if (self.dateType == D_MouthDayHourMinute  || self.dateType == D_MouthDayHour) {
        if (component == 0) {
            NSString *dateStr = [NSString stringWithFormat:@"%@",self.dateArray[row]];
            dateStr = [dateStr substringFromIndex:5];
            return dateStr;
            
        }else if (component == 1) {
            return [NSString stringWithFormat:@"%@",self.viewModel.hourArray[row]];
            
        }else if (component == 2) {
            return [NSString stringWithFormat:@"%@",self.viewModel.minuteArray[row]];
        }
    }
    
    return @"";
}


//pickerView滚动时会调用这个方法，当选择特定选项会可能要对特定row数据进行刷新
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            self.index1 = row;
            break;
        case 1:
            self.index2 = row;
            break;
        case 2:
            self.index3 = row;
            break;
        default:
            break;
    }
    
    
    if (self.dateType == D_YearMouthDayHourHalfMinute) {
        if (component == 0) {
            if (row == 0) {
//                选择今天要重新刷新小时和分钟
                NSDateFormatter *dateFormatter = [NSDateFormatter new];
                dateFormatter.dateFormat = @"HH";
                NSInteger nowHour = [dateFormatter stringFromDate:[NSDate date]].integerValue;
                
                if ([self.viewModel nowMinuteBig30]) {//现在分钟数>30,当前小时数+1
                    [self.viewModel setHourArrayWithStartHour:nowHour+1];
                    [self.viewModel setHalfMinuteArrayWithStartHalfMinute:0];
                }
                else {
                    NSDateFormatter *dateFormatter2 = [NSDateFormatter new];
                    dateFormatter2.dateFormat = @"mm";
                    NSInteger nowMinute = [dateFormatter2 stringFromDate:[NSDate date]].integerValue;
                    [self.viewModel setHalfMinuteArrayWithStartHalfMinute:nowMinute];
                }
                
            }else{
                [self.viewModel setHourArrayWithStartHour:0];
                [self.viewModel setHalfMinuteArrayWithStartHalfMinute:0];
            }
            
            [pickerView reloadAllComponents];
        }else if (component == 1) {
            if (self.index1 == 0 && self.index2 == 0 ) {
                if ([self.viewModel nowMinuteBig30]) {
                    [self.viewModel setHalfMinuteArrayWithStartHalfMinute:0];
                }
                else {
                    NSDateFormatter *dateFormatter2 = [NSDateFormatter new];
                    dateFormatter2.dateFormat = @"mm";
                    NSInteger nowMinute = [dateFormatter2 stringFromDate:[NSDate date]].integerValue;
                    
                    [self.viewModel setHalfMinuteArrayWithStartHalfMinute:nowMinute];
                }
                
            }else{
                [self.viewModel setHalfMinuteArrayWithStartHalfMinute:0];
            }
            
            [pickerView reloadAllComponents];
        }else{
            [self.viewModel setHourArrayWithStartHour:0];
            [self.viewModel setHalfMinuteArrayWithStartHalfMinute:0];
            [pickerView reloadAllComponents];
        }

        
        self.selectedDateStr = [NSString stringWithFormat:@"%@ %@:%@",self.dateArray[self.index1],self.viewModel.hourArray[self.index2],self.viewModel.halfMinuteArray[self.index3]];
        
    }else if (self.dateType == D_MouthDayHourMinute || self.dateType == D_MouthDayHour) {
        switch (component) {
            case 0:
                {
                    if (row == 0) {
                        [self.viewModel setHourArrayWithStartHour:[self.viewModel nowHour]];
                        [self.viewModel setMinuteArrayWithStartMinute:[self.viewModel nowMinute]];
                    }else {
                        [self.viewModel setHourArrayWithStartHour:0];
                        [self.viewModel setMinuteArrayWithStartMinute:0];
                    }
                }
                break;
                
            default:
                [self.viewModel setHourArrayWithStartHour:0];
                [self.viewModel setMinuteArrayWithStartMinute:0];
                break;
        }
        [pickerView reloadAllComponents];
        
        if (self.dateType == D_MouthDayHourMinute) {
            self.selectedDateStr = [NSString stringWithFormat:@"%@ %@:%@",self.dateArray[self.index1],self.viewModel.hourArray[self.index2],self.viewModel.minuteArray[self.index3]];
           
        }else if (self.dateType == D_MouthDayHour) {
            self.selectedDateStr = [NSString stringWithFormat:@"%@ %@",self.dateArray[self.index1],self.viewModel.hourArray[self.index2]];
        }
        
    }
    NSLog(@"%@",self.selectedDateStr);
    
}



- (CustomDatePickerViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [CustomDatePickerViewModel new];
        _viewModel.dateType = self.dateType;
    }
    
    return _viewModel;
}


@end
