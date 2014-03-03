//
//  MonsterJaktMobView.m
//  ColorTracker
//
//  Created by zhiquan_osx9 on 29/11/13.
//  Copyright (c) 2013 Zhiquan. All rights reserved.
//

#import "MonsterJaktMobView.h"

@implementation MonsterJaktMobView

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
    }
    return self;
}

@end
