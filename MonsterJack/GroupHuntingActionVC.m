//
//  GroupHuntingActionVC.m
//  MonsterJack
//
//  Created by stefano on 13/12/13.
//  Copyright (c) 2013 stefano. All rights reserved.
//

#import "GroupHuntingActionVC.h"

#define Monster1 8
#define Monster2 7

@interface GroupHuntingActionVC ()
{
    struct{
        CGFloat red;
        CGFloat green;
        CGFloat blue;
    } trackValues;
    CGFloat col_threshold;
    BOOL isFocusing;
    //BOOL isCaptured;
    GPUImageView *filteredVideoView;
    UIButton *captureLabel;
    
}
@end

@implementation GroupHuntingActionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    col_threshold = 0.1;
    //isCaptured = NO;
    [self setupCamera];
}

-(void)setupDynamics
{
    if(_monsterBox){
        //setting up animator
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        
        //5
        //setting up push behaviour
        self.p = [[UIPushBehavior alloc] initWithItems:@[_monsterBox] mode:UIPushBehaviorModeInstantaneous];
        [self.p setPushDirection:CGVectorMake(-1.0, 1.0)];
        
        
        //6
        //setting up collision behavior and boundaries
        self.c = [[UICollisionBehavior alloc] initWithItems:@[_monsterBox]];
        [self.c addBoundaryWithIdentifier:@"bottomwall" fromPoint:CGPointMake(0, self.view.frame.size.height) toPoint:CGPointMake(self.view.frame.size.width, self.view.frame.size.height)];
        [self.c addBoundaryWithIdentifier:@"topWall" fromPoint:CGPointMake(0, 0) toPoint:CGPointMake(self.view.frame.size.width ,0 )];
        [self.c addBoundaryWithIdentifier:@"leftwall" fromPoint:CGPointZero toPoint:CGPointMake(0, self.view.frame.size.height)];
        [self.c addBoundaryWithIdentifier:@"rightwall" fromPoint:CGPointMake(self.view.frame.size.width, 0) toPoint:CGPointMake(self.view.frame.size.width, self.view.frame.size.height)];
        self.c.collisionDelegate = self;
        
        //7
        //adding behaviour to animator
        [self.animator addBehavior:self.p];
        [self.animator addBehavior:self.c];
    }
    
    if(_monsterBox2){
        //setting up animator
        self.animator2 = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        
        //5
        //setting up push behaviour
        self.p2 = [[UIPushBehavior alloc] initWithItems:@[_monsterBox2] mode:UIPushBehaviorModeInstantaneous];
        [self.p2 setPushDirection:CGVectorMake(-1.0, 1.0)];
        
        
        //6
        //setting up collision behavior and boundaries
        self.c2 = [[UICollisionBehavior alloc] initWithItems:@[_monsterBox2]];
        [self.c2 addBoundaryWithIdentifier:@"bottomwall" fromPoint:CGPointMake(0, self.view.frame.size.height) toPoint:CGPointMake(self.view.frame.size.width, self.view.frame.size.height)];
        [self.c2 addBoundaryWithIdentifier:@"topWall" fromPoint:CGPointMake(0, 0) toPoint:CGPointMake(self.view.frame.size.width ,0 )];
        [self.c2 addBoundaryWithIdentifier:@"leftwall" fromPoint:CGPointZero toPoint:CGPointMake(0, self.view.frame.size.height)];
        [self.c2 addBoundaryWithIdentifier:@"rightwall" fromPoint:CGPointMake(self.view.frame.size.width, 0) toPoint:CGPointMake(self.view.frame.size.width, self.view.frame.size.height)];
        self.c2.collisionDelegate = self;
        
        //7
        //adding behaviour to animator
        [self.animator2 addBehavior:self.p2];
        [self.animator2 addBehavior:self.c2];
    }
    
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id )item withBoundaryIdentifier:(id )identifier atPoint:(CGPoint)p {
    if ([(NSString*)identifier isEqualToString:@"bottomwall"]) {
        [self.p setPushDirection:CGVectorMake(1.0, -2.0)];
        [self.p setActive:YES];
        
        [self.p2 setPushDirection:CGVectorMake(1.0, -1.0)];
        [self.p2 setActive:YES];
        
        // NSLog(@"bottom");
    } else if ([(NSString*)identifier isEqualToString:@"topWall"]) {
        [self.p setPushDirection:CGVectorMake(-1.0, 1.0)];
        [self.p setActive:YES];
        
        [self.p2 setPushDirection:CGVectorMake(-1.0, 1.0)];
        [self.p2 setActive:YES];
        
        // NSLog(@"wall");
    } else if ([(NSString*)identifier isEqualToString:@"leftwall"]) {
        [self.p setPushDirection:CGVectorMake(1.0, 2.0)];
        [self.p setActive:YES];
        
        [self.p2 setPushDirection:CGVectorMake(1.0, 1.0)];
        [self.p2 setActive:YES];
        
        // NSLog(@"wall");
    } else {
        [self.p setPushDirection:CGVectorMake(-1.0, -1.0)];
        [self.p setActive:YES];
        
        [self.p2 setPushDirection:CGVectorMake(-1.0, -1.0)];
        [self.p2 setActive:YES];
        // NSLog(@"wall");
    }
    
}

