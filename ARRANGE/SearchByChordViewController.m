//
//  SearchByChordViewController.m
//  ARRANGE
//
//  Created by Asad Khan on 28/07/2016.
//  Copyright © 2016 Test. All rights reserved.
//

#import "SearchByChordViewController.h"
#import "PickedUpScaleViewController.h"
#import "AppDelegate.h"

@interface SearchByChordViewController (){
    NSArray *_picker1Data;
    NSArray *_picker2Data;
    
    NSString *picker1Selection;
    NSString *picker2Selection;
}

@end

@implementation SearchByChordViewController
AppDelegate *appDelegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _picker1Data = @[@"C", @"C#/Db", @"D", @"D#/Eb", @"E", @"F", @"F#/Gb", @"G", @"G#/Ab", @"A", @"A#/Bb", @"B"];
    _picker2Data = @[@"Maj", @"Min", @"Aug"];
    self.pickerView1Keys.delegate = self;
    self.pickerView1Keys.dataSource = self;
    self.pickerView2TypeChord.delegate = self;
    self.pickerView2TypeChord.dataSource = self;
    
    [self pickerView:self.pickerView1Keys didSelectRow:0 inComponent:1];
    [self pickerView:self.pickerView2TypeChord didSelectRow:0 inComponent:1];//incase the user doesnt selects it we go with the default value.
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        return _picker1Data[row];
    }else{
        return _picker2Data[row];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        picker1Selection = _picker1Data[row];
    }else{
        picker2Selection = _picker2Data[row];
    }
    
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        return [_picker1Data count];
    }else{
        return [_picker2Data count];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSMutableArray*)searchScalesForTheChordAndKeysSelected: (NSString*) chordPlusKey{
    NSArray *namesArray = [appDelegate allNodesNamesFromTree:appDelegate.treeRoot atDepth:3];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self CONTAINS[cd] %@", chordPlusKey];
    NSMutableArray *filteredArray = (NSMutableArray*)[namesArray filteredArrayUsingPredicate:predicate];
    
    NSMutableArray *myParentNamesArray = [appDelegate allParentsNamesFromTree:appDelegate.treeRoot atDepth:3 AndNodeName:filteredArray];
    NSSet *myFilteredSet = [[NSSet alloc] init];
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:myParentNamesArray];
    [myFilteredSet setByAddingObjectsFromArray:myParentNamesArray];
    NSMutableArray *myParentFilteredNamesArray = [NSMutableArray arrayWithArray:[orderedSet array]];
    NSLog(@"Just a print statement");
    return myParentFilteredNamesArray;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"pickedUp"]){
        PickedUpScaleViewController *controller = (PickedUpScaleViewController *)segue.destinationViewController;
        controller.pickedUpChord = [NSString stringWithFormat:@"%@%@", picker1Selection, picker2Selection];
        controller.pickerData =
        [self searchScalesForTheChordAndKeysSelected:controller.pickedUpChord];
    }
    
}


@end
