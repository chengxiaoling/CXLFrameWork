//
//  UIButton+Caches.m
//  ZYYiChat
//
//  Created by wxg on 14-8-29.
//  Copyright (c) 2014年 ZY. All rights reserved.
//

#import "UIButton+Caches.h"
#import "ZYImageManager.h"
@implementation UIButton (Caches)

- (void)setImageWithURLString:(NSString *)urlString
{
    ZYImageManager *manager = [ZYImageManager shareManager];
    //显示图片的步骤：
    //1.内存 有：加载  如果内存中没有<下一步>
    //内存中存放图片的地方要全局唯一，所以要用单例类
    UIImage *image = [manager getImageInCachesWithURLString:urlString];
    if (image) {
        [self setImage:image forState:UIControlStateNormal];
        return;
    }
    
    //2.本地读取  有：加载并加载到内存  没有<下一步>
    image = [manager getImageInLocalWithURLString:urlString];
    if (image) {
        [self setImage:image forState:UIControlStateNormal];
        return;
    }
    
    //3.网络请求  除了加载出来，还要缓存到本地和内存中
    [manager downloadButtonImageWithURLString:urlString complete:^(UIImage *image) {
        [self setImage:image forState:UIControlStateNormal];
    }];
}
- (void)setImageWithURLString:(NSString *)urlString placeholder:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
    [self setImageWithURLString:urlString];
}

- (void)setBackgroundImageWithURLString:(NSString *)urlString
{
    ZYImageManager *manager = [ZYImageManager shareManager];
    //显示图片的步骤：
    //1.内存 有：加载  如果内存中没有<下一步>
    //内存中存放图片的地方要全局唯一，所以要用单例类
    UIImage *image = [manager getImageInCachesWithURLString:urlString];
    if (image) {
        [self setBackgroundImage:image forState:UIControlStateNormal];
        return;
    }
    
    //2.本地读取  有：加载并加载到内存  没有<下一步>
    image = [manager getImageInLocalWithURLString:urlString];
    if (image) {
        [self setBackgroundImage:image forState:UIControlStateNormal];
        return;
    }
    
    //3.网络请求  除了加载出来，还要缓存到本地和内存中
    [manager downloadButtonImageWithURLString:urlString complete:^(UIImage *image) {
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }];
}
- (void)setBackgroundImageWithURLString:(NSString *)urlString placeholder:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setBackgroundImageWithURLString:urlString];
}

@end
