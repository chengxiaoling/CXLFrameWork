//
//  UIButton+Caches.h
//  ZYYiChat
//
//  Created by wxg on 14-8-29.
//  Copyright (c) 2014年 ZY. All rights reserved.
//

#import <UIKit/UIKit.h>

//按钮的类别，来处理按钮的图片缓存问题
@interface UIButton (Caches)

- (void)setImageWithURLString:(NSString *)urlString;
- (void)setImageWithURLString:(NSString *)urlString placeholder:(UIImage *)image;

- (void)setBackgroundImageWithURLString:(NSString *)urlString;
- (void)setBackgroundImageWithURLString:(NSString *)urlString placeholder:(UIImage *)image;

@end
