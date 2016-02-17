//
//  DemoContentVC.m
//  InteractiveTransitionDemo
//
//  Created by Jerry on 16/2/3.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "DemoContentVC.h"

@interface DemoContentVC ()

@end

@implementation DemoContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.navigationController.tabBarItem.title;
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    imgView.frame = self.view.bounds;
    [self.view addSubview:imgView];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.center = self.view.center;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.text = @"Fill In With Content";
    [self.view addSubview:contentLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
