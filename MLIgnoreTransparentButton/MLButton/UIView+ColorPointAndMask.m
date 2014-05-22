//
//  UIView+ColorPointAndMask.m
//  GCDTemp
//
//  Created by molon on 5/20/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "UIView+ColorPointAndMask.h"
#import "ObjcRuntime.h"


NSString * const kIsUseSetMaskWithImageKey = @"MLCALayer__SetMaskWithImage__isUseSetMaskWithImage";


@interface CALayer (SetMaskWithImage)

//给CALayer添加个标识是否使用UIView的SetMaskWithImage功能设置的mask
@property (nonatomic,strong) NSNumber *isUseSetMaskWithImage;

@end

@implementation CALayer (SetMaskWithImage)

#pragma mark -  add isUseSetMaskWithImage property
- (void)setIsUseSetMaskWithImage:(NSNumber*)isUseSetMaskWithImage
{
    [self willChangeValueForKey:kIsUseSetMaskWithImageKey];
	objc_setAssociatedObject(self, &kIsUseSetMaskWithImageKey, isUseSetMaskWithImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kIsUseSetMaskWithImageKey];
}

- (NSNumber*)isUseSetMaskWithImage
{
	return objc_getAssociatedObject(self, &kIsUseSetMaskWithImageKey);
}

#pragma mark - hook setMask
- (void)setMask__hook:(CALayer *)mask
{
    [self setMask__hook:mask];
    
    self.isUseSetMaskWithImage = @(NO);
}

@end


@implementation UIView (ColorPointAndMask)

#pragma mark - mask

inline static CGRect CGRectCenterRectForResizableImage(UIImage *image) {
    return CGRectMake(image.capInsets.left/image.size.width, image.capInsets.top/image.size.height, (image.size.width-image.capInsets.right-image.capInsets.left)/image.size.width, (image.size.height-image.capInsets.bottom-image.capInsets.top)/image.size.height);
}

- (void)setMaskWithImage:(UIImage*)image
{
    //需要先hook view的setFrame:,用来能同步设置mask的frame
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //这个在整个app的生命周期，只需要替换一次。
        Swizzle([UIView class], NSSelectorFromString(@"setFrame:"), @selector(setFrame__hook:));
        Swizzle([CALayer class], NSSelectorFromString(@"setMask:"), @selector(setMask__hook:));
    });
    
    //根据
    CALayer *mask = [CALayer layer];
    mask.contents = (id)image.CGImage;
    mask.contentsScale = [UIScreen mainScreen].scale;
    
    //设置拉伸属性，根据capInsets，找到可拉伸的矩形
    CGRect capRect = CGRectCenterRectForResizableImage(image);
    
    mask.contentsCenter = capRect;
    mask.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.layer.mask = mask;
    
    self.layer.isUseSetMaskWithImage = @(YES);
}

- (void)setFrame__hook:(CGRect)frame
{
    [self setFrame__hook:frame];
    
    //这里只有当前对象使用过setMaskWithImage方法后才会同步修正mask的frame，否则不修正
    //没办法，因为用了objcruntime，所以需要尽量的去防止意外情况。
    if(self.layer.mask&&self.layer.isUseSetMaskWithImage&&[self.layer.isUseSetMaskWithImage boolValue]){
        self.layer.mask.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
}

#pragma mark - color and isTansparent of point

- (void)RGBA:(unsigned char[4])pixel ofPoint:(CGPoint)point
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
}

- (UIColor *)colorOfPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    
    [self RGBA:pixel ofPoint:point];
    
    UIColor *color = nil;
    if (pixel[0]==0&&pixel[1]==0&&pixel[2]==0&&pixel[3]==0) {
        color = [UIColor clearColor];
    }else{
        color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    }
    return color;
}

- (BOOL)isTansparentOfPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    
    //为什么这里不使用kCGImageAlphaOnly，因为我发现它得到的结果是不经过layer.mask处理的
    //所以不可取，还是获取RGBA吧
    [self RGBA:pixel ofPoint:point];
    
    //    NSLog(@"pixel: %d %d %d %d", pixel[0], pixel[1], pixel[2], pixel[3]);
    
    //这里认为只要alpha值为0就是透明。和clearColor还是有区别的
    return pixel[3]==0;
}

@end
