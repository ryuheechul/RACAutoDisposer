//
//  HCViewController.m
//  RACAutoDisposer
//
//  Created by Ryu Heechul on 07/20/2014.
//  Copyright (c) 2014 Ryu Heechul. All rights reserved.
//

#import "HCViewController.h"

@interface HCViewController () <RACAutoDisposerProtocol>

@property (nonatomic, strong) NSString *subscribedString;

@end

@implementation HCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    for (NSInteger i=0; i<10; i++) {
        [self leaveToomanySubscriptions];
        [self onlyOneSubscriptionSurvive];
    }

    self.subscribedString = @"string changed";
}

- (void)leaveToomanySubscriptions
{
    [[RACObserve(self, subscribedString) skip:1]
     subscribeNext:^(id x) {
         NSLog(@"[TOO MANY] %@", x);
     }];
}

- (void)onlyOneSubscriptionSurvive
{
    @RACAutoDispose(@"subscribedString", {
        [[RACObserve(self, subscribedString) skip:1]
         subscribeNext:^(id x) {
             NSLog(@"[ONLY ONE] %@", x);
         }];
    })
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
