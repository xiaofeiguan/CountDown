//
//  LGHHomeViewController.m
//  ThirdFramework
//
//  Created by tangkaifu on 2018/7/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LGHHomeViewController.h"
#import "UIBarButtonItem+Item.h"
#import "LGHNavigationController.h"
#import "LGHPastPlanViewController.h"
#import "LGHAddViewController.h"
#import "LGHUpdateViewController.h"
#import "UIViewController+HHTransition.h"
#import "LGHHomeTableViewCell.h"
#import "TableViewAnimationKit.h"
#import "FMDatabase.h"
#import "LGHPlanModel.h"
#import <MBProgressHUD.h>
#import "LGHMainView.h"
@interface LGHHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIAlertViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,LGHHomeTableViewCellProtocol>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic, strong) UITableView *play;

@property(nonatomic, strong) FMDatabase *db;

@property(nonatomic,strong)NSMutableArray *plans;

@property(nonatomic, strong) NSMutableDictionary *timerDict;

@property(nonatomic,strong)NSString *currentVersionReleaseNote;

@property(nonatomic,strong)NSString *currentNotifyName;


@end

@implementation LGHHomeViewController

-(NSMutableArray*) plans
{
if (!_plans) {
_plans =  [NSMutableArray array] ;
}
return _plans ;
}

-(NSMutableDictionary*) timerDict
{
    if (!_timerDict) {
        _timerDict =  [NSMutableDictionary dictionary] ;
    }
    return _timerDict;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requireDataFromSql];
    [self refreshLoad];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s",__FUNCTION__);
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self setNaviBarItem];
    
    [self setTableView];
    
    [self requireDataFromSql];
    
    UIScreenMode *currentMode = [[UIScreen mainScreen] currentMode];
    NSLog(@"%@",currentMode);
    
    BOOL isTrueiPhoneX = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO);
    
    if ( [self judgeNeedUpdate]) {
       UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"提示" message:@"当前需要升级" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/gamesir-update-tool/id1372674215?mt=8"]];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
    }
    
   
    
}

/**
 * 判断是否需要升级
 */
-(BOOL)judgeNeedUpdate
{
    NSDictionary *bundleDict = [NSBundle mainBundle].infoDictionary;
    NSString *appID = bundleDict[@"CFBundleIdentifier"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/lookup?bundleId=%@",appID]];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data) {
        NSDictionary *lookupDict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([lookupDict[@"resultCount"] integerValue] == 1) {
            NSString* appStoreVersion = lookupDict[@"results"][0][@"version"];
            NSString* currentVersion = bundleDict[@"CFBundleShortVersionString"];
            if ([appStoreVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {
                NSLog(@"\n\nNeed to update. Appstore version %@ is greater than %@",appStoreVersion, currentVersion);
                self.currentVersionReleaseNote = lookupDict[@"results"][0][@"releaseNotes"];
                return YES;
            } else {
                NSLog(@"no need update");
                return NO;
            }
        }
    }
    return NO;
}


/**
 * 获取数据
 */
-(void)requireDataFromSql
{
    //1.获取数据库文件的路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",docPath);
    //设置数据库名称
    NSString *fileName = [docPath stringByAppendingPathComponent:@"plan.sqlite"];
    _db = [FMDatabase databaseWithPath:fileName];
    [_db close];
    if ([_db open]) {
        NSLog(@"打开数据库成功");
    } else {
        NSLog(@"打开数据库失败");
    }
    //查询整个表
    FMResultSet *resultSet = [_db executeQuery:@"select * from t_plan  order by id desc"];
    //遍历结果集合
    [self.plans removeAllObjects];
    while ([resultSet next]) {
        LGHPlanModel *model = [LGHPlanModel new];
        model.numId = [resultSet intForColumn:@"id"];
        model.name = [resultSet objectForColumnName:@"name"];
        model.desc = [resultSet objectForColumnName:@"desc"];
        model.targetDateStr = [resultSet objectForColumnName:@"targetDate"];
        model.isAlert = [resultSet intForColumn:@"isAlert"];
        //设置通知
        if (model.isAlert) {
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyAlert:) name:[@(model.numId) stringValue] object:nil];
        }
        model.backgroundName =[resultSet intForColumn:@"backgroundName"];
        model.status = [resultSet intForColumn:@"status"];
        [self.plans addObject:model];
    }
}

-(void)setNaviBarItem
{
    UIBarButtonItem *editButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"倒时" style:UIBarButtonItemStylePlain target:self action:@selector(refreshLoad)];
    NSDictionary *textAttributes = @{
                                     NSForegroundColorAttributeName: [UIColor blackColor],
                                     NSFontAttributeName:[UIFont fontWithName:@"方圆硬笔行书简" size:30]
                                     };
    [editButtonItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = editButtonItem;
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImageName:@"navi_timeout" target:self action:@selector(homeRightItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)refreshLoad
{
    
    [self.tableView reloadData];
//     [TableViewAnimationKit showWithAnimationType:2 tableView:self.tableView];
}

-(void)homeRightItemAction
{
    /**
     * 需要实现炫酷的present动画。
     */
    LGHPastPlanViewController *pastPlanVC = [[LGHPastPlanViewController alloc]init];
    LGHNavigationController *pastNaviVC = [[LGHNavigationController alloc]initWithRootViewController:pastPlanVC];
    self.hidesBottomBarWhenPushed = YES;
    [self hh_presentCircleVC:pastNaviVC point:CGPointMake([UIScreen mainScreen].bounds.size.width-40, 20) completion:nil];
    self.hidesBottomBarWhenPushed = NO;
}


-(void)setTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   
}


