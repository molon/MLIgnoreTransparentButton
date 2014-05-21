//
//  ViewController.m
//  MLIgnoreTransparentButton
//
//  Created by molon on 5/21/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "ViewController.h"
#import "MLButton.h"

@interface ViewController ()

@property (nonatomic, strong) MLButton *button;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MLButton *)button
{
	if (!_button) {
		MLButton *button = [[MLButton alloc]init];
        button 
	}
	return _button;
}

@end
