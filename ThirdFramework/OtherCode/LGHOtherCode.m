//
//  LGHOtherCode.m
//  ThirdFramework
//
//  Created by 刘观华 on 2018/7/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LGHOtherCode.h"

@implementation LGHOtherCode

/* 下载文件*/
-(void)downLoadAction
{
    //使用AFN下载
    NSString *url = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531978567763&di=70d3bd751feee4b1f38785975243a572&imgtype=0&src=http%3A%2F%2Fimg.sccnn.com%2Fbimg%2F338%2F24556.jpg";
    //    NSString *url = @"";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDownloadTask *task =  [[AFHTTPSessionManager manager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"完成进度 %f",1.0* downloadProgress.completedUnitCount/ downloadProgress.totalUnitCount);
    }  destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename] ;
        return [NSURL URLWithString:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"filePath=%@",filePath);
    }];
    
    [task resume];
}

/* 上传的请求都是POST请求*/
-(void) upLoadAction
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    NSDictionary *dictM = @{}
    //2.发送post请求上传文件
    /*
     第一个参数:请求路径
     第二个参数:字典(非文件参数)
     第三个参数:constructingBodyWithBlock 处理要上传的文件数据
     第四个参数:进度回调
     第五个参数:成功回调 responseObject:响应体信息
     第六个参数:失败回调
     */
    [manager POST:@"http://120.25.226.186:32812/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        UIImage *image = [UIImage imageNamed:@"Snip20160227_128"];
        NSData *imageData = UIImagePNGRepresentation(image);
        
        //使用formData来拼接数据
        /*
         第一个参数:二进制数据 要上传的文件参数
         第二个参数:服务器规定的
         第三个参数:该文件上传到服务器以什么名称保存
         第四个参数:文件的类型
         */
        //[formData appendPartWithFileData:imageData name:@"file" fileName:@"xxxx.png" mimeType:@"image/png"];
        
        //[formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/Users/xiaomage/Desktop/Snip20160227_128.png"] name:@"file" fileName:@"123.png" mimeType:@"image/png" error:nil];
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/Users/xiaomage/Desktop/Snip20160227_128.png"] name:@"file" error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度:%f",1.0*uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
    }];
}


@end
