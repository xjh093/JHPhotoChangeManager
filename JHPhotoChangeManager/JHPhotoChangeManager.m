//
//  JHPhotoChangeManager.m
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

#import "JHPhotoChangeManager.h"

@interface JHPhotoChangeManager()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (copy,    nonatomic) JHChooseCallback callback;

@property (weak,    nonatomic) UIViewController     *vc;

@end

@implementation JHPhotoChangeManager

+ (instancetype)manager{
    static JHPhotoChangeManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JHPhotoChangeManager alloc] init];
    });
    return manager;
}

- (void)setViewController:(UIViewController *)viewController{
    _vc = viewController;
}

- (UIViewController *)viewController{
    return _vc;
}

- (void)setChooseCallback:(JHChooseCallback)chooseCallback{
    _callback = chooseCallback;
}

- (JHChooseCallback)chooseCallback{
    return _callback;
}

- (void)takePhoto{
    [self jhTakePhoto];
}

- (void)openLocalPhoto{
    [self jhOpenLocalPhoto];
}

- (void)showInVC:(UIViewController *)vc image:(JHChooseCallback)callback{
    
    //保存block
    _callback = callback;
    _vc = vc;
    
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self jhTakePhoto];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self jhOpenLocalPhoto];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [sheet addAction:action1];
    [sheet addAction:action2];
    [sheet addAction:action3];
    
    [vc presentViewController:sheet animated:YES completion:nil];
}

- (void)jhHandleResult:(NSInteger)index
{
    if (1 == index) {  //拍照
        [self jhTakePhoto];
    }else if (2 == index){  //相册
        [self jhOpenLocalPhoto];
    }
}

- (void)jhTakePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [_vc presentViewController:picker animated:YES completion:nil];
    }else{
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
    
}

- (void)jhOpenLocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES; //设置选择后的图片可被编辑
    [_vc presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *edit = info[UIImagePickerControllerEditedImage];
    UIImage *original = info[UIImagePickerControllerOriginalImage];
    
    if (_callback) {
        _callback(edit,original);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end

