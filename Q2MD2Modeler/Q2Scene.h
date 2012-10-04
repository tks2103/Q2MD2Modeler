//
//  Q2Scene.h
//  Q2MD2Modeler
//
//  Created by Tanoy Sinha on 10/3/12.
//  Copyright (c) 2012 Tanoy Sinha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Q2Sprite.h"

@interface Q2Scene : NSObject {
    Q2Sprite *sprite;
}
-(void) update;
-(void) render;
@end
