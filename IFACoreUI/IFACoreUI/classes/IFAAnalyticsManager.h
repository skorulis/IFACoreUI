//
// Created by Marcelo Schroeder on 20/08/15.
// Copyright (c) 2015 InfoAccent Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IFAAnalyticsManagerDelegate;

/**
* This class manages analytics events.
*/
@interface IFAAnalyticsManager : NSObject
@property (nonatomic, weak) id<IFAAnalyticsManagerDelegate> delegate;

/**
* Call to notify the analytics manager that a given view controller's viewDidAppear method has been called.
* @param viewController View controller whose viewDidAppear method has been called.
*/
- (void)notifyViewDidAppearEventForViewController:(UIViewController *)viewController;

+ (instancetype)sharedInstance;
@end

@protocol IFAAnalyticsManagerDelegate <NSObject>

@optional

/**
* Delegate callback to inform that a given view controller's viewDidAppear method has been called.
* This callback can be used to log the relevant analytics event such as content being viewed.
* @param analyticsManager The sender.
* @param viewController View controller whose viewDidAppear method has been called.
*/
- (void)analyticsManager:(IFAAnalyticsManager *)analyticsManager didReceiveViewDidAppearEventForViewController:(UIViewController *)viewController;

@end