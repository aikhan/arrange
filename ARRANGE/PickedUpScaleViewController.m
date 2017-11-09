//
//  PickedUpScaleViewController.m
//  ARRANGE
//
//  Created by Asad Khan on 28/07/2016.
//  Copyright © 2016 Test. All rights reserved.
//

#import "PickedUpScaleViewController.h"
#import "LetsPlayViewController.h"

@interface PickedUpScaleViewController (){
    
    NSString *selectedValue;
}

@end

@implementation PickedUpScaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _pickerData = @[@"Cmin", @"C#/Dbmin", @"Dmin", @"D#/Ebmin", @"Emin", @"Fmin", @"F#/Gbmin", @"Gmin", @"G#/Abmin", @"Amin", @"A#/Bbmin", @"Bmin", @"Cmaj", @"C#/Dbmaj", @"Dmaj", @"D#/Ebmaj", @"Emaj", @"Fmaj", @"F#/Gbmaj", @"Gmaj", @"G#/Abmaj", @"Amaj", @"A#/Bbmaj", @"Bmaj"];
    self.pickedUpLabel.text = self.pickedUpChord;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
        return _pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.pickedUpLabel.text = _pickerData[row];
    selectedValue = _pickerData[row];
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

        return [_pickerData count];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"letsPlayFromChord"]){
        LetsPlayViewController *controller = (LetsPlayViewController *)segue.destinationViewController;
        controller.treeRootSelected = self.pickedUpLabel.text;
        controller.comingPickerData = _pickerData;
    }
}


@end
