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

@interface IFAKeyboardVisibilityManager ()
@property (nonatomic, getter = isKeyboardVisible) BOOL keyboardVisible;
@property(nonatomic) CGRect keyboardFrame;
@end

@implementation IFAKeyboardVisibilityManager {

}

#pragma mark - Public

- (void)startObservingKeyboard {
    [self IFA_addObservers];
}

+ (instancetype)sharedInstance {
    static dispatch_once_t c_dispatchOncePredicate;
    static id c_instance = nil;
    dispatch_once(&c_dispatchOncePredicate, ^{
        c_instance = [self new];
    });
    return c_instance;
}

#pragma mark - Overrides

- (void)dealloc {
    [self IFA_removeObservers];
}

#pragma mark - Private

- (void)IFA_addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(IFA_onKeyboardNotification:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(IFA_onKeyboardNotification:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)IFA_removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

-(void)IFA_onKeyboardNotification:(NSNotification*)a_notification{

    //    NSLog(@"m_onKeyboardNotification");

    if([a_notification.name isEqualToString:UIKeyboardDidShowNotification] || [a_notification.name isEqualToString:UIKeyboardDidHideNotification]) {

        self.keyboardVisible = [a_notification.name isEqualToString:UIKeyboardDidShowNotification];

    }else{
        NSAssert(NO, @"Unexpected notification name: %@", a_notification.name);
    }

    if (self.keyboardVisible) {

        NSDictionary *l_userInfo = [a_notification userInfo];
        self.keyboardFrame = [l_userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    }else{

        self.keyboardFrame = CGRectZero;

    }

}

@end