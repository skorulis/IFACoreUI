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

#import <Foundation/Foundation.h>

@protocol IFAUIConfigurationDataSource;
@protocol IFAUIConfigurationDelegate;

@interface IFAUIConfiguration : NSObject
@property (nonatomic, weak) id<IFAUIConfigurationDataSource> dataSource;
@property (nonatomic, weak) id<IFAUIConfigurationDelegate> delegate;
@property (nonatomic, readonly) BOOL useDeviceAgnosticMainStoryboard;
-(Class)appearanceThemeClass;
-(IFAColorScheme *)colorScheme;
-(id<IFAAppearanceTheme>)appearanceTheme;
-(NSString*)storyboardName;
- (NSString *)storyboardFileName;
-(NSString*)storyboardInitialViewControllerId;
-(UIStoryboard*)storyboard;
#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
-(UIViewController*)initialViewController;
#pragma clang diagnostic pop
+ (instancetype)sharedInstance;
@end

@protocol IFAUIConfigurationDataSource <NSObject>

@optional

-(Class)appearanceThemeClass;
-(IFAColorScheme *)colorScheme;
-(id<IFAAppearanceTheme>)appearanceTheme;
-(NSString*)storyboardName;
- (NSString *)storyboardFileName;
-(NSString*)storyboardInitialViewControllerId;
-(UIStoryboard*)storyboard;
-(UIViewController*)initialViewController;

@end

@protocol IFAUIConfigurationDelegate <NSObject>

@optional

/**
* This delegate callback allows for extra configuration of the initial view controller such as setting properties on it.
* @param uiConfiguration The sender.
* @param initialViewController The initial view controller as determined by the sender.
*/
- (void)          uiConfiguration:(IFAUIConfiguration *)uiConfiguration
didDetermineInitialViewController:(UIViewController *)initialViewController;

@end