-(void)setupCamera
{
    CGRect mainScreenFrame = [[UIScreen mainScreen] applicationFrame];
	UIView *primaryView = [[UIView alloc] initWithFrame:mainScreenFrame];
    /*
    _dValues = [[UILabel alloc] initWithFrame: CGRectMake(10.0,50.0, 300, 20)];
    _dValues.backgroundColor = [UIColor colorWithRed:0.986162 green:0.231412 blue:0.141241 alpha:1.000000];
    _dValues.text = [NSString stringWithFormat:@"testing"];
    _dValues.textColor = [UIColor whiteColor];
    */
    
    
    
	self.view = primaryView;
    
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    GPUImageFilter *customFilter = [[GPUImageSaturationFilter alloc] init];
    [(GPUImageSaturationFilter *)customFilter setSaturation:1.05];
    filteredVideoView = [[GPUImageView alloc] initWithFrame:CGRectMake(0.0, -50.0, mainScreenFrame.size.width, mainScreenFrame.size.height+50)];
    
    
    //add touch event
    UITapGestureRecognizer *focusTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFocusTap:)];
    focusTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:focusTap];
    [self.view addSubview:filteredVideoView];
    
    //[filteredVideoView addSubview:_dValues];
    
    //setup the monster Box
    if(![[_gameManager monsterByIdentifier:Monster1] isCatched]){
        UIImage *monsterImage = [_gameManager getMonsterImage:Monster1];
        CGRect frame = CGRectMake(100, 100, 80, 80);
        
        _monsterBox = [[UIImageView alloc] initWithFrame:frame];
        _monsterBox.backgroundColor = nil;
        _monsterBox.opaque = NO;
        _monsterBox.contentMode = UIViewContentModeRedraw;
        _monsterBox.image = monsterImage;
        [filteredVideoView addSubview:_monsterBox];
    }
    
    if(![[_gameManager monsterByIdentifier:Monster2] isCatched]){
        UIImage *monsterImage = [_gameManager getMonsterImage:Monster2];
        CGRect frame = CGRectMake(100, 100, 80, 80);
        
        _monsterBox2 = [[UIImageView alloc] initWithFrame:frame];
        _monsterBox2.backgroundColor = nil;
        _monsterBox2.opaque = NO;
        _monsterBox2.contentMode = UIViewContentModeRedraw;
        _monsterBox2.image = monsterImage;
        [filteredVideoView addSubview:_monsterBox2];
    }
    
    //setup dynamics
    [self setupDynamics];
    
    
    [videoCamera addTarget:customFilter];
    [customFilter addTarget:filteredVideoView];
    
    positionAverageColor = [[GPUImageAverageColor alloc] init];
    [positionAverageColor setColorAverageProcessingFinishedBlock:^(CGFloat redComponent, CGFloat greenComponent, CGFloat blueComponent, CGFloat alphaComponent, CMTime frameTime) {
        
        trackValues.red = redComponent;
        trackValues.green = greenComponent;
        trackValues.blue = blueComponent;
        [self updateView];
        
    }];
    
    [customFilter addTarget:positionAverageColor];
    [videoCamera startCameraCapture];
    
    //setup capture button
    UIButton *captureMobBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, 425, 150, 40)];
    captureMobBtn.layer.cornerRadius = 5;
    captureMobBtn.backgroundColor = [UIColor blackColor];
    [captureMobBtn setTitle: @"Capture" forState:UIControlStateNormal];
    [filteredVideoView addSubview:captureMobBtn];
    [captureMobBtn addTarget:self action:@selector(captureMonster:) forControlEvents:UIControlEventTouchUpInside];
    
    //setup capture label(button)
    captureLabel = [[UIButton alloc] initWithFrame:CGRectMake(85, 100, 150, 40)];
    captureLabel.layer.cornerRadius = 5;
    captureLabel.backgroundColor = [UIColor blackColor];
    [captureLabel setTitle: @"Catched" forState:UIControlStateNormal];
    [captureLabel setAlpha:0.0];
    [filteredVideoView addSubview:captureLabel];
    
    
    
}

