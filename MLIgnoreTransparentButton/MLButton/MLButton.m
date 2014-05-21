//
//  MLButton.m
//  GCDTemp
//
//  Created by molon on 5/21/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "MLButton.h"
#import "UIView+ColorPointAndMask.h"

@implementation MLButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL result = [super pointInside:point withEvent:event];
    if (!self.isIgnoreTouchInTransparentPoint) {
        return result;
    }
    
    if (result) {
        return ![self isTansparentOfPoint:point];
    }
    return NO;
}

@end
