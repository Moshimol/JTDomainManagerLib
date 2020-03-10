//
//  JTViewController.m
//  JTDomainManagerLib
//
//  Created by lushitong on 03/10/2020.
//  Copyright (c) 2020 lushitong. All rights reserved.
//

#import "JTViewController.h"
#import "JTEnvironmentSingle.h"

@interface JTViewController ()

@end

@implementation JTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [JTEnvironmentSingle sharedInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
