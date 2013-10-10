//
//  SJButtonNode.m
//  SJExample
//
//  Created by Tatsuya Tobioka on 2013/09/29.
//  Copyright (c) 2013年 tnantoka. All rights reserved.
//

#import "SJButtonNode.h"

@implementation SJButtonNode

- (id)initWithFontNamed:(NSString *)fontName {
    if (self = [super initWithFontNamed:fontName]) {
        self.color = [SKColor grayColor];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    if (!self.hidden) {
        _highlighted = highlighted;        
    }
    self.colorBlendFactor = _highlighted ? 0.7f : 0;
}

@end
