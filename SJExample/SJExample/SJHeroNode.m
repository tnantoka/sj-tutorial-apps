//
//  SJHeroNode.m
//  SJExample
//
//  Created by Tatsuya Tobioka on 2013/09/29.
//  Copyright (c) 2013年 tnantoka. All rights reserved.
//

#import "SJHeroNode.h"

const CGFloat TIP_SIZE = 96.0f;

@implementation SJHeroNode

+ (id)hero {
    SJHeroNode *hero = [SJHeroNode spriteNodeWithTexture:nil size:CGSizeMake(TIP_SIZE, TIP_SIZE)];
    return hero;
}

- (id)initWithTexture:(SKTexture *)texture color:(UIColor *)color size:(CGSize)size {
    if (self = [super initWithTexture:texture color:color size:size]) {
        [self stop];
    }
    return self;
}

- (void)stop {
    //if (_state == SJHeroStateStop) return;
    [self _animate:@"clotharmor" withRow:3 cols:2 time:0.6f completion:nil];
    self.state = SJHeroStateStop;
}

- (void)walk {
    //if (_state == SJHeroStateWalk) return;
    [self _animate:@"clotharmor" withRow:4 cols:4 time:0.2f completion:nil];
    self.state = SJHeroStateWalk;
}

- (void)attack {
    if (_state == SJHeroStateAttack) return;
    
    [self _animate:@"clotharmor" withRow:5 cols:5 time:0.05f completion:^{
        self.state = SJHeroStateStop;
    }];
    [self _sword];
    
    self.state = SJHeroStateAttack;
}

- (void)_sword {
    NSArray *textures = [self _textures:@"sword1" withRow:5 cols:5];

    SKSpriteNode *swordSprite = [SKSpriteNode spriteNodeWithTexture:textures.firstObject];
    [self addChild:swordSprite];
    
    SKAction *animate = [SKAction animateWithTextures:textures timePerFrame:0.05f];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[animate, remove]];
    [swordSprite runAction:sequence];    
}

- (void)_animate:(NSString *)name withRow:(int)row cols:(int)cols time:(CGFloat)time completion:(void (^)())block {

    NSArray *textures = [self _textures:name withRow:row cols:cols];

    SKAction *animate = [SKAction animateWithTextures:textures timePerFrame:time];
    if (!block) {
        SKAction *forever = [SKAction repeatActionForever:animate];
        [self runAction:forever];
    } else {
        [self runAction:animate completion:block];
    }
}

- (NSArray *)_textures:(NSString *)name withRow:(int)row cols:(int)cols {
    SKTexture *texture = [SKTexture textureWithImageNamed:name];
    
    NSMutableArray *textures = @[].mutableCopy;
    for (int col = 0; col < cols; col++) {
        CGFloat x = col * TIP_SIZE / texture.size.width;
        CGFloat y = row * TIP_SIZE / texture.size.height;
        CGFloat w = TIP_SIZE / texture.size.width;
        CGFloat h = TIP_SIZE / texture.size.height;
        
        SKTexture *t = [SKTexture textureWithRect:CGRectMake(x, y, w, h) inTexture:texture];
        [textures addObject:t];
    }

    return textures;
}

@end
