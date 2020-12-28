//
//  LGHAddViewController.m
//  ThirdFramework
//
//  Created by 刘观华 on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LGHAddViewController.h"
#import "PGDatePickManager.h"
#import "LGHMainView.h"
#import "LGHPlanModel.h"
#import "FMDB.h"
@interface LGHAddViewController ()<PGDatePickerDelegate,UITextFieldDelegate>

@property(nonatomic , strong)NSTimer *timer;
@property(nonatomic , strong)LGHMainView *mainView;
@property(nonatomic,strong)UIScrollView *mainScrollView;

@property(nonatomic,strong)NSDate *planDate;
@property(nonatomic,strong)NSString *planDateStr;

@property(nonatomic,strong)FMDatabase *db;
@end

@implementation LGHAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //显示页面
    [self setInit];
    
    [self setMainViewAction];
    
    [self initFMDB];
    
}

-(void)initFMDB
{
    //1.获取数据库文件的路径
   NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [docPath stringByAppendingPathComponent:@"plan.sqlite"];
    _db = [FMDatabase databaseWithPath:fileName];
    [_db close];
    if ([_db open]) {
        NSLog(@"打开数据库成功");
    } else {
        NSLog(@"打开数据库失败");
    }
    //4.创表
    BOOL result=[self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_plan(id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, desc text NOT NULL,  targetDate text NOT NULL,  isAlert integer,backgroundName integer NOT NULL,status integer default 1);"];
    if (result) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败");
    }
    [_db close];
}

-(void)setInit{
    _mainScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+80);
    _mainScrollView.bounces = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.pagingEnabled = NO;
    [self.view addSubview:_mainScrollView];
    _mainView =[[NSBundle  mainBundle]loadNibNamed:@"LGHMainView" owner:nil options:nil].lastObject;
    _mainView.frame = self.view.bounds;
    [self.mainScrollView addSubview:_mainView];
    
    self.mainView.nameField.delegate = self;
    self.mainView.descriptionField.delegate = self;
    
  
    
}
    
