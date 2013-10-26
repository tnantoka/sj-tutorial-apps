//
//  SJPhysicsScene.m
//  SJPhysics
//
//  Created by Tatsuya Tobioka on 2013/09/26.
//  Copyright (c) 2013年 tnantoka. All rights reserved.
//

#import "SJPhysicsScene.h"

// https://developer.apple.com/library/ios/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/GettingStarted/GettingStarted.html#//apple_ref/doc/uid/TP40013043-CH2-SW14
static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}
static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

@implementation SJPhysicsScene {
    BOOL _contentCreated;
}

- (void)didMoveToView:(SKView *)view {
    if (!_contentCreated) {
        [self createSceneContents];
        _contentCreated = YES;
    }
}

- (void)createSceneContents {
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
}

- (SKNode *)newBall {
    SKShapeNode *ball = [SKShapeNode node];
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat r = skRand(3, 30);
    CGPathAddArc(path, NULL, 0, 0, r, 0, M_PI * 2, YES);
    ball.path = path;
    ball.fillColor = [SKColor colorWithRed:skRand(0, 1.0f) green:skRand(0, 1.0f) blue:skRand(0, 1.0f) alpha:skRand(0.7f, 1.0f)];
    ball.strokeColor = [SKColor clearColor];
    
    // Physics
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:r];
    
    CGPathRelease(path);
    
    return ball;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self];
        
        SKNode *ball = [self newBall];
        ball.position = location;
        [self addChild:ball];
    }
    else if (touches.count == 2) {
        self.physicsWorld.gravity = CGVectorMake(0, self.physicsWorld.gravity.dy * -1.0f);
    }
}


@end
