//
//  Q2Sprite.m
//  Q2MD2Modeler
//
//  Created by Tanoy Sinha on 10/3/12.
//  Copyright (c) 2012 Tanoy Sinha. All rights reserved.
//

#import "Q2Sprite.h"

@implementation Q2Sprite

- (GLKVector4 *)vertexColors {
    if (vertexColorData == nil)
        vertexColorData = [NSMutableData dataWithLength:sizeof(GLKVector4)*model.header.num_triangles*3];
    return [vertexColorData mutableBytes];
}

-(id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

-(id)initWithFile:(NSString *)fileName {
    self = [super init];
    if (self) {
        currentFrame = 0;
        interp = 0.0;
        model = [[MD2Model alloc] initWithFile:fileName];
        [model calculateFrameVerticesForFrame:40];
        for (int i =0; i < model.header.num_triangles; i++) {
            self.vertexColors[i*3] = GLKVector4Make(1, 0, 0, 1);
            self.vertexColors[i*3+1] = GLKVector4Make(0, 1, 0, 1);
            self.vertexColors[i*3+2] = GLKVector4Make(0, 0, 1, 1);
        }

    }
    return self;
}

-(void) render {
    GLKBaseEffect *effect = [[GLKBaseEffect alloc] init];
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    effect.transform.projectionMatrix = GLKMatrix4MakePerspective(45.0f, 2.0f/3.0f, 10.0f, 200.0f);
    
    GLKMatrix4 modelviewMatrix = GLKMatrix4Multiply(GLKMatrix4MakeXRotation(-M_PI/2), GLKMatrix4MakeZRotation(-M_PI/2));
    //modelviewMatrix = GLKMatrix4Multiply(GLKMatrix4MakeYRotation(zrotation), modelviewMatrix);
    modelviewMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(0, 0, -100), modelviewMatrix);
    effect.transform.modelviewMatrix = modelviewMatrix;
    
    [effect prepareToDraw];
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, [model calculatedFrameVertices]);
    
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, self.vertexColors);
    
    glDrawArrays(GL_TRIANGLES, 0, model.header.num_triangles*3);
    glDisableVertexAttribArray(GLKVertexAttribColor);
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisable(GL_BLEND);
}

-(void) update {
    
    xrotation += M_PI / 96;
    if (xrotation >= 2 * M_PI) {
        xrotation -= 2 * M_PI;
    }
    zrotation += M_PI / 72;
    if (zrotation >= 2 * M_PI) {
        zrotation -= 2 * M_PI;
    }
    interp += 0.2;
    if (interp >= 1.0) {
        interp = 0.0;
        currentFrame ++;
    }
    if (currentFrame > model.header.num_frames-1) {
        currentFrame = 0;
    }
    [model animateFrameVerticesForFrame:currentFrame withInterpolation:interp];
    
}

@end


