//
//  LGHSettingViewController.m
//  ThirdFramework
//
//  Created by 刘观华 on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LGHSettingViewController.h"
#import <MessageUI/MessageUI.h>
@interface LGHSettingViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>

@end

@implementation LGHSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *editButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:nil action:nil];
    NSDictionary *textAttributes = @{
                                     NSForegroundColorAttributeName: [UIColor blackColor],
                                     NSFontAttributeName:[UIFont fontWithName:@"方圆硬笔行书简" size:25]
                                     };
    [editButtonItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = editButtonItem;
}

#pragma Mark - UITableViewDelegate,UITableViewDataSource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath == [NSIndexPath indexPathForRow:0 inSection:2]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://github.com/xiaofeiguan"]];
    }
    if (indexPath == [NSIndexPath indexPathForRow:1 inSection:2]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://weibo.com/1997571953/profile"]];
    }
    if (indexPath == [NSIndexPath indexPathForRow:0 inSection:1]) {
        
    }
    if (indexPath == [NSIndexPath indexPathForRow:1 inSection:1]) {
        
    }
    if (indexPath == [NSIndexPath indexPathForRow:0 inSection:0]) {
        [self sendEmailAction];
    }
    if (indexPath == [NSIndexPath indexPathForRow:1 inSection:0]) {
        
    }
    if (indexPath == [NSIndexPath indexPathForRow:2 inSection:0]) {
        
    }
}

-(void)sendEmailAction
{
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init]; // 设置邮件代理
    [mailCompose setMailComposeDelegate:self]; // 设置收件人
    [mailCompose setToRecipients:@[@"sparkle_ds@163.com"]]; // 设置抄送人
    [mailCompose setCcRecipients:@[@"1622849369@qq.com"]]; // 设置密送人
    [mailCompose setBccRecipients:@[@"15690725786@163.com"]]; // 设置邮件主题
    [mailCompose setSubject:@"设置邮件主题"]; //设置邮件的正文内容
    NSString *emailContent = @"我是邮件内容"; // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO]; // 如使用HTML格式，则为以下代码 //
    [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES]; //添加附件
    UIImage *image = [UIImage imageNamed:@"qq"];
    NSData *imageData = UIImagePNGRepresentation(image);
    [mailCompose addAttachmentData:imageData mimeType:@"" fileName:@"qq.png"];
    NSString *file = [[NSBundle mainBundle] pathForResource:@"EmptyPDF" ofType:@"pdf"];
    NSData *pdf = [NSData dataWithContentsOfFile:file];
    [mailCompose addAttachmentData:pdf mimeType:@"" fileName:@"EmptyPDF.pdf"]; // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate的代理方法：
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{ switch (result) {
    case MFMailComposeResultCancelled:
        NSLog(@"Mail send canceled: 用户取消编辑");
        break;
    case MFMailComposeResultSaved:
        NSLog(@"Mail saved: 用户保存邮件");
        break;
    case MFMailComposeResultSent:
        NSLog(@"Mail sent: 用户点击发送");
        break;
    case MFMailComposeResultFailed:
        NSLog(@"Mail send errored: %@ : 用户尝试保存或发送邮件失败", [error localizedDescription]);
        break;
        }
    /**关闭邮件发送视图**/
    [controller dismissViewControllerAnimated:YES completion:nil];
}




@end