-(void)updateView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        /*
        _dValues.backgroundColor = [UIColor colorWithRed:trackValues.red green:trackValues.green blue:trackValues.blue alpha:1.0 ];
        _dValues.text = [NSString stringWithFormat:@"R: %f, G: %f, B: %f", trackValues.red, trackValues.green, trackValues.blue];
        */
        //make monster appear
        NSUInteger color_case = self.getColorMonster;
        switch (color_case)
        {
            case 1:
                //_monsterBox.alpha = 1;
                [_monsterBox setHidden:NO];
                break;
                
            case 2:
                //_monsterBox.alpha = 1;
                [_monsterBox2 setHidden:NO];
                break;
                
            default:
                //_monsterBox.alpha = 0;
                if (![_monsterBox isHidden]) {
                    [_monsterBox setHidden:YES];
                }
                
                if (![_monsterBox2 isHidden]) {
                    [_monsterBox2 setHidden:YES];
                }
                break;
        }
        
        if(![_monsterBox isHidden] && [[_gameManager monsterByIdentifier:Monster1] isCatched]){
            [UIView animateWithDuration:2.0
                             animations:^{
                                 //[_monsterBox setHidden:YES];
                                 [_monsterBox setAlpha:0.0];
                             }
                             completion:^(BOOL finished){
                                 _monsterBox = nil;
                                 [_monsterBox removeFromSuperview];
                             }];
            
        } else if (![_monsterBox2 isHidden] && [[_gameManager monsterByIdentifier:Monster2] isCatched]){
            [UIView animateWithDuration:2.0
                             animations:^{
                                 //[_monsterBox2 setHidden:YES];
                                 [_monsterBox2 setAlpha:0.0];
                             }
                             completion:^(BOOL finished){
                                 _monsterBox2 = nil;
                                 [_monsterBox2 removeFromSuperview];
                             }];
        }
    });
}

