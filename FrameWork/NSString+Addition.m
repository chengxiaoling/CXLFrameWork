//
//  NSString+Addition.m
//  ZYLeiBieTest
//
//  Created by wxg on 14-8-19.
//  Copyright (c) 2014年 ZY. All rights reserved.
//

#import "NSString+Addition.h"

@implementation NSString (Addition)

//获得沙河路径
+ (NSString *)getHomePath;
{
    return NSHomeDirectory();
}
//获得Documents路径
+ (NSString *)getDocumentsPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
}

//获得Documents下得某个目录，而且确保这个目录一定会存在
+ (NSString *)getDirectoryWithPath:(NSString *)path
{
    //获得Documents路径
    NSString *tempPath = [self getDocumentsPath];
    //把路径拼接完整
    NSString *fPath = [tempPath stringByAppendingPathComponent:path];
    
    //如果目录不存在，那么就创建目录
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:fPath]) {
        [manager createDirectoryAtPath:fPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return fPath;
}


//此种方式不允许目录名和文件名相同
//不可取
/*
+ (NSString *)getFileWithPath:(NSString *)path
{
    
    //web/images/1.png
    
    //通过“/”来拆分字符串
    NSArray *array = [path componentsSeparatedByString:@"/"];
    //最后一个作为文件名
    NSString *filename = [array lastObject];
    
    //把文件名替换用空给替换掉，但是如果目录中有和文件名相同的目录名，其也会被替换掉，可能出问题
    NSString *dPath = [path stringByReplacingOccurrencesOfString:filename withString:@""];
    
    //创建一个目录
    NSString *tempPath = [self getDirectoryWithPath:dPath];
    
    //把路径拼接完整
    NSString *fPath = [tempPath stringByAppendingPathComponent:filename];
    //如果文件不存在，那么就创建文件
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:fPath]) {
        [manager createFileAtPath:fPath contents:nil attributes:nil];
    }
        
    return fPath;
}
 */

+ (NSString *)getFileWithPath:(NSString *)path
{
    
    //web/images/1.png
    
    //通过“/”来拆分字符串
    NSArray *array = [path componentsSeparatedByString:@"/"];
    //最后一个作为文件名
    NSString *filename = [array lastObject];
    if ([filename isEqualToString:@""]) {
        filename = [array objectAtIndex:array.count-2];
    }
    
    //把最后的文件名给舍弃掉
    NSRange range = [path rangeOfString:filename options:NSBackwardsSearch];
    
    NSString *dPath = [path stringByReplacingCharactersInRange:range withString:@""];
    
    //创建一个目录
    NSString *tempPath = [self getDirectoryWithPath:dPath];
    
    //把路径拼接完整
    NSString *fPath = [tempPath stringByAppendingPathComponent:filename];
    //如果文件不存在，那么就创建文件
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:fPath]) {
        //[manager createFileAtPath:fPath contents:nil attributes:nil];
    }
    
    return fPath;
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)containOfString:(NSString *)string
{
    return [self rangeOfString:string].length != 0;
}

@end











