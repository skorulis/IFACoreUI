//
// Created by Marcelo Schroeder on 23/07/15.
// Copyright (c) 2015 InfoAccent Pty Ltd. All rights reserved.
//

#import "IFACoreUI.h"


@implementation UIColor (IFACoreUI_WatchKit)

+ (UIColor *)watchKitBodyTextColour {
    return [UIColor ifa_colorWithRed:255
                               green:255
                                blue:255];
}

+ (UIColor *)watchKitFootnoteTextColour {
    return [UIColor ifa_colorWithRed:174
                               green:180
                                blue:191];
}

+ (UIColor *)watchKitPlatterColourFull {
    return [UIColor ifa_colorWithRed:242
                               green:244
                                blue:252];
}

+ (UIColor *)watchKitPlatterColour {
    return [[self watchKitPlatterColourFull] colorWithAlphaComponent:0.14];
}

+ (UIColor *)watchKitSmallPlatterColour {
    return [[self watchKitPlatterColourFull] colorWithAlphaComponent:0.20];
}

@end