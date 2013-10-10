//
//  SJParticleScene.m
//  SJParticle
//
//  Created by Tatsuya Tobioka on 2013/09/27.
//  Copyright (c) 2013年 tnantoka. All rights reserved.
//

#import "SJParticleScene.h"

// https://developer.apple.com/library/ios/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/GettingStarted/GettingStarted.html#//apple_ref/doc/uid/TP40013043-CH2-SW14
static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}
static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

static const uint32_t swordCategory = 0x1 << 0;
static const uint32_t ballCategory = 0x1 << 1;
static const uint32_t worldCategory = 0x1 << 2;

@interface SJParticleScene () <SKPhysicsContactDelegate>
@end

@implementation SJParticleScene {
    BOOL _contentCreated;
}

- (void)didMoveToView:(SKView *)view {
    if (!_contentCreated) {
        [self createSceneContents];
        _contentCreated = YES;
    }
}

- (void)createSceneContents {
    // Fire
    NSString *firePath = [[NSBundle mainBundle] pathForResource:@"fire" ofType:@"sks"];
    SKEmitterNode *fire = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
    fire.position = CGPointMake(30.0f, 30.0f);
    fire.xScale = fire.yScale = 0.5f;
    [self addChild:fire];

    // Physics
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsWorld.gravity = CGVectorMake(0, self.physicsWorld.gravity.dy * -1.0f);
    self.physicsWorld.contactDelegate = self;
    self.physicsBody.categoryBitMask = worldCategory;
    
    // Ball
    for (int i = 0; i < 30; i++) {
        [self addChild:[self newBall]];
    }
}

- (SKNode *)newBall {
    SKShapeNode *ball = [SKShapeNode node];
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat r = skRand(3, 30);
    CGPathAddArc(path, NULL, 0, 0, r, 0, M_PI * 2, YES);
    ball.path = path;
    ball.fillColor = [SKColor colorWithRed:skRand(0, 1.0f) green:skRand(0, 1.0f) blue:skRand(0, 1.0f) alpha:skRand(0.7f, 1.0f)];
    ball.strokeColor = [SKColor clearColor];
    ball.position = CGPointMake(skRand(0, self.frame.size.width), skRand(0, self.frame.size.height));
    
    // Physics
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:r];
    ball.physicsBody.categoryBitMask = ballCategory;
    //ball.physicsBody.collisionBitMask = swordCategory | ballCategory;
    //ball.physicsBody.contactTestBitMask = swordCategory;
    
    return ball;
}

- (SKNode *)newSword {
    SKSpriteNode *sword = [SKSpriteNode spriteNodeWithImageNamed:@"sword"];
    sword.xScale = sword.yScale = 0.5f;
    sword.zRotation = -45.0f * M_PI / 180.0f;
    
    // Physics
    sword.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGRectApplyAffineTransform(sword.frame, CGAffineTransformMakeScale(0.7f, 0.7f)).size];
    //sword.physicsBody.dynamic = NO;
    sword.physicsBody.affectedByGravity = NO;
    sword.physicsBody.velocity = CGVectorMake(0, 1000.0f);
    sword.physicsBody.categoryBitMask = swordCategory;
    sword.physicsBody.collisionBitMask = ballCategory;
    sword.physicsBody.contactTestBitMask = ballCategory | worldCategory;
    sword.physicsBody.usesPreciseCollisionDetection = YES;

    return sword;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInNode:self];
    
    SKNode *sword = [self newSword];
    sword.position = location;
    [self addChild:sword];
}

# pragma mark - SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & swordCategory) != 0) {
        
        if ((secondBody.categoryBitMask & ballCategory) != 0) {
            NSString *sparkPath = [[NSBundle mainBundle] pathForResource:@"spark" ofType:@"sks"];
            SKEmitterNode *spark = [NSKeyedUnarchiver unarchiveObjectWithFile:sparkPath];
            spark.position = secondBody.node.position;
            spark.xScale = spark.yScale = 0.2f;
            [self addChild:spark];
            
            SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3f];
            SKAction *remove = [SKAction removeFromParent];
            SKAction *sequence = [SKAction sequence:@[fadeOut, remove]];
            [spark runAction:sequence];
            
            [firstBody.node removeFromParent];
            [secondBody.node removeFromParent];
        } else if ((secondBody.categoryBitMask & worldCategory) != 0) {
            NSLog(@"contact with world");
            [firstBody.node removeFromParent];
        }
        
    }
}
@end
