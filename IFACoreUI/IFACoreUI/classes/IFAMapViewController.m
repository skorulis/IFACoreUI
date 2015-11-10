//
// Created by Marcelo Schroeder on 8/09/2014.
// Copyright (c) 2014 InfoAccent Pty Ltd. All rights reserved.
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

@interface IFAMapViewController ()
@property(nonatomic, strong) UIBarButtonItem *userLocationBarButtonItem;
@property(nonatomic, strong) UIBarButtonItem *mapSettingsBarButtonItem;
@property(nonatomic, strong) IFAWorkInProgressModalViewManager *IFA_progressViewManager;
@property(nonatomic) BOOL IFA_initialUserLocationRequestCompleted;
@property(nonatomic) BOOL IFA_userLocationRequested;
@property(nonatomic, strong) void (^IFA_userLocationRequestCompletionBlock)(BOOL a_success);
@property (nonatomic) IFACurrentLocationManager *currentLocationManager;
@end

@implementation IFAMapViewController {

}

#pragma mark - Public

- (UIBarButtonItem *)userLocationBarButtonItem {
    if (!_userLocationBarButtonItem) {
        _userLocationBarButtonItem = [IFAUIUtils barButtonItemForType:IFABarButtonItemTypeUserLocation
                                                               target:self
                                                               action:@selector(IFA_onUserLocationButtonTap:)];
    }
    return _userLocationBarButtonItem;
}

- (UIBarButtonItem *)mapSettingsBarButtonItem {
    if (!_mapSettingsBarButtonItem) {
        _mapSettingsBarButtonItem = [IFAUIUtils barButtonItemForType:IFABarButtonItemTypeInfo target:self
                                                              action:@selector(IFA_onMapSettingsButtonTap:)];
    }
    return _mapSettingsBarButtonItem;
}

- (void)locateUserDueToUserRequest:(BOOL)a_userInitiated
                   completionBlock:(void (^)(BOOL a_success))a_completionBlock {

    if (self.IFA_userLocationRequested) {
        // A request is in progress - bail out.
        return;
    }

    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];

    if (self.preventsLocatingUserAutomaticallyIfNotAuthorised
            && !a_userInitiated
            && authorizationStatus != kCLAuthorizationStatusAuthorizedWhenInUse
            && authorizationStatus != kCLAuthorizationStatusAuthorizedAlways) {
        if (a_completionBlock) {
            a_completionBlock(NO);
        }
        return;
    }
    
    if (self.mapView.userLocation.location) {
        self.IFA_userLocationRequestCompletionBlock = nil;
        if (a_completionBlock) {
            a_completionBlock(YES);
        }
    } else {
        self.IFA_userLocationRequestCompletionBlock = a_completionBlock;
        if (authorizationStatus == kCLAuthorizationStatusNotDetermined) {
            void (^currentLocationBasedBlock)(CLAuthorizationStatus) = ^(CLAuthorizationStatus status) {
                // Does nothing as the status change is being handled somewhere else
            };
            [self.currentLocationManager withAuthorizationType:self.locationAuthorizationType
                              executeCurrentLocationBasedBlock:currentLocationBasedBlock];
        } else {
            self.IFA_userLocationRequested = YES;
            [self.IFA_progressViewManager showViewWithMessage:NSLocalizedStringFromTable(@"Locating...", @"IFALocalizable", nil)];
            self.mapView.showsUserLocation = YES;
        }
    }

}

#pragma mark - Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated{

    if (!self.ifa_isReturningVisibleViewController) {
        [self locateUserDueToUserRequest:NO
                         completionBlock:nil];
    }

    [super viewDidAppear:animated];

}

- (NSArray *)ifa_nonEditModeToolbarItems {
    UIBarButtonItem *l_flexibleSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                                  target:nil
                                                                                                  action:nil];
    return @[self.userLocationBarButtonItem, l_flexibleSpaceBarButtonItem, self.mapSettingsBarButtonItem];
}

