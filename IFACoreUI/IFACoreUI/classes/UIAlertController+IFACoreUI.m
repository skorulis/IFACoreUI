//
// Created by Marcelo Schroeder on 26/07/15.
// Copyright (c) 2015 InfoAccent Pty Ltd. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "IFACoreUI.h"

@interface UIAlertController (IFACoreApp_Private)
@property (nonatomic, strong) UIWindow *alertWindow;
@end

@implementation UIAlertController (IFACoreApp)

#pragma mark - Public

- (void)ifa_presentAnimated:(BOOL)animated
             withCompletion:(void (^)(void))completion {
    self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow.rootViewController = [[IFAAlertContainerViewController alloc] init];
    self.alertWindow.windowLevel = UIWindowLevelAlert + 1;  // Makes sure the alert is presented on top of any other alert already being presented
    [self.alertWindow makeKeyAndVisible];
    [self.alertWindow.rootViewController presentViewController:self animated:animated completion:completion];
    self.view.tintColor = self.ifa_appearanceTheme.defaultTintColor;
}

#pragma mark - Private

- (void)setAlertWindow:(UIWindow *)alertWindow {
    objc_setAssociatedObject(self, @selector(alertWindow), alertWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIWindow *)alertWindow {
    return objc_getAssociatedObject(self, @selector(alertWindow));
}

@end
