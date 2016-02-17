//
//  AppDelegate.m
//  InteractiveTransitionDemo
//
//  Created by Jerry on 16/2/3.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "AppDelegate.h"
#import "ITunesTabViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIColor *themeColor = [UIColor redColor];
    UINavigationBar * barAppearance = [UINavigationBar appearance];
    [barAppearance setTintColor:themeColor];
    UITabBar *tabAppearance = [UITabBar appearance];
    [tabAppearance setTintColor:themeColor];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [ITunesTabViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
