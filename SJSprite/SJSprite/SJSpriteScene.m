//
//  SJSpriteScene.m
//  SJSprite
//
//  Created by Tatsuya Tobioka on 2013/09/18.
//  Copyright (c) 2013年 tnantoka. All rights reserved.
//

#import "SJSpriteScene.h"

@implementation SJSpriteScene {
    BOOL _contentCreated;
}

- (void)didMoveToView:(SKView *)view {
    if (!_contentCreated) {
        [self createSceneContents];
        _contentCreated = YES;
    }
}

- (void)createSceneContents {
    
    // Sprite with image
    SKSpriteNode *sword = [SKSpriteNode spriteNodeWithImageNamed:@"sword"];
    sword.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:sword];
    
    // Sprite with color
    SKSpriteNode *square = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(30.0f, 30.0f)];
    square.position = CGPointMake(sword.position.x, sword.position.y - 50.0f);
    [self addChild:square];

    // Colorize
    for (int i = 1; i <= 5; i++) {
        SKSpriteNode *coloredSword = [SKSpriteNode spriteNodeWithImageNamed:@"sword"];
        coloredSword.position = CGPointMake(i * 55.0f, square.position.y - 50.0f);
        coloredSword.color = [SKColor redColor];
        coloredSword.colorBlendFactor = i * 2 / 10.0f;
        [self addChild:coloredSword];
    }
    
    // Resize
    SKSpriteNode *resizedSword = [SKSpriteNode spriteNodeWithImageNamed:@"sword"];
    resizedSword.position = CGPointMake(sword.position.x, sword.position.y + 100.0f);
    resizedSword.xScale = 2.0f;
    resizedSword.yScale = 2.0f;
    [self addChild:resizedSword];

    
    // Anchor at center
    SKSpriteNode *centerSword = [SKSpriteNode spriteNodeWithImageNamed:@"sword"];
    centerSword.position = CGPointMake(sword.position.x - 55.0f, resizedSword.position.y + 80.0f);
    centerSword.zPosition = 1.0f;
    [self addChild:centerSword];
    
    SKSpriteNode *centerBox = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(50.0f, 50.0f)];
    centerBox.position = centerSword.position;
    [self addChild:centerBox];

    // Anchor at center and rotate
    SKSpriteNode *centerRotatedSword = [SKSpriteNode spriteNodeWithImageNamed:@"sword"];
    centerRotatedSword.position = CGPointMake(centerSword.position.x - 55.0f, centerSword.position.y);
    centerRotatedSword.zRotation = 30.0f * M_PI / 180.0f;
    centerRotatedSword.zPosition = 1.0f;
    [self addChild:centerRotatedSword];
    
    SKSpriteNode *centerRotatedBox = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(50.0f, 50.0f)];
    centerRotatedBox.position = centerRotatedSword.position;
    [self addChild:centerRotatedBox];

    // Anchor at right bottom
    SKSpriteNode *bottomSword = [SKSpriteNode spriteNodeWithImageNamed:@"sword"];
    bottomSword.position = CGPointMake(sword.position.x + 55.0f, centerRotatedSword.position.y);
    bottomSword.zPosition = 1.0f;
    bottomSword.anchorPoint = CGPointMake(1.0f, 1.0f);
    [self addChild:bottomSword];
    
    SKSpriteNode *bottomBox = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(50.0f, 50.0f)];
    bottomBox.position = bottomSword.position;
    [self addChild:bottomBox];

    // Anchor at right bottom and rotate
    SKSpriteNode *bottomRotatedSword = [SKSpriteNode spriteNodeWithImageNamed:@"sword"];
    bottomRotatedSword.position = CGPointMake(bottomSword.position.x + 55.0f, bottomSword.position.y);
    bottomRotatedSword.zRotation = 30.0f * M_PI / 180.0f;
    bottomRotatedSword.zPosition = 1.0f;
    bottomRotatedSword.anchorPoint = CGPointMake(1.0f, 1.0f);
    [self addChild:bottomRotatedSword];
    
    SKSpriteNode *bottomRotatedBox = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(50.0f, 50.0f)];
    bottomRotatedBox.position = bottomRotatedSword.position;
    [self addChild:bottomRotatedBox];

}

@end