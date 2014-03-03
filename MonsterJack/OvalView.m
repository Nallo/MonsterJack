//
//  OvalView.m
//  MonsterJack
//
//  Created by stefano on 13/12/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import "OvalView.h"

@implementation OvalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    self.backgroundColor = [UIColor clearColor];
    self.color = [UIColor clearColor];
    self.borderThickness = 0.5;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Slightly inset rect for drawing
    
    CGRect ovalRect = CGRectInset(self.bounds, 2, 2);
    // Create an oval shape to draw.
    UIBezierPath* aPath = [UIBezierPath bezierPathWithOvalInRect:ovalRect];;
    
    // Set the render colors
    [[UIColor blackColor] setStroke];
    [self.color setFill];
    
    
    // Adjust the drawing options as needed.
    aPath.lineWidth = self.borderThickness;
    
    // Fill the path before stroking it so that the fill
    // color does not obscure the stroked line.
    [aPath fill];
    [aPath stroke];
    
}

@end
