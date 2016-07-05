//
//  ZYImageManager.m
//  ZYImageCache
//
//  Created by wxg on 14-8-26.
//  Copyright (c) 2014年 ZY. All rights reserved.
//

#import "ZYImageManager.h"
#import "NSString+Addition.h"
#import "NSString+MD5.h"
#import <UIKit/UIKit.h>
@implementation ZYImageManager

static ZYImageManager *_manager = nil;

//shareManager每次获得的都是同一个对象，对象一旦创建就不能更改
+ (id)shareManager
{
    if (nil == _manager) {
        _manager = [[self alloc] init];
    }
    return _manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.imageCaches = [NSMutableDictionary dictionaryWithCapacity:0];
        //当内存报警的时候清理内存中的图片
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCaches) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}
//清理内存
- (void)clearCaches
{
    [self.imageCaches removeAllObjects];
}
//清理本地缓存
- (BOOL)clearLocalDataWithPath:(NSString *)path
{
    //删除此文件夹
    NSFileManager *manager = [NSFileManager defaultManager];
    return [manager removeItemAtPath:path error:nil];
}

#pragma mark create by wxg
#pragma mark 计算缓存文件的大小
#pragma mark -------------以下----------------
//通常用于删除缓存的时，计算缓存大小
//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float) folderSizeAtPath:(NSString*) folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

//获得本地缓存文件的大小
- (float)getLocalDataLengthWithPath:(NSString *)path
{
    return [self folderSizeAtPath:path];
}
#pragma mark -----------以上------------------

//ZYImageManager提供一个接口，这个接口负责从内存中读取相应的数据
- (UIImage *)getImageInCachesWithURLString:(NSString *)urlString
{
    UIImage *image = [self.imageCaches objectForKey:urlString];
    return image;
}

//ZYImageManager提供一个接口，这个接口负责从本地读取相应的数据，读到数据后并且要把数据加载到内存中
- (UIImage *)getImageInLocalWithURLString:(NSString *)urlString
{
    //从本地读取  urlString  不可以作为文件名，因为URL中有区分目录的"/"，所以不能直接用，如果去掉"/"又太麻烦，所以综合一下，可以使用简单的加密/编码来完成
    NSString *filePath = [NSString getFileWithPath:[NSString stringWithFormat:@"imagecaches/%@", [urlString MD5Hash]]];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [UIImage imageWithData:data];
    if (image) {
        //如果图片存在  加载到内存中
        [self.imageCaches setObject:image forKey:urlString];
    }
    return image;
}

//下载图片 处理要下载数据并且显示出来，还需要把数据存放到本地，还需要加载到内存
- (void)downloadImageWithURLString:(NSString *)urlString toImageView:(UIImageView *)imageView isEncrypt:(BOOL)isEncrypt
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        //分线程来处理数据
        NSData *newData = nil;
        NSURL *url = [NSURL URLWithString:urlString];
        if (isEncrypt==NO) {
            newData = [NSData dataWithContentsOfURL:url];
        }else{
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSLog(@"-网络获取了数据---");
            Byte *testByte = (Byte *)[data bytes];
            NSLog(@"-转换成字节-length==%lu-",(unsigned long)[data length]);
            for(int i=0;i<[data length];i++){
                if (testByte[i]==255 && testByte[i+1]==217) {
                    NSRange rangeD = {i+2,[data length]};
                    newData = [data subdataWithRange:rangeD];
                    NSLog(@"===lengte=%d=",i);
                    break;
                }
            }

        }
        
//
        NSLog(@"获取到想要的照片");
        UIImage *image = [UIImage imageWithData:newData];
        
        if (image) {
            //加载到内存
            [self.imageCaches setObject:image forKey:urlString];
            
            //存放到本地
            NSString *filePath = [NSString getFileWithPath:[NSString stringWithFormat:@"imagecaches/%@", [urlString MD5Hash]]];
            [newData writeToFile:filePath atomically:YES];
            
            //需要显示出来
            dispatch_async(dispatch_get_main_queue(), ^{
                //主线程刷新UI
                imageView.image = image;
            });
        }
    });
}

//处理按钮图片缓存的结果的结果
- (void)downloadButtonImageWithURLString:(NSString *)urlString complete:(void (^)(UIImage *image))complete
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        //分线程来处理数据
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        UIImage *image = [UIImage imageWithData:data];
        
        if (image) {
            //加载到内存
            [self.imageCaches setObject:image forKey:urlString];
            
            //存放到本地
            NSString *filePath = [NSString getFileWithPath:[NSString stringWithFormat:@"imagecaches/%@", [urlString MD5Hash]]];
            [data writeToFile:filePath atomically:YES];
            
            //需要显示出来
            dispatch_async(dispatch_get_main_queue(), ^{
                //主线程刷新UI
                complete(image);
            });
        }
    });
}

- (void)dealloc
{
    [_imageCaches release];
    
    [super dealloc];
}

@end
