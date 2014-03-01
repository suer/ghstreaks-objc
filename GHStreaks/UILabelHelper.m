//
//  UILabelHelper.m
//  GHStreaks
//
//  Created by suer on 2014/02/12.
//  Copyright (c) 2014年 codefirst.org. All rights reserved.
//

#import "UILabelHelper.h"

@implementation UILabelHelper

+ (UILabel *)createUILabel:(int)pointX pointY:(int)pointY width:(int)width height:(int)height text:(NSString *)text
{
    UILabel *uiLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointX, pointY, width, height)];
    uiLabel.textAlignment = NSTextAlignmentCenter;
    uiLabel.text = text;
    uiLabel.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    return uiLabel;
}

+ (UILabel *)createUILabel:(int)pointX pointY:(int)pointY width:(int)width height:(int)height fontSize:(int)fontSize text:(NSString *)text
{
    UILabel *uiLabel = [self createUILabel:pointX pointY:pointY width:width height:height text:text];
    uiLabel.font = [UIFont systemFontOfSize:fontSize];
    return uiLabel;
}

@end
