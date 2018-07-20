//
//  JHPhotoChangeManager.h
//  JHKit
//
//  Created by HaoCold on 16/9/20.
//  Copyright © 2016年 HaoCold. All rights reserved.
//
//  MIT License
//
//  Copyright (c) 2017 xjh093
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

/**< 访问相册 与 拍照  改变头像等 */

/**
 Example 1:
 
 [[JHPhotoChangeManager manager] showInVC:self image:^(UIImage *editImage, UIImage *originalImage) {
    // code goes here.
 }];
 
 Example 2:
 [JHPhotoChangeManager manager].viewController = self;
 [JHPhotoChangeManager manager].chooseCallback = ^(UIImage *editImage, UIImage *originalImage) {
 // code goes here.
 };
 [[JHPhotoChangeManager manager] takePhoto];
 // or
 //[[JHPhotoChangeManager manager] openLocalPhoto];
 
 */
#import <UIKit/UIKit.h>

typedef void(^JHChooseCallback)(UIImage *editImage, UIImage *originalImage);

@interface JHPhotoChangeManager : NSObject

@property (nonatomic,    weak) UIViewController *viewController;
@property (nonatomic,    copy) JHChooseCallback  chooseCallback;

+ (instancetype)manager;

/**
 default is:
 
        拍照
        相册
        取消
 */
- (void)showInVC:(UIViewController *)vc image:(JHChooseCallback)callback;
- (void)showInVC:(UIViewController *)vc firstTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTitle cancelTitle:(NSString *)cancelTitle image:(JHChooseCallback)callback;

- (void)takePhoto;
- (void)openLocalPhoto;

@end