#pragma mark - notify
-(void)notifyAlert:(NSNotification*)notification
{
    NSString *notifyName = notification.name;
    LGHPlanModel *plan = notification.userInfo[@"plan"];
    self.currentNotifyName = notifyName;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"通知" message:[NSString stringWithFormat:@"你的%@目标计划时间已经到了",plan.name] delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
    
}

#pragma mark -UIAlertDelegate
- (void)alertViewCancel:(UIAlertView *)alertView
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:self.currentNotifyName object:nil];
}




#pragma Mark - UITableViewDelegate/UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.plans.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LGHHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    if (!cell) {
        cell =(LGHHomeTableViewCell*) [[[NSBundle mainBundle]loadNibNamed:@"LGHHomeTableViewCell" owner:nil options:nil] firstObject];
    }
    LGHPlanModel *plan = self.plans[indexPath.section];
    [cell setHomeTableViewCellWithPlan:plan];
    cell.protocolDelegate  = self;
    NSDate *firstDate = [NSDate date];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *planDate =[format dateFromString:plan.targetDateStr];
    NSComparisonResult result = [planDate compare:firstDate];
    if (result==-1) {
        cell.showPastTimeLabel.hidden = NO;
        cell.countdownTimeView.hidden = YES;
        if (plan.status!=0) {
            //1.获取数据库文件的路径
            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSLog(@"%@",docPath);
            //设置数据库名称
            NSString *fileName = [docPath stringByAppendingPathComponent:@"plan.sqlite"];
            _db = [FMDatabase databaseWithPath:fileName];
            [_db close];
            if ([_db open]) {
                NSLog(@"打开数据库成功");
            } else {
                NSLog(@"打开数据库失败");
            }
            [_db executeUpdate:@"UPDATE t_plan SET status =0 where id=?",@(plan.numId)];
            [_db close];
        }
    }else{
        NSDictionary *userInfo = @{
                                   @"plan":plan,
                                   @"cell":cell
                                   };
        NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(addNSTimer:) userInfo:userInfo repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        [self.timerDict setValue:timer forKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
    }
    
    
    return cell;
}

-(void)addNSTimer:(NSTimer*)timer
{
    NSDictionary *userInfo =(NSDictionary*) timer.userInfo;
    LGHHomeTableViewCell *cell =(LGHHomeTableViewCell*) userInfo[@"cell"];
    LGHPlanModel *plan = userInfo[@"plan"];
    NSDate *firstDate = [NSDate date];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *planDate =[format dateFromString:plan.targetDateStr];
    NSComparisonResult result = [planDate compare:firstDate];
    if (result==-1) {
        if (plan.isAlert) {
            // 计划的时间到了,发送通知。
            [[NSNotificationCenter defaultCenter]postNotificationName:[@(plan.numId) stringValue] object:nil userInfo:@{@"plan":plan}];
        }
        //1.获取数据库文件的路径
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSLog(@"%@",docPath);
        //设置数据库名称
        NSString *fileName = [docPath stringByAppendingPathComponent:@"plan.sqlite"];
        _db = [FMDatabase databaseWithPath:fileName];
        [_db close];
        if ([_db open]) {
            NSLog(@"打开数据库成功");
        } else {
            NSLog(@"打开数据库失败");
        }
        BOOL updateResult =  [_db executeUpdate:@"UPDATE t_plan SET status =0 where id=?",@(plan.numId)];
        if (updateResult) {
            [timer invalidate];
            cell.showPastTimeLabel.hidden = NO;
            cell.countdownTimeView.hidden = YES;
        }else{
            [timer invalidate];
            NSLog(@"更新数据失败");
        }
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSCalendar* chineseClendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
            NSUInteger unitFlags =NSCalendarUnitMinute| NSCalendarUnitSecond | NSCalendarUnitDay | NSCalendarUnitHour;
            NSDateComponents *cps = [chineseClendar components:unitFlags fromDate:firstDate toDate:planDate options:0];
            NSInteger diffDay = [cps day];
            NSInteger diffHour = [cps hour] ;
            NSInteger diffMinute = [cps minute];
            NSInteger diffSecond = [cps second];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.daysLabel.text = [NSString stringWithFormat:@"%ld",diffDay];
                cell.hoursLabel.text = [NSString stringWithFormat:@"%ld",diffHour];
                cell.minuteLabel.text = [NSString stringWithFormat:@"%ld",diffMinute];
                cell.secondLabel.text = [NSString stringWithFormat:@"%ld",diffSecond];
            });
        });
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LGHHomeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    LGHPlanModel *plan = self.plans[indexPath.section];
    if (!plan.isAlert) {
       MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
        hud.label.text = @"目标已过期，不可修改";
        return;
    }else{
        LGHUpdateViewController *updateVC = [[LGHUpdateViewController alloc]init];
        [self.navigationController  pushViewController:updateVC animated:YES];
        self.tabBarController.tabBar.hidden = YES;
        self.navigationController.delegate = self;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return  0.01;
}

#pragma mark - LGHHomeTableViewCellProtocol

-(void)editThisCellWithModel:(LGHPlanModel *)model{
    LGHAddViewController *addController = [[LGHAddViewController alloc]init];
    [self presentViewController:addController animated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
    if (viewController ==self) {
        self.tabBarController.tabBar.hidden = NO;
    }
}

#pragma Mark - DZNEmptyDataSetSource,DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"empty-box"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"点击创建时间计划";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"当前还未创建任何倒计时计划,请点击创建计划";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    // Do something
    NSLog(@"%s",__FUNCTION__);
    self.tabBarController.selectedIndex = 1;
}


-(void)dealloc
{
    
}



@end
