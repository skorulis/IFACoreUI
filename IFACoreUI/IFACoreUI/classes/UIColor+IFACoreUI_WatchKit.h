//
// Created by Marcelo Schroeder on 23/07/15.
// Copyright (c) 2015 InfoAccent Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (IFACoreUI_WatchKit)

/**
* Based on Guide_ButtonTable_Rows_Colors.psd from the guides available at https://developer.apple.com/watch/human-interface-guidelines/resources/
* returns WatchKit's default body text colour.
*/
+ (UIColor *)watchKitBodyTextColour;

/**
* Based on Guide_ButtonTable_Rows_Colors.psd from the guides available at https://developer.apple.com/watch/human-interface-guidelines/resources/
* returns WatchKit's default footnote text colour.
*/
+ (UIColor *)watchKitFootnoteTextColour;

/**
* Based on Guide_ButtonTable_Rows_Colors.psd from the guides available at https://developer.apple.com/watch/human-interface-guidelines/resources/
* returns WatchKit's default group background colour in full.
*/
+ (UIColor *)watchKitPlatterColourFull;

/**
* Based on Guide_ButtonTable_Rows_Colors.psd from the guides available at https://developer.apple.com/watch/human-interface-guidelines/resources/
* returns WatchKit's default table row content group background colour.
*/
+ (UIColor *)watchKitPlatterColour;

/**
* Based on Guide_ButtonTable_Rows_Colors.psd from the guides available at https://developer.apple.com/watch/human-interface-guidelines/resources/
* returns WatchKit's default group background colour.
*/
+ (UIColor *)watchKitSmallPlatterColour;

@end