-(void)captureMonster:(UIButton *)sender
{
    NSLog(@"captureMonster:");
    NSLog(@"%d",[_monsterBox2 isHidden]);
    NSLog(@"%p", _mobFocusSq);
    
    if(![_monsterBox isHidden] && _mobFocusSq)
    {
        CGRect box1 = CGRectMake(_monsterBox.center.x - 50, _monsterBox.center.y - 50, 100, 100);
        CGRect box2 = CGRectMake(_mobFocusSq.center.x - 40, _mobFocusSq.center.y - 40, 80, 80);
        
        if(CGRectIntersectsRect(box1, box2))
        {
            //isCaptured = YES;
            [_gameManager setMonster:Monster1 catched:YES];
            NSLog(@"catched 3");
            [UIView animateWithDuration:3.0
                             animations:^{
                                 [captureLabel setAlpha:1.0];
                             } completion:^(BOOL complete){
                                 [UIView animateWithDuration:3.0 animations:^{[captureLabel setAlpha:0.0];}];
                             }];
        }
    } else if (![_monsterBox2 isHidden] && _mobFocusSq){
        NSLog(@"innnnnnnn");
        CGRect box1 = CGRectMake(_monsterBox2.center.x - 50, _monsterBox2.center.y - 50, 100, 100);
        CGRect box2 = CGRectMake(_mobFocusSq.center.x - 40, _mobFocusSq.center.y - 40, 80, 80);
        
        if(CGRectIntersectsRect(box1, box2))
        {
            //isCaptured = YES;
            [_gameManager setMonster:Monster2 catched:YES];
            NSLog(@"catched 2");
            [UIView animateWithDuration:3.0
                             animations:^{
                                 [captureLabel setAlpha:1.0];
                             } completion:^(BOOL complete){
                                 [UIView animateWithDuration:3.0 animations:^{[captureLabel setAlpha:0.0];}];
                             }];
            
        }
    }
}

-(IBAction)handleFocusTap:(id)sender
{
    CGPoint point = [sender locationInView:self.view];
    
    if ([videoCamera.inputCamera isFocusPointOfInterestSupported] && [videoCamera.inputCamera isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([videoCamera.inputCamera lockForConfiguration:&error]) {
            [videoCamera.inputCamera setFocusPointOfInterest:point];
            
            [videoCamera.inputCamera setFocusMode:AVCaptureFocusModeAutoFocus];
            
            if([videoCamera.inputCamera isExposurePointOfInterestSupported] && [videoCamera.inputCamera isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
            {
                [videoCamera.inputCamera setExposurePointOfInterest:point];
                [videoCamera.inputCamera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            [videoCamera.inputCamera unlockForConfiguration];
        }
    }
    
    if (_mobFocusSq || isFocusing)
    {
        _mobFocusSq = nil;
        [_mobFocusSq removeFromSuperview];
    } else {
        
        _mobFocusSq = [[MonsterFocusSquare alloc]initWithFrame:CGRectMake(point.x-60, point.y-60, 120, 120)];
        [_mobFocusSq setBackgroundColor:[UIColor clearColor]];
        [[self.view.subviews objectAtIndex:0] addSubview:_mobFocusSq];
        [_mobFocusSq setNeedsDisplay];
        
        [UIView animateWithDuration:1.5
                         animations:^{
                             [_mobFocusSq setAlpha:0.0];
                             isFocusing = YES;
                         }
                         completion:^(BOOL finished){
                             _mobFocusSq = nil;
                             [_mobFocusSq removeFromSuperview];
                             isFocusing = NO;
                         }
         ];
    }
}

-(NSUInteger)getColorMonster
{
    NSUInteger color_index = 0;
    
    if(trackValues.red > 0.90 && trackValues.green < 0.30){ // red
        
        color_index = 1;
        
    } else if (trackValues.green > 0.5 && trackValues.blue < 0.2){ // green
        
        color_index = 2;
        
    }
    return color_index;
}


- (void)viewWillDisappear:(BOOL)animated
{
    // Note: I needed to stop camera capture before the view went off the screen in order to prevent a crash from the camera still sending frames
    //[videoCamera stopCameraCapture];
    
	[super viewWillDisappear:animated];
    [videoCamera stopCameraCapture];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [videoCamera stopCameraCapture];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
