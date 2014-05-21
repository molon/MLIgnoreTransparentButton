//
//  UIView+ColorPointAndMask.h
//  GCDTemp
//
//  Created by molon on 5/20/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ColorPointAndMask)

/**
 *  当前对应的点的颜色值
 */
- (UIColor *)colorOfPoint:(CGPoint)point;

/**
 *  当前对应的点是否是透明的
 */
- (BOOL)isTansparentOfPoint:(CGPoint)point;

/**
 *  设置mask图像，mask.frame自动矫正为self.frame
 */
- (void)setMaskWithImage:(UIImage*)image;

@end
