//
//  Q2SceneController.m
//  Q2MD2Modeler
//
//  Created by Tanoy Sinha on 10/3/12.
//  Copyright (c) 2012 Tanoy Sinha. All rights reserved.
//

#import "Q2SceneController.h"

@interface Q2SceneController ()

@end

@implementation Q2SceneController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
