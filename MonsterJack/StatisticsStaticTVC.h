//
//  StatisticsStaticTVC.h
//  MonsterJack
//
//  Created by stefano on 06/12/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@class GameManager;

@interface StatisticsStaticTVC : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) GameManager *gameManager;

@end
