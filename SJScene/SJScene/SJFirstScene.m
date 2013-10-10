//
//  SJFirstScene.m
//  SJScene
//
//  Created by Tatsuya Tobioka on 2013/09/25.
//  Copyright (c) 2013年 tnantoka. All rights reserved.
//

#import "SJFirstScene.h"

#import "SJSecondScene.h"

@implementation SJFirstScene {
    BOOL _contentCreated;
}

- (void)didMoveToView:(SKView *)view {
    if (!_contentCreated) {
        [self createSceneContents];
        _contentCreated = YES;
    }
}

- (void)createSceneContents {
    
    // default
    SKSpriteNode *red = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(50.0f, 50.0f)];
    red.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:red];

    SKSpriteNode *green = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(50.0f, 50.0f)];
    green.position = CGPointMake(CGRectGetMidX(self.frame) + 10.0f, CGRectGetMidY(self.frame) - 10.0f);
    [self addChild:green];

    SKSpriteNode *blue = [SKSpriteNode spriteNodeWithColor:[SKColor blueColor] size:CGSizeMake(50.0f, 50.0f)];
    blue.position = CGPointMake(CGRectGetMidX(self.frame) - 10.0f, CGRectGetMidY(self.frame) - 20.0f);
    [self addChild:blue];

    // zPosition
    SKSpriteNode *magenta = [SKSpriteNode spriteNodeWithColor:[SKColor magentaColor] size:CGSizeMake(50.0f, 50.0f)];
    magenta.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 100.0f);
    magenta.zPosition = 1.0f;
    [self addChild:magenta];
    
    SKSpriteNode *yellow = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size:CGSizeMake(50.0f, 50.0f)];
    yellow.position = CGPointMake(CGRectGetMidX(self.frame) + 10.0f, CGRectGetMidY(self.frame) + 100.0f - 10.0f);
    yellow.zPosition = 2.0f;
    [self addChild:yellow];
    
    SKSpriteNode *cyan = [SKSpriteNode spriteNodeWithColor:[SKColor cyanColor] size:CGSizeMake(50.0f, 50.0f)];
    cyan.position = CGPointMake(CGRectGetMidX(self.frame) - 10.0f, CGRectGetMidY(self.frame) + 100.0f - 20.0f);
    [self addChild:cyan];

    // name
    SKSpriteNode *white = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(50.0f, 50.0f)];
    white.position = CGPointMake(65.0f, 70.0f);
    white.name = @"white1";
    [self addChild:white];

    for (int i = 2; i < 5; i++) {
        SKSpriteNode *white = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(50.0f, 50.0f)];
        white.position = CGPointMake(65.0f * i, 70.0f);
        white.name = @"whites";
        [self addChild:white];
    }
    
}

- (void)update:(NSTimeInterval)currentTime {
    //NSLog(@"1: update:");
}

- (void)didEvaluateActions {
    //NSLog(@"2: updidEvaluateActions");
}

- (void)didSimulatePhysics {
    //NSLog(@"3: updidEvaluatePhysics");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (touches.count == 1) {
        [self childNodeWithName:@"white1"].yScale *= 0.9f;
        [self enumerateChildNodesWithName:@"whites" usingBlock:^(SKNode *node, BOOL *stop) {
            node.zRotation += -5.0f * M_PI / 180.0f;
        }];
    }
    else if (touches.count == 2) {
        SKTransition *push = [SKTransition pushWithDirection:SKTransitionDirectionLeft duration:2.0f];
        SJSecondScene *second = [SJSecondScene sceneWithSize:self.size];
        second.prevScene = self;
        [self.view presentScene:second transition:push];
    }
}


@end
