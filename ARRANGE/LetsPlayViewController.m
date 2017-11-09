//
//  LetsPlayViewController.m
//  ARRANGE
//
//  Created by Asad Khan on 28/07/2016.
//  Copyright © 2016 Test. All rights reserved.
//

#import "LetsPlayViewController.h"
#import "AppDelegate.h"
@interface LetsPlayViewController (){
    NSArray *_pickerData;
    NSArray *_grandChildren;
    NSMutableArray *buttonsArray;

}
- (void)fetchTreeElementsForChildren:(NSString *)childNodeName;
@end

@implementation LetsPlayViewController

AppDelegate *appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.comingPickerData != nil) {
        _pickerData = self.comingPickerData;
        //NSInteger found = [_pickerData indexOfObject:_treeRootSelected];
        //[self.scaleSelectorPickerView selectedRowInComponent:found];
        //[self pickerView:self.scaleSelectorPickerView didSelectRow:found inComponent:1];//if data is coming from chords select the appropriate row in pickerview
        
    }else{
        _pickerData = [appDelegate allNodesNamesFromTree:appDelegate.treeRoot atDepth:2 AndTreeName:_treeRootSelected];
    }
    
    self.scaleSelectorPickerView.delegate = self;
    self.scaleSelectorPickerView.dataSource = self;
    [self fetchAllButtonsInAnArray];
    [self mapSoundsToButtons];
    [self fetchTreeElementsForChildren:[_pickerData objectAtIndex:0]];//Or else the data will be null
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)fetchAllButtonsInAnArray{
    NSArray *viewArray = [self.view subviews];
    buttonsArray = [[NSMutableArray alloc]init];
    int i = 1;
    for (UIButton *buttonView in viewArray) {
        if ([buttonView isKindOfClass:[UIButton class]]) {
            if ([buttonView.titleLabel.text isEqualToString:@"Go back"]) {
                //Do Nothing
            }else{
                buttonView.tag = i;
                [buttonsArray addObject:buttonView];
                NSLog(@"value of i is %d", i);
                i++;
            }
        }
    }
}

- (void)mapSoundsToButtons{
    for (int i=0; i<[buttonsArray count]; i++) {
        
        UIButton *button = (UIButton *)[buttonsArray objectAtIndex:i];

            [button addTarget:self
                       action:@selector(buttonTapped:)
             forControlEvents:UIControlEventTouchUpInside];
    }
}


- (void)fetchTreeElementsForChildren:(NSString *)childNodeName{
    _grandChildren = [appDelegate allNodesNamesFromTree:appDelegate.treeRoot atDepth:3 AndTreeName:childNodeName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    return  _pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *selectedElement = _pickerData[row];
    [self fetchTreeElementsForChildren:selectedElement];
    if (_grandChildren.count == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"No Sounds found for selection" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)buttonTapped:(id)sender {
    UIButton *btn = (UIButton*)sender;
    
    
    NSString *fileNameToPlay = [_grandChildren objectAtIndex:btn.tag-1];//Tag value is +1
    fileNameToPlay = [NSString stringWithFormat:@"%@.wav", fileNameToPlay];
    NSURL *audioURL = [[NSBundle mainBundle] URLForResource:fileNameToPlay.stringByDeletingPathExtension withExtension:fileNameToPlay.pathExtension];
    NSData *audioData = [NSData dataWithContentsOfURL:audioURL];
    NSError *error = nil;
    // assing the audioplayer to a property so ARC won't release it immediately
    _audioplayer = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
    _audioplayer.delegate = self;
    [self.audioplayer play];
}
@end
