//
//  LetsPlayViewController.h
//  ARRANGE
//
//  Created by Asad Khan on 28/07/2016.
//  Copyright © 2016 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface LetsPlayViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *scaleSelectorPickerView;
@property (strong, nonatomic) NSString *treeRootSelected;
@property (nonatomic, strong) AVAudioPlayer *audioplayer;

@property (nonatomic, strong) NSArray *comingPickerData;

- (IBAction)buttonTapped:(id)sender;

@end
