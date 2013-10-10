//
//  SJHeroNode.h
//  SJExample
//
//  Created by Tatsuya Tobioka on 2013/09/29.
//  Copyright (c) 2013年 tnantoka. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

extern const CGFloat TIP_SIZE;

typedef enum : uint8_t {
    SJHeroStateStop = 0,
    SJHeroStateWalk,
    SJHeroStateAttack
} SJHeroState;

@interface SJHeroNode : SKSpriteNode

@property (nonatomic) SJHeroState state;

+ (id)hero;

- (void)stop;
- (void)walk;
- (void)attack;

@end
