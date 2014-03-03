//
//  GroupHuntingActionVC.h
//  MonsterJack
//
//  Created by stefano on 13/12/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>

#import "MonsterFocusSquare.h"
#import "Monster.h"
#import "GameManager.h"

@interface GroupHuntingActionVC : UIViewController <GPUImageVideoCameraDelegate, UICollisionBehaviorDelegate>
{
    GPUImageVideoCamera *videoCamera;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageAverageColor *positionAverageColor;
    GPUImageView *avgColorBox;
    
}
-(void)setupCamera;

@property (strong, nonatomic) GameManager *gameManager;
@property (nonatomic, strong) IBOutlet UILabel *dValues;

@property (strong, nonatomic) MonsterFocusSquare *mobFocusSq;

@property (nonatomic, strong) IBOutlet UIImageView *monsterBox;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIPushBehavior *p;
@property (strong, nonatomic) UICollisionBehavior *c;

@property (nonatomic, strong) IBOutlet UIImageView *monsterBox2;
@property (strong, nonatomic) UIDynamicAnimator *animator2;
@property (strong, nonatomic) UIPushBehavior *p2;
@property (strong, nonatomic) UICollisionBehavior *c2;

@end
