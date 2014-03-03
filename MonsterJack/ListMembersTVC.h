//
//  ListMembersTVC.h
//  MonsterJack
//
//  Created by stefano on 12/12/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "OvalView.h"

@class GameManager;

@interface ListMembersTVC : UITableViewController <CLLocationManagerDelegate>

@property (nonatomic) NSUInteger numberOfMembers;
@property (nonatomic) NSUInteger expPoints;
@property (nonatomic, strong) NSString *playerName;

@property (strong, nonatomic) IBOutlet OvalView *growAnimation;
@property (strong, nonatomic) GameManager *gameManager;

@end
