//
//  SearchByChordViewController.h
//  ARRANGE
//
//  Created by Asad Khan on 28/07/2016.
//  Copyright © 2016 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchByChordViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView1Keys;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView2TypeChord;

@end
