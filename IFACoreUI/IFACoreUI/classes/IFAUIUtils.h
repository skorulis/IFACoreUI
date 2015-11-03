//
//  IFAUIUtils.h
//  Gusty
//
//  Created by Marcelo Schroeder on 17/06/10.
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

#import "IFAHudView.h"
#import "IFACoreUiConstants.h"

@class NSManagedObject;

// Size limit for UIWebView to be able to display images in iOS 7 and above.
// 5Mb seems to be limit for UIWebView to be able to display images in iOS 7 (i.e. no devices have less than 256Mb of RAM)
// Based on the "Know iOS Resource Limits" section at https://developer.apple.com/library/safari/documentation/AppleApplications/Reference/SafariWebContent/CreatingContentforSafarioniPhone/CreatingContentforSafarioniPhone.html
// JPEG's have a higher limit, but I have not taken that into consideration yet.
static const CGFloat IFAMaximumImageSizeInPixels =  5 * 1024 * 1024;

@class IFAMenuViewController;
@class CLLocation;

@interface IFAUIUtils : NSObject {

}

+ (UIBarButtonItem*)barButtonItemForType:(IFABarButtonItemType)a_type target:(id)a_target action:(SEL)a_action;

+(BOOL)isDeviceInLandscapeOrientation;

+ (CGPoint)appFrameOrigin;
+ (CGSize)appFrameSize;
+ (CGRect)appFrame;

+ (CGRect)convertToCurrentOrientationForFrame:(CGRect)a_frame;

+ (CGPoint)screenBoundsOrigin;
+ (CGSize)screenBoundsSize;
+ (CGSize)screenBoundsSizeForCurrentOrientation;
+ (CGRect)screenBounds;

+ (NSString*)stringValueForObject:(id)anObject;
+ (NSString*)stringValueForBoolean:(BOOL)aBoolean;
+ (NSString*)onOffStringValueForBoolean:(BOOL)aBoolean;

/**
* Presents a user action confirmation message using an instance of the <IFAHudViewController>, and dismisses it after a short while.
* @param a_text Text message to by displayed by the HUD.
*/
+ (void)showAndHideUserActionConfirmationHudWithText:(NSString*)a_text;

+ (void)showAndHideUserActionConfirmationHudWithText:(NSString *)a_text
                                 visualIndicatorMode:(IFAHudViewVisualIndicatorMode)a_visualIndicatorMode
                                    autoDismissDelay:(NSTimeInterval)a_autoDismissDelay;

/**
* Presents a message confirming the user has toggled an app mode on or off.
* This method uses an instance of the <IFAHudViewController>, and dismisses it after a short while.
* @param a_text Text message to by displayed by the HUD. This should indicate the mode that has been switched on or off.
* @param a_on Indicates whether the mode has been switched on or off.
*/
+ (void)showAndHideModeToggleConfirmationHudWithText:(NSString*)a_text on:(BOOL)a_on;

+(void)traverseHierarchyForView:(UIView *)a_view withBlock:(void (^) (UIView*))a_block;

+(CGFloat)widthForPortraitNumerator:(float)a_portraitNumerator
                portraitDenominator:(float)a_portraitDenominator
                 landscapeNumerator:(float)a_landscapeNumerator
               landscapeDenominator:(float)a_landscapeDenominator;

+(BOOL)isIPad;
+(BOOL)isIPhoneLandscape;
+(NSString*)resourceNameDeviceModifier;
+(UIViewAutoresizing)fullAutoresizingMask;
+(NSString*)menuBarButtonItemImageName;
+(UIImage*)menuBarButtonItemImage;

//+(void)dismissSplitViewControllerPopover;

+(void)adjustImageInsetsForBarButtonItem:(UIBarButtonItem*)a_barButtonItem insetValue:(CGFloat)a_insetValue;

+(UIColor*)colorForInfoPlistKey:(NSString*)a_infoPlistKey;

+ (BOOL)isImageWithinSafeMemoryThresholdForSizeInPixels:(CGSize)a_imageSizeInPixels;

// mimic iOS default separator inset
+ (UIEdgeInsets)tableViewCellDefaultSeparatorInset;

/**
* Calculates height given width and aspect ratio.
* @param a_width Width to calculate height for.
* @param a_aspectRatio Aspect ratio (width divided by height)
*/
+ (CGFloat)heightForWidth:(CGFloat)a_width aspectRatio:(CGFloat)a_aspectRatio;

