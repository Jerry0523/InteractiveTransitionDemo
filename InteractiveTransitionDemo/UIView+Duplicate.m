//
//  UIView+Duplicate.m
//  InteractiveTransitionDemo
//
//  Created by Jerry on 16/2/3.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "UIView+Duplicate.h"

@implementation UIView (Duplicate)

- (UIView*)duplicate {
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

@end
