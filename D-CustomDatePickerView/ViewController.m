//
//  ViewController.m
//  D-CustomDatePickerView
//
//  Created by duanshengwu on 2019/7/30.
//  Copyright © 2019 D-James. All rights reserved.
//

#import "ViewController.h"
#import "CustomDatePickerView.h"



@interface ViewController ()

@property (weak, nonatomic) CustomDatePickerView *pickerV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    CustomDatePickerView *pickerV = [[CustomDatePickerView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-400, self.view.bounds.size.width, 400) withType:D_MouthDayHour];
    
    [self.view addSubview:pickerV];
    self.pickerV = pickerV;
    
    __weak typeof(pickerV) weakPickerV = pickerV;
    pickerV.cancelBtnEventBlock = ^{
        [UIView animateWithDuration:0.2 animations:^{
            weakPickerV.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 400);
        }];
    };
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerV.frame = CGRectMake(0, self.view.bounds.size.height-400, self.view.bounds.size.width, 400);
    }];
}


@end
