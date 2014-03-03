//
//  Monster.h
//  MonsterJack
//
//  Created by stefano on 29/11/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Monster : NSObject

- (id)initWithName:(NSString *)aString identifier:(NSUInteger)anIdentifier expPoint:(NSUInteger)exp colorName:(NSString*)aColor groupMembers:(NSUInteger)members;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSUInteger identifier;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) NSUInteger expPoint;
@property (nonatomic, getter = isCatched) BOOL catched;
@property (nonatomic, strong) NSString *colorName;
@property (nonatomic) NSUInteger groupMembers;

typedef struct color{

CGFloat redComponent;
CGFloat greenComponent;
CGFloat blueComponent;

}color_t;



@end
