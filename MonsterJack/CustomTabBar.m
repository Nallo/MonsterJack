//
//  CustomTabBar.m
//  MonsterJack
//
//  Created by stefano on 16/12/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import "CustomTabBar.h"

@interface CustomTabBar ()

@end

@implementation CustomTabBar

@synthesize tabBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
	// Do any additional setup after loading the view.
}

-(void)initialize
{
    tabBar.backgroundColor = [UIColor clearColor];
    CGRect frame = CGRectMake(0, 0, 480, 49);
    UIView *v = [[UIView alloc] initWithFrame:frame];
    //UIImage *i = [UIImage imageNamed:@"game_bg"];
    //UIColor *c = [[UIColor alloc] initWithPatternImage:i];
    UIColor *c = [[UIColor alloc] initWithRed:0.47 green:0.64 blue:0.3 alpha:0.5];
    v.backgroundColor = c;
    [[self tabBar] insertSubview:v atIndex:0];
}

@end
