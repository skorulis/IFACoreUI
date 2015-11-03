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

@interface IFAUIConfiguration ()
@property (nonatomic) BOOL useDeviceAgnosticMainStoryboard;
@property (nonatomic, strong) id<IFAAppearanceTheme> IFA_appearanceTheme;
@end

@implementation IFAUIConfiguration {

}

#pragma mark - Public

- (BOOL)useDeviceAgnosticMainStoryboard {
    return self.useDeviceAgnosticMainStoryboard = [[IFAUtils infoPList][@"IFAUseDeviceAgnosticMainStoryboard"] boolValue];
}

-(Class)appearanceThemeClass {
    if ([self.dataSource respondsToSelector:@selector(appearanceThemeClass)]) {
        return self.dataSource.appearanceThemeClass;
    } else {
        Class appAppearanceThemeClass = NSClassFromString(@"IFAAppDefaultAppearanceTheme");
        return appAppearanceThemeClass?:[IFADefaultAppearanceTheme class];
    }
}

-(IFAColorScheme *)colorScheme {
    if ([self.dataSource respondsToSelector:@selector(colorScheme)]) {
        return self.dataSource.colorScheme;
    } else {
        return nil;
    }
}

-(id<IFAAppearanceTheme>)appearanceTheme {
    if ([self.dataSource respondsToSelector:@selector(appearanceTheme)]) {
        return self.dataSource.appearanceTheme;
    } else {
        Class l_appearanceThemeClass = [self appearanceThemeClass];
        if (!self.IFA_appearanceTheme || ![self.IFA_appearanceTheme isMemberOfClass:l_appearanceThemeClass]) {
            self.IFA_appearanceTheme = (id <IFAAppearanceTheme>) [l_appearanceThemeClass new];
        }
        return self.IFA_appearanceTheme;
    }
}

// Note on device specific storyboards:
// The "~" (tilde) as a device modifier works for the initial load, but it has issues when view controllers attempt to access
//  the storyboard via self.storyboard. For some reason the device modifier is not taken into consideration in those cases
// By loading the storyboard using the device modifier explicitly in the name avoids any problems.
-(NSString*)storyboardName {
    if ([self.dataSource respondsToSelector:@selector(storyboardName)]) {
        return self.dataSource.storyboardName;
    } else {
        return [NSString stringWithFormat:@"%@%@", [self storyboardFileName],
                                          [IFAUIConfiguration sharedInstance].useDeviceAgnosticMainStoryboard ? @"" : [IFAUIUtils resourceNameDeviceModifier]];
    }
}

- (NSString *)storyboardFileName {
    if ([self.dataSource respondsToSelector:@selector(storyboardFileName)]) {
        return self.dataSource.storyboardFileName;
    } else {
        return @"MainStoryboard";
    }
}

-(NSString*)storyboardInitialViewControllerId {
    if ([self.dataSource respondsToSelector:@selector(storyboardInitialViewControllerId)]) {
        return self.dataSource.storyboardInitialViewControllerId;
    } else {
        return [NSString stringWithFormat:@"%@InitialController", [IFAUIUtils isIPad]?@"ipad":@"iphone"];
    }
}

-(UIStoryboard*)storyboard {
    if ([self.dataSource respondsToSelector:@selector(storyboard)]) {
        return self.dataSource.storyboard;
    } else {
        return [UIStoryboard storyboardWithName:[self storyboardName] bundle:nil];
    }
}

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
-(UIViewController*)initialViewController {
    UIViewController *initialViewController;
    if ([self.dataSource respondsToSelector:@selector(initialViewController)]) {
        initialViewController= self.dataSource.initialViewController;
    } else {
        UIStoryboard *l_storyboard = [self storyboard];
        NSString *l_storyboardInitialViewControllerId = [self storyboardInitialViewControllerId];
        if (l_storyboardInitialViewControllerId) {
            initialViewController = [l_storyboard instantiateViewControllerWithIdentifier:l_storyboardInitialViewControllerId];
        }
        if (!initialViewController) {
            initialViewController = [l_storyboard instantiateInitialViewController];
        }
    }
    if ([self.delegate respondsToSelector:@selector(uiConfiguration:didDetermineInitialViewController:)]) {
        [self.delegate uiConfiguration:self
     didDetermineInitialViewController:initialViewController];
    }
    return initialViewController;
}
#pragma clang diagnostic pop

+ (instancetype)sharedInstance {
    static dispatch_once_t c_dispatchOncePredicate;
    static id c_instance = nil;
    dispatch_once(&c_dispatchOncePredicate, ^{
        c_instance = [self new];
    });
    return c_instance;
}

@end