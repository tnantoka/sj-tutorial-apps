//
//  SJSecondScene.m
//  SJScene
//
//  Created by Tatsuya Tobioka on 2013/09/26.
//  Copyright (c) 2013年 tnantoka. All rights reserved.
//

#import "SJSecondScene.h"

@implementation SJSecondScene {
    BOOL _contentCreated;
}

- (void)didMoveToView:(SKView *)view {
    if (!_contentCreated) {
        [self createSceneContents];
        _contentCreated = YES;
    }
}

- (void)createSceneContents {
    self.backgroundColor = [SKColor lightGrayColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    SKTransition *door = [SKTransition doorwayWithDuration:2.0f];
    [self.view presentScene:_prevScene transition:door];
}

@end
