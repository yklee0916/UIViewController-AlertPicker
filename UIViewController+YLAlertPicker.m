//
// UIViewController+YLAlertPicker.m
// Version 1.0.1
// Copyright (c) 2012-2017 Young Ki Lee
//
// This code is distributed under the terms and conditions of the MIT license.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIViewController+YLAlertPicker.h"
#import <objc/message.h>

@interface UIViewController ()

@property (nonatomic, strong) UIAlertController *alertPicker;
@property (nonatomic, strong) NSArray <NSString *> *alertPickerRows;
@property (nonatomic, copy) AlertPickerDone alertPickerDoneBlock;
@property (nonatomic, copy) AlertPickerCancel alertPickerCancelBlock;

@end

@implementation UIViewController (YLAlertPicker)

- (void)showPickerWithTitle:(NSString *)title
                    message:(NSString *)message
                       rows:(NSArray <NSString *> *)rows
                cancelTitle:(NSString *)cancelTitle
                  doneBlock:(AlertPickerDone)doneBlock
                cancelBlock:(AlertPickerCancel)cancelBlock {

    self.alertPicker = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    self.alertPickerRows = rows;
    self.alertPickerDoneBlock = doneBlock;
    self.alertPickerCancelBlock = cancelBlock;
    
    for(NSString *row in rows) {
        [self addDefaultActionWithTitle:row];
    }
    
    [self addCancelActionWithTitle:cancelTitle];
    
    // relayout for iPad
    UIView *sourceView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    self.alertPicker.popoverPresentationController.sourceView = sourceView;
    self.alertPicker.popoverPresentationController.sourceRect = CGRectMake(sourceView.frame.size.width/2, sourceView.frame.size.height-1, 1, 1);
    
    [self presentViewController:self.alertPicker animated:YES completion:nil];
}

- (void)addDefaultActionWithTitle:(NSString *)title {
    UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
        NSUInteger selectedIndex = [self.alertPicker.actions indexOfObject:action];
        
        if(self.alertPickerDoneBlock) {
            self.alertPickerDoneBlock(self.alertPickerRows, selectedIndex);
        }
    }];
    [self.alertPicker addAction:action];
}

- (void)addCancelActionWithTitle:(NSString *)title {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:title?:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        if(self.alertPickerCancelBlock) {
            self.alertPickerCancelBlock(self.alertPickerRows);
        }
    }];
    [self.alertPicker addAction:cancelAction];
}

- (void)showPickerWithTitle:(NSString *)title
                       rows:(NSArray <NSString *> *)rows
                cancelTitle:(NSString *)cancelTitle
                  doneBlock:(AlertPickerDone)doneBlock {
    [self showPickerWithTitle:title message:nil rows:rows cancelTitle:cancelTitle doneBlock:doneBlock cancelBlock:nil];
}

- (UIAlertController *)alertPicker {
    return objc_getAssociatedObject(self, @selector(alertPicker));
}

- (void)setAlertPicker:(UIAlertController *)alertPicker {
    objc_setAssociatedObject(self, @selector(alertPicker), alertPicker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray <NSString *> *)alertPickerRows {
    return objc_getAssociatedObject(self, @selector(alertPickerRows));
}

- (void)setAlertPickerRows:(NSArray <NSString *> *)alertPickerRows {
    objc_setAssociatedObject(self, @selector(alertPickerRows), alertPickerRows, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AlertPickerDone)alertPickerDoneBlock {
    return objc_getAssociatedObject(self, @selector(alertPickerDoneBlock));
}

- (void)setAlertPickerDoneBlock:(AlertPickerDone)alertPickerDoneBlock {
    objc_setAssociatedObject(self, @selector(alertPickerDoneBlock), alertPickerDoneBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (AlertPickerCancel)alertPickerCancelBlock {
    return objc_getAssociatedObject(self, @selector(alertPickerCancelBlock));
}

- (void)setAlertPickerCancelBlock:(AlertPickerCancel)alertPickerCancelBlock {
    objc_setAssociatedObject(self, @selector(alertPickerCancelBlock), alertPickerCancelBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
