//
//  SJPlayScene.m
//  SJExample
//
//  Created by Tatsuya Tobioka on 2013/09/29.
//  Copyright (c) 2013年 tnantoka. All rights reserved.
//

#import "SJPlayScene.h"

#import "SJHeroNode.h"
#import "SJGameOverScene.h"

static NSString * const HERO_NAME = @"hero";
static NSString * const ENEMY_NAME = @"enemy";
static NSString * const TIME_NAME = @"time";
static NSString * const SCORE_NAME = @"score";

static const CGFloat TILE_SIZE = 96.0f;
static const CGFloat HERO_SPEED = 1.5f;
static const CGFloat ENEMY_SPEED = 100.0f;

static const uint32_t heroCategory = 0x1 << 0;
static const uint32_t enemyCategory = 0x1 << 1;
static const uint32_t boxCategory = 0x1 << 2;
static const uint32_t worldCategory = 0x1 << 3;

// https://developer.apple.com/library/ios/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/GettingStarted/GettingStarted.html#//apple_ref/doc/uid/TP40013043-CH2-SW14
static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}
static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

@interface SJPlayScene () <SKPhysicsContactDelegate>
@end

@implementation SJPlayScene {
    BOOL _contentCreated;
    NSTimeInterval _lastUpdateTimeInterval;
    NSTimeInterval _timeSinceStart;
    NSTimeInterval _timeSinceLastSecond;
    int _enemies;
    int _boxes;
    int _score;
}

- (void)didMoveToView:(SKView *)view {
    if (!_contentCreated) {
        [self createSceneContents];
        _contentCreated = YES;
    }
}

- (void)createSceneContents {
    _lastUpdateTimeInterval = 0;
    _timeSinceStart = 0;
    _timeSinceLastSecond = 0;
    _enemies = 0;
    _boxes = 6;
    _score = 0;
    
    [self _addBackground];
    [self _addHero];
    [self _addBoxes];
    [self _addLabels];
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsWorld.contactDelegate = self;
    self.physicsBody.categoryBitMask = worldCategory;
}

- (void)update:(NSTimeInterval)currentTime {
    
    if (_lastUpdateTimeInterval > 0) {
        CFTimeInterval timeSinceLast = currentTime - _lastUpdateTimeInterval;
        _timeSinceStart += timeSinceLast;
        _timeSinceLastSecond += timeSinceLast;
        
        SKLabelNode *timeLabel = (SKLabelNode *)[self childNodeWithName:TIME_NAME];
        timeLabel.text = [NSString stringWithFormat:@"%07.1f", _timeSinceStart];
        
        if (_timeSinceLastSecond >= 1) {
            _timeSinceLastSecond = 0;
            
            int timing = 3;
            if (_timeSinceStart > 2) timing = 2;
            if (_timeSinceStart > 4) timing = 1;
            
            int max = 1;
            if (_timeSinceStart > 1) max = 2;
            if (_timeSinceStart > 3) max = 3;
            if (_timeSinceStart > 5) max = 4;
            if ((int)_timeSinceStart % timing == 0) {
                if (_enemies < max) {
                    [self _addEnemy];
                }
            }
        }
        
    }
    _lastUpdateTimeInterval = currentTime;

}

- (void)_addBackground {
    
    SKTexture *wood = [SKTexture textureWithImageNamed:@"wood"];

    int rows = self.frame.size.height / TILE_SIZE;
    int cols = self.frame.size.width / TILE_SIZE;
    for (int row = 0; row <= rows; row++) {
        int y = row * TILE_SIZE;
        for (int col = 0; col <= cols; col++) {
            int x = col * TILE_SIZE;
            SKSpriteNode *bgSprite = [SKSpriteNode spriteNodeWithTexture:wood];
            bgSprite.anchorPoint = CGPointMake(0, 0);
            bgSprite.position = CGPointMake(x, y);
            bgSprite.xScale = TILE_SIZE / wood.size.width;
            bgSprite.yScale = TILE_SIZE / wood.size.height;
            [self addChild:bgSprite];
        }
    }
}

- (void)_addHero {
    SJHeroNode *hero = [SJHeroNode hero];
    hero.position = CGPointMake(CGRectGetMidX(self.frame), hero.size.height * 1.25f);
    hero.name = HERO_NAME;
    hero.zPosition = 1.0f;
    [self addChild:hero];
    
    hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(TIP_SIZE * 0.5f, TIP_SIZE * 0.5f)];
    hero.physicsBody.affectedByGravity = NO;
    hero.physicsBody.categoryBitMask = heroCategory;
    hero.physicsBody.contactTestBitMask = enemyCategory;
    hero.physicsBody.collisionBitMask = 0;
}

- (void)_addBoxes {
    SKTexture *chest = [SKTexture textureWithImageNamed:@"chest"];
    int y = 30.0f;
    for (int col = 0; col < _boxes; col++) {
        int x = col * chest.size.width + 40.0f;
        SKSpriteNode *boxSprite = [SKSpriteNode spriteNodeWithTexture:chest];
        boxSprite.position = CGPointMake(x, y);
        [self addChild:boxSprite];
        
        boxSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(boxSprite.size.width * 0.5f, boxSprite.size.height * 0.5f)];
        boxSprite.physicsBody.affectedByGravity = NO;
        boxSprite.physicsBody.categoryBitMask = boxCategory;
        boxSprite.physicsBody.collisionBitMask = 0;
    }
}

