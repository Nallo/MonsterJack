//
//  AppDelegate.h
//  MonsterJack
//
//  Created by stefano on 26/11/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GameManager *gameManager;

@end
