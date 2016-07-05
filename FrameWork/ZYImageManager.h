//
//  ZYImageManager.h
//  ZYImageCache
//
//  Created by wxg on 14-8-26.
//  Copyright (c) 2014年 ZY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZYImageManager : NSObject
//创建一个全局的唯一的字典将来用于存放内存中的所有图片
@property (nonatomic, retain)NSMutableDictionary *imageCaches;

+ (id)shareManager;

//ZYImageManager提供一个接口，这个接口负责从内存中读取相应的数据
- (UIImage *)getImageInCachesWithURLString:(NSString *)urlString;
//ZYImageManager提供一个接口，这个接口负责从本地读取相应的数据，读到数据后并且要把数据加载到内存中
- (UIImage *)getImageInLocalWithURLString:(NSString *)urlString;
//下载图片 处理要下载数据并且显示出来，还需要把数据存放到本地，还需要加载到内存
- (void)downloadImageWithURLString:(NSString *)urlString toImageView:(UIImageView *)imageView isEncrypt:(BOOL)isEncrypt;

//处理按钮图片缓存的结果的结果
- (void)downloadButtonImageWithURLString:(NSString *)urlString complete:(void (^)(UIImage *image))complete;

//清理本地缓存
- (BOOL)clearLocalDataWithPath:(NSString *)path;

//获得本地缓存文件的大小
- (float)getLocalDataLengthWithPath:(NSString *)path;

@end
