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
    GLKMatrix4 rotationMatrix = GLKMatrix4Multiply(GLKMatrix4MakeXRotation(-M_PI/2), GLKMatrix4MakeZRotation(M_PI/2));
    rotationMatrix = GLKMatrix4Multiply(GLKMatrix4MakeYRotation(zrotation), rotationMatrix);
    rotationMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(0, 0, -100), rotationMatrix);
    
    effect.transform.modelviewMatrix = rotationMatrix;
    
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
        [model calculateFrameVerticesForFrame:arc4random()%100];
    }
    
}

@end