- (void)_addLabels {
    SKLabelNode *timeLabel = [SKLabelNode labelNodeWithFontNamed:@"Mosamosa"];
    timeLabel.name = TIME_NAME;
    timeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    timeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    timeLabel.position = CGPointMake(5.0f, CGRectGetMaxY(self.frame) - 20.0f);
    timeLabel.fontSize = 14.0f;
    [self addChild:timeLabel];
    
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Mosamosa"];
    scoreLabel.name = SCORE_NAME;
    scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    scoreLabel.position = CGPointMake(CGRectGetMaxX(self.frame) - scoreLabel.frame.size.width - 5.0f, CGRectGetMaxY(self.frame) - 20.0f);
    scoreLabel.fontSize = 14.0f;
    [self addChild:scoreLabel];
    [self _score:0];
}

- (void)_addEnemy {
    
    _enemies++;

    int row = 0;
    int cols = 5;
    SKTexture *bat = [SKTexture textureWithImageNamed:@"bat"];
    
    NSMutableArray *textures = @[].mutableCopy;
    for (int col = 0; col < cols; col++) {
        CGFloat x = col * TIP_SIZE / bat.size.width;
        CGFloat y = row * TIP_SIZE / bat.size.height;
        CGFloat w = TIP_SIZE / bat.size.width;
        CGFloat h = TIP_SIZE / bat.size.height;
        
        SKTexture *texture = [SKTexture textureWithRect:CGRectMake(x, y, w, h) inTexture:bat];
        [textures addObject:texture];
    }
    
    SKSpriteNode *enemy = [SKSpriteNode spriteNodeWithTexture:textures.firstObject];
    enemy.position = CGPointMake(skRand(40.0f, CGRectGetMaxX(self.frame) - 40.0f), CGRectGetMaxY(self.frame) - TIP_SIZE);
    enemy.name = ENEMY_NAME;
    [self addChild:enemy];
    
    SKAction *animate = [SKAction animateWithTextures:textures timePerFrame:0.1f];
    SKAction *forever = [SKAction repeatActionForever:animate];
    [enemy runAction:forever];

    enemy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(TIP_SIZE * 0.4f, TIP_SIZE * 0.4f)];
    enemy.physicsBody.affectedByGravity = NO;
    enemy.physicsBody.velocity = CGVectorMake(0, -ENEMY_SPEED - _timeSinceStart * 3);
    enemy.physicsBody.categoryBitMask = enemyCategory;
    enemy.physicsBody.contactTestBitMask = boxCategory | worldCategory;
    enemy.physicsBody.collisionBitMask = 0;
    enemy.physicsBody.usesPreciseCollisionDetection = YES;
}

- (void)_attack:(SKNode *)enemy {
    NSString *sparkPath = [[NSBundle mainBundle] pathForResource:@"spark" ofType:@"sks"];
    SKEmitterNode *spark = [NSKeyedUnarchiver unarchiveObjectWithFile:sparkPath];
    spark.position = enemy.position;
    spark.xScale = spark.yScale = 0.2f;
    [self addChild:spark];
    
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3f];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[fadeOut, remove]];
    [spark runAction:sequence];

    [enemy removeFromParent];
    _enemies--;
    
    [self _score:1 * _timeSinceStart];
}

- (void)_miss:(SKNode *)box {

    NSString *firePath = [[NSBundle mainBundle] pathForResource:@"fire" ofType:@"sks"];
    SKEmitterNode *fire = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
    fire.position = box.position;
    fire.xScale = fire.yScale = 0.7f;
    [self addChild:fire];

    SKAction *fadeOut = [SKAction fadeOutWithDuration:3.0f];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[fadeOut, remove]];
    [fire runAction:sequence];

    [box removeFromParent];
    _boxes--;
    
    if (_boxes < 1) {
        SJGameOverScene *goScene = [SJGameOverScene sceneWithSize:self.size];
        SKTransition *transition = [SKTransition fadeWithDuration:3.0f];
        [self.view presentScene:goScene transition:transition];
    }
}

- (void)_score:(int)score {
    _score += score;
    SKLabelNode *scoreLabel = (SKLabelNode *)[self childNodeWithName:SCORE_NAME];
    scoreLabel.text = [NSString stringWithFormat:@"%05d", _score];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint locaiton = [touch locationInNode:self];
    SKNode *nodeAtPoint = [self nodeAtPoint:locaiton];
    if (nodeAtPoint.name == HERO_NAME) {
        SJHeroNode *hero = (SJHeroNode *)nodeAtPoint;
        [hero attack];
        for (SKNode *node in [self nodesAtPoint:locaiton]) {
            if (node.name == ENEMY_NAME) {
                [self _attack:node];
            }
        }
    } else {
        SJHeroNode *hero = (SJHeroNode *)[self childNodeWithName:HERO_NAME];
        CGFloat x = locaiton.x;
        CGFloat diff = abs(hero.position.x - x);
        CGFloat duration = HERO_SPEED * diff / self.frame.size.width;
        SKAction *move = [SKAction moveToX:x duration:duration];
        [hero removeAllActions];
        //[hero stop];
        [hero walk];
        [hero runAction:move completion:^{
            [hero stop];
        }];
    }
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
    
    if ((firstBody.categoryBitMask & heroCategory) != 0) {
        if ((secondBody.categoryBitMask & enemyCategory) != 0) {
            SJHeroNode *hero = (SJHeroNode *)firstBody.node;
            if (hero.state == SJHeroStateAttack) {
                [self _attack:secondBody.node];
            }
        }
    } else if ((firstBody.categoryBitMask & enemyCategory) != 0) {
        if ((secondBody.categoryBitMask & worldCategory) != 0) {
            [firstBody.node removeFromParent];
            _enemies--;
        } else if ((secondBody.categoryBitMask & boxCategory) != 0) {
            [firstBody.node removeFromParent];
            _enemies--;
            [self _miss:secondBody.node];
        }
    }
}

@end
