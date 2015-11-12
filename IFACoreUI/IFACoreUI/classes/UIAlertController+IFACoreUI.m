//
// Created by Marcelo Schroeder on 26/07/15.
// Copyright (c) 2015 InfoAccent Pty Ltd. All rights reserved.
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
    self.view.tintColor = self.ifa_appearanceTheme.defaultTintColor;
//    self.alertWindow.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    self.alertWindow.rootViewController = [[IFAViewController alloc] init];
    self.alertWindow.windowLevel = UIWindowLevelAlert + 1;  // Makes sure the alert is presented on top of any other alert already being presented
    [self.alertWindow makeKeyAndVisible];
    [self.alertWindow.rootViewController presentViewController:self animated:animated completion:completion];
}

#pragma mark - Private

- (void)setAlertWindow:(UIWindow *)alertWindow {
    objc_setAssociatedObject(self, @selector(alertWindow), alertWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIWindow *)alertWindow {
    return objc_getAssociatedObject(self, @selector(alertWindow));
}

@end
