//
//  ViewController.m
//  MLIgnoreTransparentButton
//
//  Created by molon on 5/21/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "ViewController.h"
#import "MLButton.h"
#import "UIView+ColorPointAndMask.h"

@interface ViewController ()

@property (nonatomic, strong) MLButton *button;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    MLButton *button1 = [MLButton buttonWithType:UIButtonTypeCustom];
    button1.isIgnoreTouchInTransparentPoint = YES;
    button1.backgroundColor = [UIColor clearColor];
    [button1 setImage:[UIImage imageNamed:@"test1"] forState:UIControlStateNormal];
    button1.imageView.contentMode = UIViewContentModeScaleToFill;
    [button1 addTarget:self action:@selector(button1Pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    button1.frame = CGRectMake(30, 100, 100, 100);
    
    
    MLButton *button2 = [MLButton buttonWithType:UIButtonTypeCustom];
    button2.isIgnoreTouchInTransparentPoint = YES;
    button2.backgroundColor = [UIColor clearColor];
    [button2 setImage:[UIImage imageNamed:@"test2"] forState:UIControlStateNormal];
    button2.imageView.contentMode = UIViewContentModeScaleToFill;
    [button2 addTarget:self action:@selector(button2Pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    button2.frame = CGRectMake(30, 98, 100, 100);
    
    
    MLButton *button3 = [MLButton buttonWithType:UIButtonTypeCustom];
    button3.isIgnoreTouchInTransparentPoint = YES;
    button3.backgroundColor = [UIColor clearColor];
    [button3 setImage:[UIImage imageNamed:@"car.jpg"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(button3Pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    button3.frame = CGRectMake(30, 250, 200, 200);
    
    button3.imageView.contentMode = UIViewContentModeScaleAspectFill;
    //设置mask背景
    [button3 setMaskWithImage:[[UIImage imageNamed:@"mask"]resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 10, 18)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)button1Pressed
{
    NSLog(@"button1Pressed");
}

- (void)button2Pressed
{
    NSLog(@"button2Pressed");
}

- (void)button3Pressed
{
    NSLog(@"button3Pressed");
}
@end
