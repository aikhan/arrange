//
//  AppDelegate.h
//  ARRANGE
//
//  Created by Test on 21/02/2015.
//  Copyright (c) 2015 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef __attribute__((NSObject)) CFTreeRef TreeRoot;


@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) TreeRoot treeRoot;

-(NSMutableArray*)allNodesFromTree:(CFTreeRef)node atDepth:(int)depth;
-(NSMutableArray*)allNodesNamesFromTree:(CFTreeRef)node atDepth:(int)depth;
-(NSMutableArray*)allNodesNamesFromTree:(CFTreeRef)node atDepth:(int)depth AndTreeName:(NSString *)treeName;
-(NSMutableArray*)allParentsNamesFromTree:(CFTreeRef)node atDepth:(int)depth AndNodeName:(NSMutableArray *)nodeNames;
@end

