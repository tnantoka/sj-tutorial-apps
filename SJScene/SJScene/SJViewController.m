//
//  SJViewController.m
//  SJScene
//
//  Created by Tatsuya Tobioka on 2013/09/25.
//  Copyright (c) 2013年 tnantoka. All rights reserved.
//

#import "SJViewController.h"

#import "SJFirstScene.h"

#import <SpriteKit/SpriteKit.h>

@interface SJViewController ()

@end

@implementation SJViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    SKView *skView = [[SKView alloc] initWithFrame:applicationFrame];
    self.view = skView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    SKView *skView = (SKView *)self.view;
    skView.showsDrawCount = YES;
    skView.showsNodeCount = YES;
    skView.showsFPS = YES;
    
    SKScene *scene = [SJFirstScene sceneWithSize:self.view.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.scaleMode = SKSceneScaleModeAspectFit;
    scene.scaleMode = SKSceneScaleModeFill;
    scene.scaleMode = SKSceneScaleModeResizeFill;
    [skView presentScene:scene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
