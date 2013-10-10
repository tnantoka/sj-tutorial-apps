//
//  SJTitleScene.m
//  SJExample
//
//  Created by Tatsuya Tobioka on 2013/09/29.
//  Copyright (c) 2013年 tnantoka. All rights reserved.
//

#import "SJTitleScene.h"

#import "SJPlayScene.h"
#import "SJButtonNode.h"

static NSString * const START_NAME = @"start";

@implementation SJTitleScene {
    BOOL _contentCreated;
}

- (void)didMoveToView:(SKView *)view {
    if (!_contentCreated) {
        [self createSceneContents];
        _contentCreated = YES;
    }
}

- (void)createSceneContents {
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Mosamosa"];
    titleLabel.text = @"たからもり";
    titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:titleLabel];

    SJButtonNode *startButton = [SJButtonNode labelNodeWithFontNamed:titleLabel.fontName];
    startButton.text = @"はじめる";
    startButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 30.0f);
    startButton.fontSize = 20.0f;
    startButton.hidden = YES;
    startButton.name = @"start";
    [self addChild:startButton];
    
    SKAction *wait = [SKAction waitForDuration:1.0f];
    SKAction *moveUp = [SKAction moveByX:0 y:50.0f duration:0.5f];
    SKAction *sequence = [SKAction sequence:@[wait, moveUp]];
    [titleLabel runAction:sequence completion:^{
        startButton.hidden = NO;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    SKNode *nodeAtPoint = [self nodeAtPoint:[touch locationInNode:self]];
    if (nodeAtPoint.name == START_NAME) {
        SJButtonNode *startButton = (SJButtonNode *)nodeAtPoint;
        startButton.highlighted = YES;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    SJButtonNode *startButton = (SJButtonNode *)[self childNodeWithName:START_NAME];
    startButton.highlighted = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    SKNode *nodeAtPoint = [self nodeAtPoint:[touch locationInNode:self]];

    if (nodeAtPoint.name == START_NAME) {
        SJButtonNode *startButton = (SJButtonNode *)nodeAtPoint;
        if (startButton.highlighted) {
            SJPlayScene *playScene = [SJPlayScene sceneWithSize:self.size];
            SKTransition *transition = [SKTransition pushWithDirection:SKTransitionDirectionLeft duration:1.0f];
            [self.view presentScene:playScene transition:transition];
        }
    }

    [self touchesCancelled:touches withEvent:event];
}

@end
