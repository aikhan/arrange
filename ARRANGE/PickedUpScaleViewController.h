//
//  PickedUpScaleViewController.h
//  ARRANGE
//
//  Created by Asad Khan on 28/07/2016.
//  Copyright © 2016 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickedUpScaleViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *pickedUpLabel;
@property (weak, nonatomic) NSString *pickedUpChord;
@property (strong, nonatomic) NSArray *pickerData;

@end
