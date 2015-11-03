//
// Created by Marcelo Schroeder on 20/08/15.
// Copyright (c) 2015 InfoAccent Pty Ltd. All rights reserved.
//

#import "IFACoreUI.h"
#import "IFAAnalyticsManager.h"


@implementation IFAAnalyticsManager {

}

#pragma mark - Public

- (void)notifyViewDidAppearEventForViewController:(UIViewController *)viewController {
    if ([self.delegate respondsToSelector:@selector(analyticsManager:didReceiveViewDidAppearEventForViewController:)]) {
        [self.delegate       analyticsManager:self
didReceiveViewDidAppearEventForViewController:viewController];
    }
}

+ (instancetype)sharedInstance {
    static dispatch_once_t c_dispatchOncePredicate;
    static id c_instance = nil;
    dispatch_once(&c_dispatchOncePredicate, ^{
        c_instance = [self new];
    });
    return c_instance;
}

@end