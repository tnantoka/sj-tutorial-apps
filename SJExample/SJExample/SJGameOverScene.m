//
//  SJGameOverScene.m
//  SJExample
//
//  Created by Tatsuya Tobioka on 2013/09/30.
//  Copyright (c) 2013年 tnantoka. All rights reserved.
//

#import "SJGameOverScene.h"

#import "SJTitleScene.h"

@implementation SJGameOverScene {
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
    titleLabel.text = @"ゲームオーバー";
    titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:titleLabel];

    [self performSelector:@selector(_goTitle) withObject:Nil afterDelay:5.0f];
}

- (void)_goTitle {
    SJTitleScene *titleScene = [SJTitleScene sceneWithSize:self.size];
    SKTransition *transition = [SKTransition pushWithDirection:SKTransitionDirectionLeft duration:1.0f];
    [self.view presentScene:titleScene transition:transition];
}

@end
