//
//  IFAWorkInProgressModalViewManager.m
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 18/04/11.
//  Copyright 2010 InfoAccent Pty Limited. All rights reserved.
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

@interface IFAWorkInProgressModalViewManager ()
@property (nonatomic, strong) IFAHudViewController *hudViewController;
@end

@implementation IFAWorkInProgressModalViewManager

#pragma mark - Public

-(void)setDeterminateProgress:(BOOL)determinateProgress {
    self.hudViewController.visualIndicatorMode = determinateProgress ? IFAHudViewVisualIndicatorModeProgressDeterminate : IFAHudViewVisualIndicatorModeProgressIndeterminate;
}

-(BOOL)determinateProgress {
    return self.hudViewController.visualIndicatorMode == IFAHudViewVisualIndicatorModeProgressDeterminate;
}

-(void)setDeterminateProgressPercentage:(CGFloat)determinateProgressPercentage {
    self.hudViewController.progress = determinateProgressPercentage;
}

-(CGFloat)determinateProgressPercentage {
    return self.hudViewController.progress;
}

- (NSString *)progressMessage {
    return self.hudViewController.text;
}

- (void)setProgressMessage:(NSString *)progressMessage {
    self.hudViewController.text = progressMessage;
}

- (void)showViewWithMessage:(NSString *)a_message {
    [self showViewWithMessage:a_message
         parentViewController:nil
                   parentView:nil
                     animated:YES
                   completion:nil];
}

- (void)hideView {
    [self hideViewAnimated:YES completion:nil];
}

- (void)showViewWithMessage:(NSString *)a_message
       parentViewController:(UIViewController *)a_parentViewController
                 parentView:(UIView *)a_parentView
                   animated:(BOOL)a_animated
                 completion:(void (^)(BOOL a_finished))a_completion {
    self.hasBeenCancelled = NO;
    self.hudViewController.text = a_message;
    if (self.cancellationCompletionBlock) {
        self.hudViewController.detailText = NSLocalizedStringFromTable(@"Tap to cancel", @"IFALocalizable", nil);
        __weak __typeof(self) weakSelf = self;
        self.hudViewController.chromeTapActionBlock = ^{
            weakSelf.hasBeenCancelled = YES;
            weakSelf.hudViewController.visualIndicatorMode = IFAHudViewVisualIndicatorModeProgressIndeterminate;
            weakSelf.hudViewController.detailText = NSLocalizedStringFromTable(@"Cancelling...", @"IFALocalizable", nil);
            if (weakSelf.cancellationCompletionBlock) {
                weakSelf.cancellationCompletionBlock();
            }
        };
    } else {
        self.hudViewController.detailText = nil;
        self.hudViewController.chromeTapActionBlock = ^{};
    }
    [self.hudViewController presentHudViewControllerWithParentViewController:a_parentViewController
                                                                  parentView:a_parentView
                                                                    animated:a_animated
                                                                  completion:a_completion];
}

- (void)hideViewAnimated:(BOOL)a_animated
              completion:(void (^)(BOOL a_finished))a_completion {
    [self.hudViewController dismissHudViewControllerWithAnimated:a_animated
                                                      completion:a_completion];
}

- (IFAHudViewController *)hudViewController {
    if (!_hudViewController) {
        _hudViewController = [IFAHudViewController new];
        _hudViewController.visualIndicatorMode = IFAHudViewVisualIndicatorModeProgressIndeterminate;
    }
    return _hudViewController;
}

@end
