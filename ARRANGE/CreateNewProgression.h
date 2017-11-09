//
//  CreateNewProgression.h
//  ARRANGE
//
//  Created by Test on 16/04/2015.
//  Copyright (c) 2015 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateNewProgressionDelegate <NSObject>

@required
- (void)dataFromController:(NSString *)data;

@end
@interface CreateNewProgression : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>


@property (weak, nonatomic) IBOutlet UIPickerView *selectScalePickerView;
@property (nonatomic, weak) id<CreateNewProgressionDelegate> delegate;
@end
