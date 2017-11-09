//
//  ViewController.m
//  ARRANGE
//
//  Created by Test on 21/02/2015.
//  Copyright (c) 2015 Test. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize IbifindStatus   ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //IbifindStatus.text = @"text";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dataFromController:(NSString *)data {
    
    NSLog(@"delegate function being executed");
    IbifindStatus.text = data;
}
@end
