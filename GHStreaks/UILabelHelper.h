//
//  UILabelHelper.h
//  GHStreaks
//
//  Created by suer on 2014/02/12.
//  Copyright (c) 2014年 codefirst.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabelHelper : NSObject

+ (UILabel *)createUILabel:(int)pointX pointY:(int)pointY width:(int)width height:(int)height text:(NSString *)text;

+ (UILabel *)createUILabel:(int)pointX pointY:(int)pointY  width:(int)width height:(int)height fontSize:(int)fontSize text:(NSString *)text;

@end
