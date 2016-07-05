//
//  UIImageView+Caches.m
//  ZYImageCache
//
//  Created by wxg on 14-8-26.
//  Copyright (c) 2014年 ZY. All rights reserved.
//

#import "UIImageView+Caches.h"

@implementation UIImageView (Caches)

- (void)setImageWithURLString:(NSString *)urlString isEncrypt:(BOOL)isEncrypt
{
    
    
    ZYImageManager *manager = [ZYImageManager shareManager];
    //显示图片的步骤：
    //1.内存 有：加载  如果内存中没有<下一步>
    //内存中存放图片的地方要全局唯一，所以要用单例类
    UIImage *image = [manager getImageInCachesWithURLString:urlString];
    if (image) {
        self.image = image;
        return;
    }
    
    //2.本地读取  有：加载并加载到内存  没有<下一步>
    image = [manager getImageInLocalWithURLString:urlString];
    if (image) {
        self.image = image;
        return;
    }
    
    //3.网络请求  除了加载出来，还要缓存到本地和内存中
    [manager downloadImageWithURLString:urlString toImageView:self isEncrypt:isEncrypt];    
}

- (void)setImageWithURLString:(NSString *)urlString placeholder:(UIImage *)image isEncrypt:(BOOL)isEncrypt
{
    self.image = image;
    [self setImageWithURLString:urlString isEncrypt:isEncrypt];
}

@end
