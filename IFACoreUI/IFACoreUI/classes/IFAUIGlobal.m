//
// Created by Marcelo Schroeder on 24/04/15.
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


@implementation IFAUIGlobal {

}

#pragma mark - Public

- (UIViewController *)popoverControllerPresenter {
    return [[UIViewController class] ifa_popoverControllerPresenter];
}

- (UIViewController *)semiModalViewController {
    return [[UIViewController class] semiModalViewController];
}

- (BOOL)semiModalViewPresentedInLandscapeInterfaceOrientation {
    return [[UIViewController class] semiModalViewPresentedInLandscapeInterfaceOrientation];
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