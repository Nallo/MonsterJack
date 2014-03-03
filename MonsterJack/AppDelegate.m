//
//  AppDelegate.m
//  MonsterJack
//
//  Created by stefano on 26/11/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import "AppDelegate.h"

#import "GameManager.h"

#import "StatisticsStaticTVC.h"
#import "MonsterTVController.h"
#import "MonsterJaktViewController.h"
#import "GroupHuntingVC.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBarTintColor:[[UIColor alloc] initWithRed:0.39 green:0.61 blue:0.5 alpha:1]];
    [[UINavigationBar appearance] setTintColor:[[UIColor alloc] initWithRed:0.73 green:0.13 blue:0.15 alpha:1]];
    
    // create gameManager
    self.gameManager = [[GameManager alloc] init];
    
    // create TabBarController
    UITabBarController *TBC = (UITabBarController*)self.window.rootViewController;
        
    // create statisticsStaticVC and fill the properties
    UINavigationController *statNC = (UINavigationController *) [[TBC viewControllers] objectAtIndex:0];
    StatisticsStaticTVC *statVC = (StatisticsStaticTVC*)[[statNC viewControllers] objectAtIndex:0];
    statVC.gameManager = self.gameManager;
    
    // create MonsterTVController and fill the properties
    UINavigationController *monsterNC = (UINavigationController *) [[TBC viewControllers] objectAtIndex:1];
    MonsterTVController *monsterTCV = (MonsterTVController*)[[monsterNC viewControllers] objectAtIndex:0];
    monsterTCV.monsterCollection = [self.gameManager getMonsterCollection];
    
    // create capture viewController
    UINavigationController *captureVC = (UINavigationController *) [[TBC viewControllers] objectAtIndex:2];
    MonsterJaktViewController *mjVC = (MonsterJaktViewController*) [[captureVC viewControllers] objectAtIndex:0];
    mjVC.gameManager = self.gameManager;
    
    // create group hunting VC
    UINavigationController *groupHuntingNVC = (UINavigationController *) [[TBC viewControllers] objectAtIndex:3];
    GroupHuntingVC *ghVC = (GroupHuntingVC*) [[groupHuntingNVC viewControllers] objectAtIndex:0];
    ghVC.gameManager = self.gameManager;
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.gameManager saveData];
    NSLog(@"saveData");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self.gameManager loadUserData];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
