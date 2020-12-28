//
//  LGHPastPlanViewController.m
//  ThirdFramework
//
//  Created by 刘观华 on 2018/7/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LGHPastPlanViewController.h"
#import "UIBarButtonItem+Item.h"
#import "FMDatabase.h"
#import "LGHPlanModel.h"
#import "LGHHomeTableViewCell.h"
@interface LGHPastPlanViewController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic, strong) UITableView *play;

@property(nonatomic, strong) FMDatabase *db;

@property(nonatomic,strong)NSMutableArray *plans;

@end

@implementation LGHPastPlanViewController


-(NSMutableArray*) plans
{
    if (!_plans) {
        _plans =  [NSMutableArray array] ;
    }
    return _plans ;
}


- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"过期目标";
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithImageName:@"navi_back" target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self setTableView];
    
    [self requireDataFromSql];
    
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
    NSLog(@"fileName = %@",fileName);
    _db = [FMDatabase databaseWithPath:fileName];
    [_db close];
    if ([_db open]) {
        NSLog(@"打开数据库成功");
    } else {
        NSLog(@"打开数据库失败");
    }
    //查询整个表
    FMResultSet *resultSet = [_db executeQuery:@"select * from t_plan where status=0 order by id desc"];
    //遍历结果集合
    while ([resultSet next]) {
        LGHPlanModel *model = [LGHPlanModel new];
        model.numId = [resultSet intForColumn:@"id"];
        model.name = [resultSet objectForColumnName:@"name"];
        model.desc = [resultSet objectForColumnName:@"desc"];
        model.targetDateStr = [resultSet objectForColumnName:@"targetDate"];
        model.isAlert = [resultSet intForColumn:@"isAlert"];
        model.backgroundName =[resultSet intForColumn:@"backgroundName"];
        model.status = [resultSet intForColumn:@"status"];
        [self.plans addObject:model];
    }
}
    
-(void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
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
    cell.countdownTimeView.hidden = YES;
    cell.showPastTimeLabel.hidden = NO;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LGHHomeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
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

#pragma Mark - DZNEmptyDataSetSource,DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"empty-box"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无过期目标";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"当前还没有过期目标,请耐性等待";
    
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







@end