/**
* Calculates width given height and aspect ratio.
* @param a_height Height to calculate width for.
* @param a_aspectRatio Aspect ratio (width divided by height)
*/
+ (CGFloat)widthForHeight:(CGFloat)a_height aspectRatio:(CGFloat)a_aspectRatio;

+ (BOOL)isKeyboardVisible;
+ (CGRect)keyboardFrame;

+ (void) handleUnrecoverableError:(NSError *)anErrorContainer;
+ (NSError*) newErrorWithCode:(NSInteger)anErrorCode errorMessage:(NSString*)anErrorMessage;
+ (NSError*) newErrorContainer;
+ (NSError*) newErrorContainerWithError:(NSError*)anError;
+ (void) addError:(NSError*)anError toContainer:(NSError*)anErrorContainer;

/**
* @return Localised title for a "Save" button.
*/
+ (NSString *)saveButtonTitle;

/**
* @return Localised title for a "Cancel" button.
*/
+ (NSString *)cancelButtonTitle;

/**
* Open URL provided with the option to ask for user confirmation before leaving the host app.
* This method only works if GustyAppKit is also integrated, otherwise it throws an exception.
* @param a_url URL to be opened.
* @param a_alertPresenterViewController If provided, this view controller will present an alert asking the user whether it is ok to navigate to another app which will open the URL.
* @returns YES if the URL could be opened, otherwise NO.
*/
+ (BOOL)                 openUrl:(NSURL *)a_url
withAlertPresenterViewController:(UIViewController *)a_alertPresenterViewController;

/**
* Handle a deletion request for a managed object by a view controller.
* @param object The managed object to be deleted.
* @param alertPresentingViewController The view controller to be presenting any required alerts to the user.
* @param shouldAskForUserConfirmation If YES, it will get a confirmation from the user before deleting the object. If NO, it will attempt the deletion without asking for confirmation.
* @param shouldShowSuccessfulDeletionHudConfirmation If YES, it will show a HUD message confirming the deletion if it has been successful. If NO, it will not display the HUD message.
* @param willDeleteHandler Block to be executed just before the deletion. Return YES to go ahead with the deletion, or NO to abort.
* @param completionHandler Block to be executed after the deletion attempt has been performed. It returns YES to indicate success, or NO to indicate failure. When the failure is due to data validation, the appropriate alert will be automatically displayed.
*/
+ (void)handleDeletionRequestForManagedObject:(NSManagedObject *)object
            withAlertPresentingViewController:(UIViewController *)alertPresentingViewController
                 shouldAskForUserConfirmation:(BOOL)shouldAskForUserConfirmation
  shouldShowSuccessfulDeletionHudConfirmation:(BOOL)shouldShowSuccessfulDeletionHudConfirmation
                            willDeleteHandler:(BOOL (^)(NSManagedObject *objectAboutToBeDeleted))willDeleteHandler
                            completionHandler:(void (^)(BOOL success))completionHandler;

/**
* Presents an instance of UIAlertController according to the specifications provided.
* @param a_title The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
* @param a_message Descriptive text that provides additional details about the reason for the alert.
* @param a_style The style to use when presenting the alert controller. Use this parameter to configure the alert controller as an action sheet or as a modal alert.
* @param a_actions An array of UIAlertAction instances.
* @param a_animated Pass YES to animate the presentation; otherwise, pass NO.
* @param a_presenter The view controller doing the presentation. Pass nil for a global top level presentation, in which case, a temporary top level window and view controller are specifically created for this purpose and disposed of when the alert is dismissed by the user.
* @param a_completion A completion block to be executed after the view transition has been completed.
*/
+ (void)presentAlertControllerWithTitle:(NSString *)a_title
                                message:(NSString *)a_message
                                  style:(UIAlertControllerStyle)a_style
                                actions:(NSArray *)a_actions
                               animated:(BOOL)a_animated
                              presenter:(UIViewController *)a_presenter
                             completion:(void (^)(void))a_completion;

/**
* Presents a top level instance of UIAlertController with default Continue button.
* @param a_title The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
* @param a_message Descriptive text that provides additional details about the reason for the alert.
*/
+ (void)presentAlertControllerWithTitle:(NSString *)a_title
                                message:(NSString *)a_message;

@end
