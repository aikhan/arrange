//
//  CreateNewProgression.m
//  ARRANGE
//
//  Created by Test on 16/04/2015.
//  Copyright (c) 2015 Test. All rights reserved.
//

#import "CreateNewProgression.h"
#import "AppDelegate.h"
#import "LetsPlayViewController.h"

@interface CreateNewProgression (){
    NSArray *_pickerData;
}

@end

@implementation CreateNewProgression
@synthesize delegate;

AppDelegate *appDelegate;
NSString *selectedValue;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"dchjbdcjhadbcjadhcb");
    [delegate dataFromController:@"This data is from the second view controller."];
    
    
    
    
   // _pickerData = [appDelegate allNodesFromTree:appDelegate.treeRoot atDepth:1];
    _pickerData = [appDelegate allNodesNamesFromTree:appDelegate.treeRoot atDepth:1];
    
    self.selectScalePickerView.delegate = self;
    self.selectScalePickerView.dataSource = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"letsPlay"]){
        LetsPlayViewController *controller = (LetsPlayViewController *)segue.destinationViewController;
        controller.treeRootSelected = selectedValue;
    }
}


// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    selectedValue = _pickerData[row];
    return selectedValue;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

@end
