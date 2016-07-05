//
//  NSString+Addition.h
//  ZYLeiBieTest
//
//  Created by wxg on 14-8-19.
//  Copyright (c) 2014年 ZY. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 类别和继承
 
 类别：其是轻量级的，只是对原有类的一个扩充，类别和原有类都是相对独立的
 继承：是重量级的，子类除了可以扩充父类的属性和方法，还具备父类的所有功能
 
 有个类A  1吨  相对其扩充B 500克 这些功能
 类别：（B） 500克
 子类：（A+B） 1吨+500克
 
 */

//1.扩充原有类的方法
//类别是对原有类的扩充，不是一个新类的声明，其只是扩充原有类的方法，不改变原有类的结构
//类别不能直接扩充原有类的属性，可以间接扩充，因为现在的@property可以隐式声明一个带“_”的属性
//类别的形式是：@interface 原有类的类名 (声明的别名)

/*
 类别的声明
 @interface NSString (Addition)
 //只有方法区，没有属性区
 @end
 
 类别的实现
 @implementation NSString (Addition)
 @end
  */

@interface NSString (Addition)
//扩充原有类方法的区域，不能扩充属性
//可以扩充类方法
+ (NSString *)getHomePath;
+ (NSString *)getDocumentsPath;
+ (NSString *)getDirectoryWithPath:(NSString *)path;
+ (NSString *)getFileWithPath:(NSString *)path;

//类别还可以扩充实例方法
//去空格和换行符，一般在网络请求过来的数据出用
- (NSString *)trim;
//查找这个字符串是否包含另外一个字符串，一般用于模糊查找
- (BOOL)containOfString:(NSString *)string;

//类别还可以重写原有类的方法
//重写的原有类方法可能会被调用，所以说，不建议重写原有类的方法，因为调用哪个不确定
//- (BOOL)isEqualToString:(NSString *)aString;

@end



