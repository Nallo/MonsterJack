//
//  Player.m
//  MonsterJack
//
//  Created by stefano on 29/11/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id)init
{
    return [self initWithName:@"" experience:0 imagePath:nil];
}

- (id)initWithName:(NSString *)aString experience:(NSUInteger)experience imagePath:(NSURL*)path;{
    self = [super init];
    
    if (self) {
    
        _name = [aString copy];
        _experience = experience;
        _imagePath = path;
    }
    return self;
}

@end
