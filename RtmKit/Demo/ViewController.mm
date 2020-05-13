//
//  ViewController.m
//  Demo
//
//  Created by clf on 2020/5/13.
//  Copyright © 2020 haoqi. All rights reserved.
//

#import "ViewController.h"
#include <AgoraRtmKit/AgoraRtmKit.h>
#include <AgoraRtmKit/IAgoraRtmService.h>

//@import AgoraRtmKit



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    agora::rtm::IRtmService * service = agora::rtm::createRtmService();
    
    
}


@end