-(void)setMainViewAction
{
    [self.mainView.timeButton addTarget:self action:@selector(selectTimeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView.completeButton addTarget:self action:@selector(completeButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)completeButtonAction
{
    if (!self.mainView.nameField.text||self.mainView.nameField.text.length==0) {
        [JDStatusBarNotification showWithStatus:@"请输入倒计时名称" dismissAfter:2.0f styleName:JDStatusBarStyleError];
        return;
    }
    if (!self.mainView.descriptionField.text||self.mainView.descriptionField.text.length==0) {
        [JDStatusBarNotification showWithStatus:@"请输入倒计时描述" dismissAfter:2.0f styleName:JDStatusBarStyleError];
        return;
    }
    if (!self.mainView.planTimeLabel.text||self.mainView.planTimeLabel.text.length==0) {
        [JDStatusBarNotification showWithStatus:@"请输入目标时间" dismissAfter:2.0f styleName:JDStatusBarStyleError];
        return;
    }
    
    //存储对象
    LGHPlanModel *planModel = [[LGHPlanModel alloc]init];
    planModel.name = self.mainView.nameField.text ;
    planModel.desc = self.mainView.descriptionField.text;
    planModel.targetDateStr= self.planDateStr;
    planModel.isAlert = self.mainView.alertSwitch.isOn;
    planModel.backgroundName =  self.mainView.backgroundName;
    //1.获取数据库文件的路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [docPath stringByAppendingPathComponent:@"plan.sqlite"];
    _db = [FMDatabase databaseWithPath:fileName];
    [_db close];
    if ([_db open]) {
        BOOL result = [_db executeUpdate:@"INSERT INTO t_plan (name, desc, targetDate, isAlert, backgroundName) VALUES (?,?,?,?,?);",planModel.name,planModel.desc,planModel.targetDateStr,@(planModel.isAlert),@(planModel.backgroundName)];
        if (result) {
            NSLog(@"插入成功");
        } else {
            [JDStatusBarNotification showWithStatus:@"数据库插入失败" dismissAfter:2.0f styleName:JDStatusBarStyleError];
        }
    }else{
         [JDStatusBarNotification showWithStatus:@"数据库打开失败" dismissAfter:2.0f styleName:JDStatusBarStyleError];
        return ;
    }
    [_db close];
    
    //完成之后跳转到TabBar的Item1的位置
    self.tabBarController.selectedIndex = 0;
}

    
-(void)selectTimeAction{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerMode =  PGDatePickerModeDateHourMinuteSecond;
    datePicker.language = @"zh-Hans";
    [self presentViewController:datePickManager animated:false completion:nil];
    datePickManager.titleLabel.text = @"选择目标时间";
    //设置半透明的背景颜色
    datePickManager.isShadeBackgroud = true;
    //设置头部的背景颜色
    datePickManager.headerViewBackgroundColor = [UIColor orangeColor];
    //设置线条的颜色
    datePicker.lineBackgroundColor = [UIColor redColor];
    //设置选中行的字体颜色
    datePicker.textColorOfSelectedRow = [UIColor redColor];
    //设置未选中行的字体颜色
    datePicker.textColorOfOtherRow = [UIColor blackColor];
    //设置取消按钮的字体颜色
    datePickManager.cancelButtonTextColor = [UIColor blackColor];
    //设置取消按钮的字
    datePickManager.cancelButtonText = @"取消";
    //设置取消按钮的字体大小
    datePickManager.cancelButtonFont = [UIFont boldSystemFontOfSize:17];
    
    //设置确定按钮的字体颜色
    datePickManager.confirmButtonTextColor = [UIColor redColor];
    //设置确定按钮的字
    datePickManager.confirmButtonText = @"确定";
    //设置确定按钮的字体大小
    datePickManager.confirmButtonFont = [UIFont boldSystemFontOfSize:15];
}
    
#pragma Mark - View Will Appear/Disappear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mainView.nameField.text = nil;
    self.mainView.descriptionField.text = nil;
    self.mainView.planTimeLabel.text = nil;
    /*
     @property (weak, nonatomic) IBOutlet UILabel *showNameLabel;
     @property (weak, nonatomic) IBOutlet UILabel *showDescLabel;
     @property (weak, nonatomic) IBOutlet UIView *showCountdownView;
     */
    self.mainView.showNameLabel.text = nil;
    self.mainView.showDescLabel.text = nil;
    self.mainView.showCountdownView.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    [self.db close];
}

#pragma Mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if (textField==self.mainView.nameField) {
        self.mainView.showNameLabel.text = textField.text;
    }
    if (textField==self.mainView.descriptionField) {
        self.mainView.showDescLabel.text = textField.text;
    }

}


    
#pragma PGDatePickerDelegate
//点击确定的回调
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSDate *nowDate = [NSDate date];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDate * planDate = [calendar dateFromComponents:dateComponents];
    NSComparisonResult result = [planDate compare:nowDate];
    
    if (result!=1) {
        [JDStatusBarNotification showWithStatus:@"请选择未来时间" dismissAfter:3.0f styleName:JDStatusBarStyleDark];
        return;
    }
     NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *planStr=[format stringFromDate:planDate];
    NSLog(@"planStr = %@",planStr);
    NSString *nowStr=[format stringFromDate:nowDate];
    NSLog(@"planStr = %@",nowStr);
    
    self.planDateStr = planStr;
    self.planDate = planDate;
    self.mainView.planTimeLabel.text = planStr;
    //显示showCountdownView
    self.mainView.showCountdownView.hidden = NO;
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeCountDownRepeatsSeconds) userInfo:nil repeats:YES];
}

-(void)changeCountDownRepeatsSeconds
{
    NSDate *firstDate = [NSDate date];
    NSCalendar* chineseClendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSUInteger unitFlags =NSCalendarUnitMinute| NSCalendarUnitSecond | NSCalendarUnitDay | NSCalendarUnitHour;
    NSDateComponents *cps = [chineseClendar components:unitFlags fromDate:firstDate toDate:self.planDate options:0];
    NSInteger diffDay = [cps day];
    NSInteger diffHour = [cps hour] ;
    NSInteger diffMinute = [cps minute];
    NSInteger diffSecond = [cps second];
    self.mainView.daysLabel.text = [NSString stringWithFormat:@"%ld",diffDay];
    self.mainView.hoursLabel.text = [NSString stringWithFormat:@"%ld",diffHour];
    self.mainView.minutesLabel.text = [NSString stringWithFormat:@"%ld",diffMinute];
    self.mainView.secondsLabel.text = [NSString stringWithFormat:@"%ld",diffSecond];
    
}



@end
