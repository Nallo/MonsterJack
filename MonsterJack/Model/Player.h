//
//  Player.h
//  MonsterJack
//
//  Created by stefano on 29/11/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

- (id)initWithName:(NSString *)aString experience:(NSUInteger)experience imagePath:(NSURL*)path;

@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSUInteger experience;
@property (nonatomic) NSURL *imagePath;

@end
