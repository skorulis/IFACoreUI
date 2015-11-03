//
// Created by Marcelo Schroeder on 27/04/15.
// Copyright (c) 2015 InfoAccent Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IFATableViewController;

@protocol IFAPagingContainer <NSObject>

@required

@property(nonatomic, readonly) UIScrollView *scrollView;
@property(nonatomic, readonly, strong) IFATableViewController *selectedViewController;
@property(nonatomic) NSUInteger childViewDidAppearCount;
@property(nonatomic) NSUInteger newChildViewControllerCount;

- (void)refreshAndReloadChildData;

- (void)updateContentLayout;

- (void)updateContentLayoutWithAnimation:(BOOL)a_animated;

@end