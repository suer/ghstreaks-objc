//
//  Preference.m
//  GHStreaks
//
//  Created by suer on 2014/02/02.
//  Copyright (c) 2014年 codefirst.org. All rights reserved.
//

#import "Preference.h"

@implementation Preference

- (id)init
{
    if (self = [super init]) {
        NSBundle* bundle = [NSBundle mainBundle];
        NSString* path = [bundle pathForResource:@"preference" ofType:@"plist"];
        NSDictionary* root = [NSDictionary dictionaryWithContentsOfFile:path];
        self.serviceURL =[root objectForKey:@"ServiceURL"];
    }
    return self;
}
@end