- (void)ifa_onApplicationDidBecomeActiveNotification:(NSNotification *)aNotification {
    [super ifa_onApplicationDidBecomeActiveNotification:aNotification];
    if (self.ifa_isVisibleTopChildViewController) {
        // Give a chance for the app to locate the user in case privacy settings have been changed while the app was in the background
        [self locateUserDueToUserRequest:NO
                         completionBlock:nil];
    }
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    NSLog(@" ");
//    NSLog(@"didUpdateUserLocation");
//    NSLog(@" ");

    if (self.IFA_userLocationRequested) {
        [self IFA_handleUserLocationRequestedCompletionWithSuccess:YES];
    }
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    NSLog(@" ");
    NSLog(@"didFailToLocateUserWithError - error code: %ld", (long)[error code]);
    NSLog(@" ");

    if (self.IFA_userLocationRequested) {
        [IFALocationManager handleLocationFailureWithAlertPresenterViewController:self];
        [self IFA_handleUserLocationRequestedCompletionWithSuccess:NO];
    }
}

#pragma mark - Private

- (void)IFA_onUserLocationButtonTap:(UIBarButtonItem *)a_barButtonItem {
    void (^completionBlock)(BOOL) = ^(BOOL a_success) {
        if (a_success) {
            [self.mapView showAnnotations:@[self.mapView.userLocation]
                                 animated:YES];
            if ([self.mapViewControllerDelegate respondsToSelector:@selector(mapViewControllerDidCompleteUserRequestToShowCurrentLocation:)]) {
                [self.mapViewControllerDelegate mapViewControllerDidCompleteUserRequestToShowCurrentLocation:self];
            }
        }
    };
    [self locateUserDueToUserRequest:YES
                     completionBlock:completionBlock];
}

- (void)IFA_onMapSettingsButtonTap:(UIBarButtonItem *)a_barButtonItem {
    IFAMapSettingsViewController *l_mapSettingsViewController = [IFAMapSettingsViewController ifa_instantiateFromStoryboardInBundle:[NSBundle bundleForClass:IFAMapSettingsViewController.class]];
    l_mapSettingsViewController.mapView = self.mapView;
    [self ifa_presentModalSelectionViewController:l_mapSettingsViewController
                                fromBarButtonItem:a_barButtonItem];
}

-(void)IFA_hideProgressView {
    // Remove modal WIP view
    [self.IFA_progressViewManager hideView];
}

- (IFAWorkInProgressModalViewManager *)IFA_progressViewManager {
    if (!_IFA_progressViewManager) {
        _IFA_progressViewManager = [IFAWorkInProgressModalViewManager new];
        __weak __typeof(self) weakSelf = self;
        _IFA_progressViewManager.cancellationCompletionBlock = ^{
            [weakSelf IFA_onUserLocationProgressViewCancelled];
        };
    }
    return _IFA_progressViewManager;
}

- (void)IFA_onUserLocationProgressViewCancelled {
    [self IFA_handleUserLocationRequestedCompletionWithSuccess:NO];
}

- (void)IFA_handleUserLocationRequestedCompletionWithSuccess:(BOOL)a_success {
    if (!a_success) {
        self.mapView.showsUserLocation = NO;
    }
    [self IFA_hideProgressView];
    self.IFA_userLocationRequested = NO;
    if (self.IFA_userLocationRequestCompletionBlock) {
        self.IFA_userLocationRequestCompletionBlock(a_success);
    }
    if (!self.IFA_initialUserLocationRequestCompleted) {
        if ([self.mapViewControllerDelegate respondsToSelector:@selector(mapViewController:didCompleteInitialUserLocationRequestWithSuccess:)]) {
            [self.mapViewControllerDelegate mapViewController:self
             didCompleteInitialUserLocationRequestWithSuccess:a_success];
        }
        self.IFA_initialUserLocationRequestCompleted = YES;
    }
}

- (IFACurrentLocationManager *)currentLocationManager {
    if (!_currentLocationManager) {
        _currentLocationManager = [IFACurrentLocationManager new];
    }
    return _currentLocationManager;
}

@end