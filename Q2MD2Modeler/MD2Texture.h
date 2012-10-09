//
//  MD2Texture.h
//  Q2MD2Modeler
//
//  Created by Tanoy Sinha on 10/9/12.
//  Copyright (c) 2012 Tanoy Sinha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MD2Helper.h"

@interface MD2Texture : NSObject {
    pcx_header_t        header;
    unsigned int        name;
}

@property (readonly) unsigned int   name;

@end
