//
//  ViewController.h
//  ARRANGE
//
//  Created by Test on 21/02/2015.
//  Copyright (c) 2015 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateNewProgression.h"

@interface ViewController : UIViewController <CreateNewProgressionDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UILabel *IbifindStatus;


@end

