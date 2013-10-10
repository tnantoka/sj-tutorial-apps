//
//  SJAnimationScene.m
//  SJAnimation
//
//  Created by Tatsuya Tobioka on 2013/09/19.
//  Copyright (c) 2013年 tnantoka. All rights reserved.
//

#import "SJAnimationScene.h"

#define SIZE 96.0f

@implementation SJAnimationScene {
    BOOL _contentCreated;
}

- (void)didMoveToView:(SKView *)view {
    if (!_contentCreated) {
        [self createSceneContents];
        _contentCreated = YES;
    }
}

- (void)createSceneContents {
    
    // Move to touch
    SKSpriteNode *sword = [SKSpriteNode spriteNodeWithImageNamed:@"sword"];
    sword.position = CGPointMake(30.0f, 30.0f);
    sword.name = @"sword";
    [self addChild:sword];

    // Sequence
    SKSpriteNode *sequenceSword = [SKSpriteNode spriteNodeWithImageNamed:@"sword"];
    sequenceSword.position = CGPointMake(100.0f, 400.0f);
    [self addChild:sequenceSword];
    
    SKAction *moveRight = [SKAction moveByX:100.0f y:0 duration:1.0f];
    SKAction *moveDown = [SKAction moveByX:0 y:-100.0f duration:1.0f];
    SKAction *wait = [SKAction waitForDuration:1.0f];
    SKAction *moveLeft = [SKAction moveByX:-100.0f y:0 duration:1.0f];
    SKAction *moveUp = [SKAction moveByX:0 y:100.0f duration:1.0f];
    SKAction *remove = [SKAction removeFromParent];
   
    SKAction *sequence = [SKAction sequence:@[moveRight, moveDown, wait, moveLeft, moveUp, remove]];
    [sequenceSword runAction:sequence];
    
    // Group
    SKSpriteNode *groupSword = [SKSpriteNode spriteNodeWithImageNamed:@"sword"];
    groupSword.position = CGPointMake(150.0f, 200.0f);
    [self addChild:groupSword];
    
    SKAction *zoom = [SKAction scaleBy:5.0 duration:3.0f];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:3.0f];
    SKAction *group = [SKAction group:@[zoom, fadeOut]];
    
    [groupSword runAction:group];
    
    
    // Walk
    int row = 1;
    SKTexture *clotharmor = [SKTexture textureWithImageNamed:@"clotharmor"];

    NSMutableArray *textures = @[].mutableCopy;
    for (int col = 0; col < 4; col++) {
        CGFloat x = col * SIZE / clotharmor.size.width;
        CGFloat y = row * SIZE / clotharmor.size.height;
        CGFloat w = SIZE / clotharmor.size.width;
        CGFloat h = SIZE / clotharmor.size.height;
        
        SKTexture *texture = [SKTexture textureWithRect:CGRectMake(x, y, w, h) inTexture:clotharmor];
        [textures addObject:texture];
    }
    SKSpriteNode *walker = [SKSpriteNode spriteNodeWithTexture:textures.firstObject];
    walker.position = CGPointMake(250.0f, 100.0f);
    [self addChild:walker];
    
    SKAction *walk = [SKAction animateWithTextures:textures timePerFrame:0.2f];
    SKAction *forever = [SKAction repeatActionForever:walk];
    [walker runAction:forever];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch  = [touches anyObject];
    CGPoint location = [touch locationInNode:self];

    SKNode *sword = [self childNodeWithName:@"sword"];
    SKAction *moveToTouch = [SKAction moveTo:location duration:1.0f];
    [sword runAction:moveToTouch completion:^{
        NSLog(@"%@", NSStringFromCGPoint(location));
    }];
}

@end
