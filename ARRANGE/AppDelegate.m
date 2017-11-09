//
//  AppDelegate.m
//  ARRANGE
//
//  Created by Test on 21/02/2015.
//  Copyright (c) 2015 Test. All rights reserved.
//


#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self createTreeDataStruture];
    
    return YES;
}


static CFTreeRef CreateMyTree(CFAllocatorRef allocator, NSString *name) {
    
    NSString *info;
    CFTreeContext ctx;
    
    NSString *treeString = [[NSString alloc] initWithString:name];
    info = treeString;
    
    ctx.version = 0;
    ctx.info = (__bridge void *)(info);
    ctx.retain = CFRetain;
    ctx.release = CFRelease;
    ctx.copyDescription = NULL;
    
    return CFTreeCreate(allocator, &ctx);
}
static CFTreeRef CreateChildWithName(CFTreeRef tree, NSString *name)
{
    CFTreeRef child;
    CFTreeContext ctx;
    child = CreateMyTree(CFGetAllocator(tree), name);
    CFTreeGetContext(child, &ctx);
    ctx.info = (__bridge void *)(name);
    CFTreeAppendChild(tree, child);
    return child;
}

-(void)allNodesFromTree:(CFTreeRef)node currentDepth:(int)currDepth atDepth:(int)depth nodesFound:(NSMutableArray*)nodes AndWithName:(NSMutableArray*)names
{
    bool atTargetDepth = depth -1 == currDepth;
    
    CFTreeRef curChild = CFTreeGetFirstChild(node);
    for (; curChild; curChild = CFTreeGetNextSibling(curChild)) {
        CFTreeContext ctx;
        CFTreeGetContext(curChild, &ctx);
        NSLog(@"Node Name : %@",ctx.info);
        if(atTargetDepth) //stop recursion if target depth reached
        {
            [nodes addObject:(__bridge id)(curChild)];
            [names addObject:(__bridge id)(ctx.info)];
        }
        else [self allNodesFromTree:curChild currentDepth:currDepth+1 atDepth:depth nodesFound:nodes AndWithName:names];
    }
}
-(void)allNodesFromTree:(CFTreeRef)node currentDepth:(int)currDepth atDepth:(int)depth withName:(NSMutableArray*)names forTree:(NSString*)treeName
{
    bool atTargetDepth = depth -1 == currDepth;
    
    CFTreeRef curChild = CFTreeGetFirstChild(node);
    for (; curChild; curChild = CFTreeGetNextSibling(curChild)) {
        CFTreeContext ctx;
        CFTreeGetContext(curChild, &ctx);
        
        if(atTargetDepth)//stop recursion if target depth reached
        {
            CFTreeRef parent = CFTreeGetParent(curChild);
            CFTreeContext parentCtx;
            CFTreeGetContext(parent, &parentCtx);
            if (parentCtx.info == (__bridge void *)(treeName)) {
                NSLog(@"Added Node with Name : %@",ctx.info);
                [names addObject:(__bridge id)(ctx.info)];
            }
        }
        else [self allNodesFromTree:curChild currentDepth:currDepth+1 atDepth:depth withName:names forTree:treeName];
    }
}
-(void)allNodesFromTree:(CFTreeRef)node currentDepth:(int)currDepth atDepth:(int)depth withName:(NSMutableArray*)names forTreeNames:(NSMutableArray*)treeNames
{
    bool atTargetDepth = depth -1 == currDepth;
    
    CFTreeRef curChild = CFTreeGetFirstChild(node);
    for (; curChild; curChild = CFTreeGetNextSibling(curChild)) {
        CFTreeContext ctx;
        CFTreeGetContext(curChild, &ctx);
        
        if(atTargetDepth)//stop recursion if target depth reached
        {
            
            CFTreeRef parent = CFTreeGetParent(curChild);
            CFTreeContext parentCtx;
            CFTreeGetContext(parent, &parentCtx);
            for (int i=0; i< [treeNames count]; i++) {
                if (ctx.info == (__bridge void *)([treeNames objectAtIndex:i])) {
                    NSLog(@"Added Parent with Name : %@",parentCtx.info);
                    [names addObject:(__bridge id)(parentCtx.info)];
                }
            }
        }
        else [self allNodesFromTree:curChild currentDepth:currDepth+1 atDepth:depth withName:names forTreeNames:treeNames];
    }
}

-(NSMutableArray*)allNodesFromTree:(CFTreeRef)node atDepth:(int)depth
{
    NSMutableArray *nodesArray = [[NSMutableArray alloc]init];
    NSMutableArray *namesArray = [[NSMutableArray alloc]init];
    [self allNodesFromTree:node currentDepth:0 atDepth:depth nodesFound:nodesArray AndWithName:namesArray];
    return nodesArray;
}

-(NSMutableArray*)allNodesNamesFromTree:(CFTreeRef)node atDepth:(int)depth
{
    NSMutableArray *nodesArray = [[NSMutableArray alloc]init];
    NSMutableArray *namesArray = [[NSMutableArray alloc]init];
    [self allNodesFromTree:node currentDepth:0 atDepth:depth nodesFound:nodesArray AndWithName:namesArray];
    return namesArray;
}

-(NSMutableArray*)allNodesNamesFromTree:(CFTreeRef)node atDepth:(int)depth AndTreeName:(NSString *)treeName
{
    NSMutableArray *namesArray = [[NSMutableArray alloc]init];
    [self allNodesFromTree:node currentDepth:0 atDepth:depth withName:namesArray forTree:treeName];
    return namesArray;
}
-(NSMutableArray*)allParentsNamesFromTree:(CFTreeRef)node atDepth:(int)depth AndNodeName:(NSMutableArray *)nodeNames
{
    NSMutableArray *namesArray = [[NSMutableArray alloc]init];
    [self allNodesFromTree:node currentDepth:0 atDepth:depth withName:namesArray forTreeNames:nodeNames];
    return namesArray;
}
//
//-(NSString*)parentNameForChild:(NSString*)childName{
//    CFTreeGetParent(<#CFTreeRef tree#>)
//}

- (void)createTreeDataStruture{
    
    
    _treeRoot = CreateMyTree(kCFAllocatorDefault, @"Root");
    CFTreeRef majorScales = CreateChildWithName(_treeRoot, @"Major Scales");
    CFTreeRef minorScales = CreateChildWithName(_treeRoot, @"Minor Scales");
    
    
    //Minor Scales Tree Elements
    CFTreeRef A_min = CreateChildWithName(minorScales, @"A#min");
    CreateChildWithName(A_min, @"1.A#min.SecondInv.Chord");
    CreateChildWithName(A_min, @"2.Cdim.SecondInv.Chord");
    CreateChildWithName(A_min, @"3.C#maj.SecondInv.Chord");
    CreateChildWithName(A_min, @"4.D#min.SecondInv.Chord");
    CreateChildWithName(A_min, @"5.Fmin.SecondInv.Chord");
    CreateChildWithName(A_min, @"6.F#maj.SecondInv.Chord");
    CreateChildWithName(A_min, @"7.G#maj.SecondInv.Chord");
    CreateChildWithName(A_min, @"8.A#min.FirstInv.Chord");
    CreateChildWithName(A_min, @"9.Cdim.FirstInv.Chord");
    CreateChildWithName(A_min, @"10.C#maj.FirstInv.Chord");
    CreateChildWithName(A_min, @"11.D#min.FirstInv.Chord");
    CreateChildWithName(A_min, @"12.Fmin.FirstInv.Chord");
    CreateChildWithName(A_min, @"13.F#maj.FirstInv.Chord");
    CreateChildWithName(A_min, @"14.G#maj.FirstInv.Chord");
    CreateChildWithName(A_min, @"15.A#min.basic.Chord");
    CreateChildWithName(A_min, @"16.Cdim.basic.Chord");
    CreateChildWithName(A_min, @"17.C#maj.basic.Chord");
    CreateChildWithName(A_min, @"18.D#min.basic.Chord");
    CreateChildWithName(A_min, @"19.Fmin.basic.Chord");
    CreateChildWithName(A_min, @"20.F#maj.basic.Chord");
    CreateChildWithName(A_min, @"21.G#maj.basic.Chord");
    
    CFTreeRef Amin = CreateChildWithName(minorScales, @"Amin");
    CreateChildWithName(Amin, @"1.Amin.SecondInv.Chord");
    CreateChildWithName(Amin, @"2.Bdim.SecondInv.Chord");
    CreateChildWithName(Amin, @"3.Cmaj.SecondInv.Chord");
    CreateChildWithName(Amin, @"4.Dmin.SecondInv.Chord");
    CreateChildWithName(Amin, @"5.Emin.SecondInv.Chord");
    CreateChildWithName(Amin, @"6.Fmaj.SecondInv.Chord");
    CreateChildWithName(Amin, @"7.Gmaj.SecondInv.Chord");
    CreateChildWithName(Amin, @"8.Amin.FirstInv.Chord");
    CreateChildWithName(Amin, @"9.Bdim.FirstInv.Chord");
    CreateChildWithName(Amin, @"10.Cmaj.FirstInv.Chord");
    CreateChildWithName(Amin, @"11.Dmin.FirstInv.Chord");
    CreateChildWithName(Amin, @"12.Emin.FirstInv.Chord");
    CreateChildWithName(Amin, @"13.Fmaj.FirstInv.Chord");
    CreateChildWithName(Amin, @"15.Amin.basic.Chord");
    CreateChildWithName(Amin, @"15.Gmaj.FirstInv.Chord");
    CreateChildWithName(Amin, @"16.Bdim.basic.Chord");
    CreateChildWithName(Amin, @"17.Cmaj.basic.Chord");
    CreateChildWithName(Amin, @"18.Dmin.basic.Chord");
    CreateChildWithName(Amin, @"19.Emin.basic.Chord");
    CreateChildWithName(Amin, @"20.Fmaj.basic.Chord");
    CreateChildWithName(Amin, @"21.Gmaj.basic.Chord");
    
    
    CFTreeRef Bmin = CreateChildWithName(minorScales, @"Bmin");
    CreateChildWithName(Bmin, @"1.Bmin.SecondInv.Chord");
    CreateChildWithName(Bmin, @"2.C#dim.SecondInv.Chord");
    CreateChildWithName(Bmin, @"3.Dmaj.SecondInv.Chord");
    CreateChildWithName(Bmin, @"4.Emin.SecondInv.Chord");
    CreateChildWithName(Bmin, @"5.F#min.SecondInv.Chord");
    CreateChildWithName(Bmin, @"6.Gmaj.SecondInv.Chord");
    CreateChildWithName(Bmin, @"7.Amaj.SecondInv.Chord");
    CreateChildWithName(Bmin, @"8.Bmin.FirstInv.Chord");
    CreateChildWithName(Bmin, @"9.C#dim.FirstInv.Chord");
    CreateChildWithName(Bmin, @"10.Dmaj.FirstInv.Chord");
    CreateChildWithName(Bmin, @"11.Emin.FirstInv.Chord");
    CreateChildWithName(Bmin, @"12.F#min.FirstInv.Chord");
    CreateChildWithName(Bmin, @"13.Gmaj.FirstInv.Chord");
    CreateChildWithName(Bmin, @"14.Amaj.FirstInv.Chord");
    CreateChildWithName(Bmin, @"15.Bmin.basic.Chord");
    CreateChildWithName(Bmin, @"16.C#dim.basic.Chord");
    CreateChildWithName(Bmin, @"17.Dmaj.basic.Chord");
    CreateChildWithName(Bmin, @"18.Emin.basic.Chord");
    CreateChildWithName(Bmin, @"19.F#min.basic.Chord");
    CreateChildWithName(Bmin, @"20.Gmaj.basic.Chord");
    CreateChildWithName(Bmin, @"21.Amaj.basic.Chord");

    
    CFTreeRef C_min = CreateChildWithName(minorScales, @"C_min");
    CreateChildWithName(C_min, @"1.C#min.SecondInv.Chord");
    CreateChildWithName(C_min, @"2.D#dim.SecondInv.Chord");
    CreateChildWithName(C_min, @"3.Emaj.SecondInv.Chord");
    CreateChildWithName(C_min, @"4.F#min.SecondInv.Chord");
    CreateChildWithName(C_min, @"5.G#min.SecondInv.Chord");
    CreateChildWithName(C_min, @"6.Amaj.SecondInv.Chord");
    CreateChildWithName(C_min, @"7.Bmaj.SecondInv.Chord");
    CreateChildWithName(C_min, @"8.C#min.FirstInv.Chord");
    CreateChildWithName(C_min, @"9.D#dim.FirstInv.Chord");
    CreateChildWithName(C_min, @"10.Emaj.FirstInv.Chord");
    CreateChildWithName(C_min, @"11.F#min.FirstInv.Chord");
    CreateChildWithName(C_min, @"12.G#min.FirstInv.Chord");
    CreateChildWithName(C_min, @"13.Amaj.FirstInv.Chord");
    CreateChildWithName(C_min, @"14.Bmaj.FirstInv.Chord");
    CreateChildWithName(C_min, @"15.C#min.basic.Chord");
    CreateChildWithName(C_min, @"16.D#dim.basic.Chord");
    CreateChildWithName(C_min, @"17.Emaj.basic.Chord");
    CreateChildWithName(C_min, @"18.F#min.basic.Chord");
    CreateChildWithName(C_min, @"19.G#min.basic.Chord");
    CreateChildWithName(C_min, @"20.Amaj.basic.Chord");
    CreateChildWithName(C_min, @"21.Bmaj.basic.Chord");
    
    CFTreeRef Cmin = CreateChildWithName(minorScales, @"Cmin");
    CreateChildWithName(Cmin, @"1.Cmin.SecondInv.Chord");
    CreateChildWithName(Cmin, @"2.Ddim.SecondInv.Chord");
    CreateChildWithName(Cmin, @"3.D#maj.SecondInv.Chord");
    CreateChildWithName(Cmin, @"4.Fmin.SecondInv.Chord");
    CreateChildWithName(Cmin, @"5.Gmin.SecondInv.Chord");
    CreateChildWithName(Cmin, @"6.G#maj.SecondInv.Chord");
    CreateChildWithName(Cmin, @"7.A#maj.SecondInv.Chord");
    CreateChildWithName(Cmin, @"8.Cmin.FirstInv.Chord");
    CreateChildWithName(Cmin, @"9.Ddim.FirstInv.Chord");
    CreateChildWithName(Cmin, @"10.D#maj.FirstInv.Chord");
    CreateChildWithName(Cmin, @"11.Fmin.FirstInv.Chord");
    CreateChildWithName(Cmin, @"12.Gmin.FirstInv.Chord");
    CreateChildWithName(Cmin, @"13.G#maj.FirstInv.Chord");
    CreateChildWithName(Cmin, @"14.A#maj.FirstInv.Chord");
    CreateChildWithName(Cmin, @"15.Cmin.basic.Chord");
    CreateChildWithName(Cmin, @"16.Ddim.basic.Chord");
    CreateChildWithName(Cmin, @"17.D#maj.basic.Chord");
    CreateChildWithName(Cmin, @"18.Fmin.basic.Chord");
    CreateChildWithName(Cmin, @"19.Gmin.basic.Chord");
    CreateChildWithName(Cmin, @"20.G#maj.basic.Chord");
    CreateChildWithName(Cmin, @"21.A#maj.basic.Chord");
    
    CFTreeRef D_min = CreateChildWithName(minorScales, @"D_min");
    CreateChildWithName(D_min, @"1.D#min.SecondInv.Chord");
    CreateChildWithName(D_min, @"2.Fdim.SecondInv.Chord");
    CreateChildWithName(D_min, @"3.F#maj.SecondInv.Chord");
    CreateChildWithName(D_min, @"4.G#min.SecondInv.Chord");
    CreateChildWithName(D_min, @"5.A#min.SecondInv.Chord");
    CreateChildWithName(D_min, @"6.Bmaj.SecondInv.Chord");
    CreateChildWithName(D_min, @"7.C#maj.SecondInv.Chord");
    CreateChildWithName(D_min, @"8.D#min.FirstInv.Chord");
    CreateChildWithName(D_min, @"9.Fdim.FirstInv.Chord");
    CreateChildWithName(D_min, @"10.F#maj.FirstInv.Chord");
    CreateChildWithName(D_min, @"11.G#min.FirstInv.Chord");
    CreateChildWithName(D_min, @"12.A#min.FirstInv.Chord");
    CreateChildWithName(D_min, @"13.Bmaj.FirstInv.Chord");
    CreateChildWithName(D_min, @"14.C#maj.FirstInv.Chord");
    CreateChildWithName(D_min, @"15.D#min.basic.Chord");
    CreateChildWithName(D_min, @"16.Fdim.basic.Chord");
    CreateChildWithName(D_min, @"17.F#maj.basic.Chord");
    CreateChildWithName(D_min, @"18.G#min.basic.Chord");
    CreateChildWithName(D_min, @"19.A#min.basic.Chord");
    CreateChildWithName(D_min, @"20.Bmaj.basic.Chord");
    CreateChildWithName(D_min, @"21.C#maj.basic.Chord");
    
    
    CFTreeRef Dmin = CreateChildWithName(minorScales, @"Dmin");
    CreateChildWithName(Dmin, @"1.Dmin.SecondInv.Chord");
    CreateChildWithName(Dmin, @"2.Edim.SecondInv.Chord");
    CreateChildWithName(Dmin, @"3.Fmaj.SecondInv.Chord");
    CreateChildWithName(Dmin, @"4.Gmin.SecondInv.Chord");
    CreateChildWithName(Dmin, @"5.Amin.SecondInv.Chord");
    CreateChildWithName(Dmin, @"6.A#maj.SecondInv.Chord");
    CreateChildWithName(Dmin, @"7.Cmaj.SecondInv.Chord");
    CreateChildWithName(Dmin, @"8.Dmin.FirstInv.Chord");
    CreateChildWithName(Dmin, @"9.Edim.FirstInv.Chord");
    CreateChildWithName(Dmin, @"10.Fmaj.FirstInv.Chord");
    CreateChildWithName(Dmin, @"11.Gmin.FirstInv.Chord");
    CreateChildWithName(Dmin, @"12.Amin.FirstInv.Chord");
    CreateChildWithName(Dmin, @"13.A#maj.FirstInv.Chord");
    CreateChildWithName(Dmin, @"14.Cmaj.FirstInv.Chord");
    CreateChildWithName(Dmin, @"15.Dmin.basic.Chord");
    CreateChildWithName(Dmin, @"16.Edim.basic.Chord");
    CreateChildWithName(Dmin, @"17.Fmaj.basic.Chord");
    CreateChildWithName(Dmin, @"18.Gmin.basic.Chord");
    CreateChildWithName(Dmin, @"19.Amin.basic.Chord");
    CreateChildWithName(Dmin, @"20.A#maj.basic.Chord");
    CreateChildWithName(Dmin, @"21.Cmaj.basic.Chord");
    
    
    CFTreeRef Emin = CreateChildWithName(minorScales, @"Emin");
    CreateChildWithName(Emin, @"1.Emin.SecondInv.Chord");
    CreateChildWithName(Emin, @"2.F#dim.SecondInv.Chord");
    CreateChildWithName(Emin, @"3.Gmaj.SecondInv.Chord");
    CreateChildWithName(Emin, @"4.Amin.SecondInv.Chord");
    CreateChildWithName(Emin, @"5.Bmin.SecondInv.Chord");
    CreateChildWithName(Emin, @"6.Cmaj.SecondInv.Chord");
    CreateChildWithName(Emin, @"7.Dmaj.SecondInv.Chord");
    CreateChildWithName(Emin, @"8.Emin.FirstInv.Chord");
    CreateChildWithName(Emin, @"9.F#dim.FirstInv.Chord");
    CreateChildWithName(Emin, @"10.Gmaj.FirstInv.Chord");
    CreateChildWithName(Emin, @"11.Amin.FirstInv.Chord");
    CreateChildWithName(Emin, @"12.Bmin.FirstInv.Chord");
    CreateChildWithName(Emin, @"13.Cmaj.FirstInv.Chord");
    CreateChildWithName(Emin, @"14.Dmaj.FirstInv.Chord");
    CreateChildWithName(Emin, @"15.Emin.basic.Chord");
    CreateChildWithName(Emin, @"16.F#dim.basic.Chord");
    CreateChildWithName(Emin, @"17.Gmaj.basic.Chord");
    CreateChildWithName(Emin, @"18.Amin.basic.Chord");
    CreateChildWithName(Emin, @"19.Bmin.basic.Chord");
    CreateChildWithName(Emin, @"20.Cmaj.basic.Chord");
    CreateChildWithName(Emin, @"21.Dmaj.basic.Chord");
    
    CFTreeRef F_min = CreateChildWithName(minorScales, @"F_min");
    CreateChildWithName(F_min, @"1.F#min.SecondInv.Chord");
    CreateChildWithName(F_min, @"2.G#dim.SecondInv.Chord");
    CreateChildWithName(F_min, @"3.Amaj.SecondInv.Chord");
    CreateChildWithName(F_min, @"4.Bmin.SecondInv.Chord");
    CreateChildWithName(F_min, @"5.C#min.SecondInv.Chord");
    CreateChildWithName(F_min, @"6.Dmaj.SecondInv.Chord");
    CreateChildWithName(F_min, @"7.Emaj.SecondInv.Chord");
    CreateChildWithName(F_min, @"8.F#min.FirstInv.Chord");
    CreateChildWithName(F_min, @"9.G#dim.FirstInv.Chord");
    CreateChildWithName(F_min, @"10.Amaj.FirstInv.Chord");
    CreateChildWithName(F_min, @"11.Bmin.FirstInv.Chord");
    CreateChildWithName(F_min, @"12.C#min.FirstInv.Chord");
    CreateChildWithName(F_min, @"13.Dmaj.FirstInv.Chord");
    CreateChildWithName(F_min, @"14.Emaj.FirstInv.Chord");
    CreateChildWithName(F_min, @"15.F#min.basic.Chord");
    CreateChildWithName(F_min, @"16.G#dim.basic.Chord");
    CreateChildWithName(F_min, @"17.Amaj.basic.Chord");
    CreateChildWithName(F_min, @"18.Bmin.basic.Chord");
    CreateChildWithName(F_min, @"19.C#min.basic.Chord");
    CreateChildWithName(F_min, @"20.Dmaj.basic.Chord");
    CreateChildWithName(F_min, @"21.Emaj.basic.Chord");
    
    CFTreeRef Fmin = CreateChildWithName(minorScales, @"Fmin");
    CreateChildWithName(Fmin, @"1.Fmin.SecondInv.Chord");
    CreateChildWithName(Fmin, @"2.Gdim.SecondInv.Chord");
    CreateChildWithName(Fmin, @"3.G#maj.SecondInv.Chord");
    CreateChildWithName(Fmin, @"4.A#min.SecondInv.Chord");
    CreateChildWithName(Fmin, @"5.Cmin.SecondInv.Chord");
    CreateChildWithName(Fmin, @"6.C#maj.SecondInv.Chord");
    CreateChildWithName(Fmin, @"7.D#maj.SecondInv.Chord");
    CreateChildWithName(Fmin, @"8.Fmin.FirstInv.Chord");
    CreateChildWithName(Fmin, @"9.Gdim.FirstInv.Chord");
    CreateChildWithName(Fmin, @"10.G#maj.FirstInv.Chord");
    CreateChildWithName(Fmin, @"11.A#min.FirstInv.Chord");
    CreateChildWithName(Fmin, @"12.Cmin.FirstInv.Chord");
    CreateChildWithName(Fmin, @"13.C#maj.FirstInv.Chord");
    CreateChildWithName(Fmin, @"14.D#maj.FirstInv.Chord");
    CreateChildWithName(Fmin, @"15.Fmin.basic.Chord");
    CreateChildWithName(Fmin, @"16.Gdim.basic.Chord");
    CreateChildWithName(Fmin, @"17.G#maj.basic.Chord");
    CreateChildWithName(Fmin, @"18.A#min.basic.Chord");
    CreateChildWithName(Fmin, @"19.Cmin.basic.Chord");
    CreateChildWithName(Fmin, @"20.C#maj.basic.Chord");
    CreateChildWithName(Fmin, @"21.D#maj.basic.Chord");
    
    
    
    
    CFTreeRef G_min = CreateChildWithName(minorScales, @"G_min");
    CreateChildWithName(G_min, @"1.G#min.SecondInv.Chord");
    CreateChildWithName(G_min, @"2.A#dim.SecondInv.Chord");
    CreateChildWithName(G_min, @"3.Bmaj.SecondInv.Chord");
    CreateChildWithName(G_min, @"4.C#min.SecondInv.Chord");
    CreateChildWithName(G_min, @"5.D#min.SecondInv.Chord");
    CreateChildWithName(G_min, @"6.Emaj.SecondInv.Chord");
    CreateChildWithName(G_min, @"7.F#maj.SecondInv.Chord");
    CreateChildWithName(G_min, @"8.G#min.FirstInv.Chord");
    CreateChildWithName(G_min, @"9.A#dim.FirstInv.Chord");
    CreateChildWithName(G_min, @"10.Bmaj.FirstInv.Chord");
    CreateChildWithName(G_min, @"11.C#min.FirstInv.Chord");
    CreateChildWithName(G_min, @"12.D#min.FirstInv.Chord");
    CreateChildWithName(G_min, @"13.Emaj.FirstInv.Chord");
    CreateChildWithName(G_min, @"14.F#maj.FirstInv.Chord");
    CreateChildWithName(G_min, @"15.G#min.basic.Chord");
    CreateChildWithName(G_min, @"16.A#dim.basic.Chord");
    CreateChildWithName(G_min, @"17.Bmaj.basic.Chord");
    CreateChildWithName(G_min, @"18.C#min.basic.Chord");
    CreateChildWithName(G_min, @"19.D#min.basic.Chord");
    CreateChildWithName(G_min, @"20.Emaj.basic.Chord");
    CreateChildWithName(G_min, @"21.F#maj.basic.Chord");
    
    
    CFTreeRef Gmin = CreateChildWithName(minorScales, @"Gmin");
    CreateChildWithName(Gmin, @"1.Gmin.SecondInv.Chord");
    CreateChildWithName(Gmin, @"2.Adim.SecondInv.Chord");
    CreateChildWithName(Gmin, @"3.A#maj.SecondInv.Chord");
    CreateChildWithName(Gmin, @"4.Cmin.SecondInv.Chord");
    CreateChildWithName(Gmin, @"5.Dmin.SecondInv.Chord");
    CreateChildWithName(Gmin, @"6.D#maj.SecondInv.Chord");
    CreateChildWithName(Gmin, @"7.Fmaj.SecondInv.Chord");
    CreateChildWithName(Gmin, @"8.Gmin.FirstInv.Chord");
    CreateChildWithName(Gmin, @"9.Adim.FirstInv.Chord");
    CreateChildWithName(Gmin, @"10.A#maj.FirstInv.Chord");
    CreateChildWithName(Gmin, @"11.Cmin.FirstInv.Chord");
    CreateChildWithName(Gmin, @"12.Dmin.FirstInv.Chord");
    CreateChildWithName(Gmin, @"13.D#maj.FirstInv.Chord");
    CreateChildWithName(Gmin, @"14.Fmaj.FirstInv.Chord");
    CreateChildWithName(Gmin, @"15.Gmin.basic.Chord");
    CreateChildWithName(Gmin, @"16.Adim.basic.Chord");
    CreateChildWithName(Gmin, @"17.A#maj.basic.Chord");
    CreateChildWithName(Gmin, @"18.Cmin.basic.Chord");
    CreateChildWithName(Gmin, @"19.Dmin.basic.Chord");
    CreateChildWithName(Gmin, @"20.D#maj.basic.Chord");
    CreateChildWithName(Gmin, @"21.Fmaj.basic.Chord");
    
    //Major Scales Tree Elements
    
    CFTreeRef A_maj = CreateChildWithName(majorScales, @"A#maj");
    CreateChildWithName(A_maj, @"1.A#maj.SecondInv.Chord");
    CreateChildWithName(A_maj, @"2.Cmin.SecondInv.Chord");
    CreateChildWithName(A_maj, @"3.Dmin.SecondInv.Chord");
    CreateChildWithName(A_maj, @"4.D#maj.SecondInv.Chord");
    CreateChildWithName(A_maj, @"5.Fmaj.SecondInv.Chord");
    CreateChildWithName(A_maj, @"6.Gmin.SecondInv.Chord");
    CreateChildWithName(A_maj, @"7.Adim.SecondInv.Chord");
    CreateChildWithName(A_maj, @"8.A#maj.FirstInv.Chord");
    CreateChildWithName(A_maj, @"9.Cmin.FirstInv.Chord");
    CreateChildWithName(A_maj, @"10.Dmin.FirstInv.Chord");
    CreateChildWithName(A_maj, @"11.D#maj.FirstInv.Chord");
    CreateChildWithName(A_maj, @"12.Fmaj.FirstInv.Chord");
    CreateChildWithName(A_maj, @"13.Gmin.FirstInv.Chord");
    CreateChildWithName(A_maj, @"14.Adim.FirstInv.Chord");
    CreateChildWithName(A_maj, @"15.A#maj.basic.Chord");
    CreateChildWithName(A_maj, @"16.Cmin.basic.Chord");
    CreateChildWithName(A_maj, @"17.Dmin.basic.Chord");
    CreateChildWithName(A_maj, @"18.D#maj.basic.Chord");
    CreateChildWithName(A_maj, @"19.Fmaj.basic.Chord");
    CreateChildWithName(A_maj, @"20.Gmin.basic.Chord");
    CreateChildWithName(A_maj, @"21.Adim.basic.Chord");
    
    
    CFTreeRef Amaj = CreateChildWithName(majorScales, @"Amaj");
    CreateChildWithName(Amaj, @"1.Amaj.SecondInv.Chord");
    CreateChildWithName(Amaj, @"2.Bmin.SecondInv.Chord");
    CreateChildWithName(Amaj, @"3.C#min.SecondInv.Chord");
    CreateChildWithName(Amaj, @"4.Dmaj.SecondInv.Chord");
    CreateChildWithName(Amaj, @"5.Emaj.SecondInv.Chord");
    CreateChildWithName(Amaj, @"6.F#min.SecondInv.Chord");
    CreateChildWithName(Amaj, @"7.G#dim.SecondInv.Chord");
    CreateChildWithName(Amaj, @"8.Amaj.FirstInv.Chord");
    CreateChildWithName(Amaj, @"9.Bmin.FirstInv.Chord");
    CreateChildWithName(Amaj, @"10.C#min.FirstInv.Chord");
    CreateChildWithName(Amaj, @"11.Dmaj.FirstInv.Chord");
    CreateChildWithName(Amaj, @"12.Emaj.FirstInv.Chord");
    CreateChildWithName(Amaj, @"13.F#min.FirstInv.Chord");
    CreateChildWithName(Amaj, @"14.G#dim.FirstInv.Chord");
    CreateChildWithName(Amaj, @"15.Amaj.basic.Chord");
    CreateChildWithName(Amaj, @"16.Bmin.basic.Chord");
    CreateChildWithName(Amaj, @"17.C#min.basic.Chord");
    CreateChildWithName(Amaj, @"18.Dmaj.basic.Chord");
    CreateChildWithName(Amaj, @"19.Emaj.basic.Chord");
    CreateChildWithName(Amaj, @"20.F#min.basic.Chord");
    CreateChildWithName(Amaj, @"21.G#dim.basic.Chord");
    
    
    CFTreeRef Bmaj = CreateChildWithName(majorScales, @"Bmaj");
    CreateChildWithName(Bmaj, @"1.Bmaj.SecondInv.Chord");
    CreateChildWithName(Bmaj, @"2.C#min.SecondInv.Chord");
    CreateChildWithName(Bmaj, @"3.D#min.SecondInv.Chord");
    CreateChildWithName(Bmaj, @"4.Emaj.SecondInv.Chord");
    CreateChildWithName(Bmaj, @"5.F#maj.SecondInv.Chord");
    CreateChildWithName(Bmaj, @"6.G#min.SecondInv.Chord");
    CreateChildWithName(Bmaj, @"7.A#dim.SecondInv.Chord");
    CreateChildWithName(Bmaj, @"8.Bmaj.FirstInv.Chord");
    CreateChildWithName(Bmaj, @"9.C#min.FirstInv.Chord");
    CreateChildWithName(Bmaj, @"10.D#min.FirstInv.Chord");
    CreateChildWithName(Bmaj, @"11.Emaj.FirstInv.Chord");
    CreateChildWithName(Bmaj, @"12.F#maj.FirstInv.Chord");
    CreateChildWithName(Bmaj, @"13.G#min.FirstInv.Chord");
    CreateChildWithName(Bmaj, @"14.A#dim.FirstInv.Chord");
    CreateChildWithName(Bmaj, @"15.Bmaj.basic.Chord");
    CreateChildWithName(Bmaj, @"16.C#min.basic.Chord");
    CreateChildWithName(Bmaj, @"17.D#min.basic.Chord");
    CreateChildWithName(Bmaj, @"18.Emaj.basic.Chord");
    CreateChildWithName(Bmaj, @"19.F#maj.basic.Chord");
    CreateChildWithName(Bmaj, @"20.G#min.basic.Chord");
    CreateChildWithName(Bmaj, @"21.A#dim.basic.Chord");
    
    
    
    
    CFTreeRef C_maj = CreateChildWithName(majorScales, @"C#maj");
    CreateChildWithName(C_maj, @"1.C#maj.SecondInv.Chord");
    CreateChildWithName(C_maj, @"2.D#min.SecondInv.Chord");
    CreateChildWithName(C_maj, @"3.Fmin.SecondInv.Chord");
    CreateChildWithName(C_maj, @"4.F#maj.SecondInv.Chord");
    CreateChildWithName(C_maj, @"5.G#maj.SecondInv.Chord");
    CreateChildWithName(C_maj, @"6.A#min.SecondInv.Chord");
    CreateChildWithName(C_maj, @"7.Cdim.SecondInv.Chord");
    CreateChildWithName(C_maj, @"8.C#maj.FirstInv.Chord");
    CreateChildWithName(C_maj, @"9.D#min.FirstInv.Chord");
    CreateChildWithName(C_maj, @"10.Fmin.FirstInv.Chord");
    CreateChildWithName(C_maj, @"11.F#maj.FirstInv.Chord");
    CreateChildWithName(C_maj, @"12.G#maj.FirstInv.Chord");
    CreateChildWithName(C_maj, @"13.A#min.FirstInv.Chord");
    CreateChildWithName(C_maj, @"14.Cdim.FirstInv.Chord");
    CreateChildWithName(C_maj, @"15.C#maj.basic.Chord");
    CreateChildWithName(C_maj, @"16.D#min.basic.Chord");
    CreateChildWithName(C_maj, @"17.Fmin.basic.Chord");
    CreateChildWithName(C_maj, @"18.F#maj.basic.Chord");
    CreateChildWithName(C_maj, @"19.G#maj.basic.Chord");
    CreateChildWithName(C_maj, @"20.A#min.basic.Chord");
    CreateChildWithName(C_maj, @"21.Cdim.basic.Chord");
    
    
    CFTreeRef Cmaj = CreateChildWithName(majorScales, @"Cmaj");
    CreateChildWithName(Cmaj, @"1.Cmaj.SecondInv.Chord");
    CreateChildWithName(Cmaj, @"2.Dmin.SecondInv.Chord");
    CreateChildWithName(Cmaj, @"3.Emin.SecondInv.Chord");
    CreateChildWithName(Cmaj, @"4.Fmaj.SecondInv.Chord");
    CreateChildWithName(Cmaj, @"5.Gmaj.SecondInv.Chord");
    CreateChildWithName(Cmaj, @"6.Amin.SecondInv.Chord");
    CreateChildWithName(Cmaj, @"7.Bdim.SecondInv.Chord");
    CreateChildWithName(Cmaj, @"8.Cmaj.FirstInv.Chord");
    CreateChildWithName(Cmaj, @"9.Dmin.FirstInv.Chord");
    CreateChildWithName(Cmaj, @"10.Emin.FirstInv.Chord");
    CreateChildWithName(Cmaj, @"11.Fmaj.FirstInv.Chord");
    CreateChildWithName(Cmaj, @"12.Gmaj.FirstInv.Chord");
    CreateChildWithName(Cmaj, @"13.Amin.FirstInv.Chord");
    CreateChildWithName(Cmaj, @"14.Bdim.FirstInv.Chord");
    CreateChildWithName(Cmaj, @"15.Cmaj.basic.Chord");
    CreateChildWithName(Cmaj, @"16.Dmin.basic.Chord");
    CreateChildWithName(Cmaj, @"17.Emin.basic.Chord");
    CreateChildWithName(Cmaj, @"18.Fmaj.basic.Chord");
    CreateChildWithName(Cmaj, @"19.Gmaj.basic.Chord");
    CreateChildWithName(Cmaj, @"20.Amin.basic.Chord");
    CreateChildWithName(Cmaj, @"21.Bdim.basic.Chord");
    
    
    CFTreeRef D_maj = CreateChildWithName(majorScales, @"D#maj");
    CreateChildWithName(D_maj, @"1.D#maj.SecondInv.Chord");
    CreateChildWithName(D_maj, @"2.Fmin.SecondInv.Chord");
    CreateChildWithName(D_maj, @"3.Gmin.SecondInv.Chord");
    CreateChildWithName(D_maj, @"4.G#maj.SecondInv.Chord");
    CreateChildWithName(D_maj, @"5.A#maj.SecondInv.Chord");
    CreateChildWithName(D_maj, @"6.Cmin.SecondInv.Chord");
    CreateChildWithName(D_maj, @"7.Ddim.SecondInv.Chord");
    CreateChildWithName(D_maj, @"8.D#maj.FirstInv.Chord");
    CreateChildWithName(D_maj, @"9.Fmin.FirstInv.Chord");
    CreateChildWithName(D_maj, @"10.Gmin.FirstInv.Chord");
    CreateChildWithName(D_maj, @"11.G#maj.FirstInv.Chord");
    CreateChildWithName(D_maj, @"12.A#maj.FirstInv.Chord");
    CreateChildWithName(D_maj, @"13.Cmin.FirstInv.Chord");
    CreateChildWithName(D_maj, @"14.Ddim.FirstInv.Chord");
    CreateChildWithName(D_maj, @"15.D#maj.basic.Chord");
    CreateChildWithName(D_maj, @"16.Fmin.basic.Chord");
    CreateChildWithName(D_maj, @"17.Gmin.basic.Chord");
    CreateChildWithName(D_maj, @"18.G#maj.basic.Chord");
    CreateChildWithName(D_maj, @"19.A#maj.basic.Chord");
    CreateChildWithName(D_maj, @"20.Cmin.basic.Chord");
    CreateChildWithName(D_maj, @"21.Ddim.basic.Chord");
    
    CFTreeRef Dmaj = CreateChildWithName(majorScales, @"Dmaj");
    CreateChildWithName(Dmaj, @"1.Dmaj.SecondInv.Chord");
    CreateChildWithName(Dmaj, @"2.Emin.SecondInv.Chord");
    CreateChildWithName(Dmaj, @"3.F#min.SecondInv.Chord");
    CreateChildWithName(Dmaj, @"4.Gmaj.SecondInv.Chord");
    CreateChildWithName(Dmaj, @"5.Amaj.SecondInv.Chord");
    CreateChildWithName(Dmaj, @"6.Bmin.SecondInv.Chord");
    CreateChildWithName(Dmaj, @"7.C#dim.SecondInv.Chord");
    CreateChildWithName(Dmaj, @"8.Dmaj.FirstInv.Chord");
    CreateChildWithName(Dmaj, @"9.Emin.FirstInv.Chord");
    CreateChildWithName(Dmaj, @"10.F#min.FirstInv.Chord");
    CreateChildWithName(Dmaj, @"11.Gmaj.FirstInv.Chord");
    CreateChildWithName(Dmaj, @"12.Amaj.FirstInv.Chord");
    CreateChildWithName(Dmaj, @"13.Bmin.FirstInv.Chord");
    CreateChildWithName(Dmaj, @"14.C#dim.FirstInv.Chord");
    CreateChildWithName(Dmaj, @"15.Dmaj.basic.Chord");
    CreateChildWithName(Dmaj, @"16.Emin.basic.Chord");
    CreateChildWithName(Dmaj, @"17.F#min.basic.Chord");
    CreateChildWithName(Dmaj, @"18.Gmaj.basic.Chord");
    CreateChildWithName(Dmaj, @"19.Amaj.basic.Chord");
    CreateChildWithName(Dmaj, @"20.Bmin.basic.Chord");
    CreateChildWithName(Dmaj, @"21.C#dim.basic.Chord");
    
    CFTreeRef Emaj = CreateChildWithName(majorScales, @"Emaj");
    CreateChildWithName(Emaj, @"1.Emaj.SecondInv.Chord");
    CreateChildWithName(Emaj, @"2.F#min.SecondInv.Chord");
    CreateChildWithName(Emaj, @"3.G#min.SecondInv.Chord");
    CreateChildWithName(Emaj, @"4.Amaj.SecondInv.Chord");
    CreateChildWithName(Emaj, @"5.Bmaj.SecondInv.Chord");
    CreateChildWithName(Emaj, @"6.C#min.SecondInv.Chord");
    CreateChildWithName(Emaj, @"7.D#dim.SecondInv.Chord");
    CreateChildWithName(Emaj, @"8.Emaj.FirstInv.Chord");
    CreateChildWithName(Emaj, @"9.F#min.FirstInv.Chord");
    CreateChildWithName(Emaj, @"10.G#min.FirstInv.Chord");
    CreateChildWithName(Emaj, @"11.Amaj.FirstInv.Chord");
    CreateChildWithName(Emaj, @"12.Bmaj.FirstInv.Chord");
    CreateChildWithName(Emaj, @"13.C#min.FirstInv.Chord");
    CreateChildWithName(Emaj, @"14.D#dim.FirstInv.Chord");
    CreateChildWithName(Emaj, @"15.Emaj.basic.Chord");
    CreateChildWithName(Emaj, @"16.F#min.basic.Chord");
    CreateChildWithName(Emaj, @"17.G#min.basic.Chord");
    CreateChildWithName(Emaj, @"18.Amaj.basic.Chord");
    CreateChildWithName(Emaj, @"19.Bmaj.basic.Chord");
    CreateChildWithName(Emaj, @"20.C#min.basic.Chord");
    CreateChildWithName(Emaj, @"21.D#dim.basic.Chord");
    
    
    CFTreeRef F_maj = CreateChildWithName(majorScales, @"F#maj");
    CreateChildWithName(F_maj, @"1.F#maj.SecondInv.Chord");
    CreateChildWithName(F_maj, @"2.G#min.SecondInv.Chord");
    CreateChildWithName(F_maj, @"3.A#min.SecondInv.Chord");
    CreateChildWithName(F_maj, @"4.Bmaj.SecondInv.Chord");
    CreateChildWithName(F_maj, @"5.C#maj.SecondInv.Chord");
    CreateChildWithName(F_maj, @"6.D#min.SecondInv.Chord");
    CreateChildWithName(F_maj, @"7.Fdim.SecondInv.Chord");
    CreateChildWithName(F_maj, @"8.F#maj.FirstInv.Chord");
    CreateChildWithName(F_maj, @"9.G#min.FirstInv.Chord");
    CreateChildWithName(F_maj, @"10.A#min.FirstInv.Chord");
    CreateChildWithName(F_maj, @"11.Bmaj.FirstInv.Chord");
    CreateChildWithName(F_maj, @"12.C#maj.FirstInv.Chord");
    CreateChildWithName(F_maj, @"13.D#min.FirstInv.Chord");
    CreateChildWithName(F_maj, @"14.Fdim.FirstInv.Chord");
    CreateChildWithName(F_maj, @"15.F#maj.basic.Chord");
    CreateChildWithName(F_maj, @"16.G#min.basic.Chord");
    CreateChildWithName(F_maj, @"17.A#min.basic.Chord");
    CreateChildWithName(F_maj, @"18.Bmaj.basic.Chord");
    CreateChildWithName(F_maj, @"19.C#maj.basic.Chord");
    CreateChildWithName(F_maj, @"20.D#min.basic.Chord");
    CreateChildWithName(F_maj, @"21.Fdim.basic.Chord");
    
    CFTreeRef Fmaj = CreateChildWithName(majorScales, @"Fmaj");
    CreateChildWithName(Fmaj, @"1.Fmaj.SecondInv.Chord");
    CreateChildWithName(Fmaj, @"2.Gmin.SecondInv.Chord");
    CreateChildWithName(Fmaj, @"3.Amin.SecondInv.Chord");
    CreateChildWithName(Fmaj, @"4.A#maj.SecondInv.Chord");
    CreateChildWithName(Fmaj, @"5.Cmaj.SecondInv.Chord");
    CreateChildWithName(Fmaj, @"6.Dmin.SecondInv.Chord");
    CreateChildWithName(Fmaj, @"7.Edim.SecondInv.Chord");
    CreateChildWithName(Fmaj, @"8.Fmaj.FirstInv.Chord");
    CreateChildWithName(Fmaj, @"9.Gmin.FirstInv.Chord");
    CreateChildWithName(Fmaj, @"10.Amin.FirstInv.Chord");
    CreateChildWithName(Fmaj, @"11.A#maj.FirstInv.Chord");
    CreateChildWithName(Fmaj, @"12.Cmaj.FirstInv.Chord");
    CreateChildWithName(Fmaj, @"13.Dmin.FirstInv.Chord");
    CreateChildWithName(Fmaj, @"14.Edim.FirstInv.Chord");
    CreateChildWithName(Fmaj, @"15.Fmaj.basic.Chord");
    CreateChildWithName(Fmaj, @"16.Gmin.basic.Chord");
    CreateChildWithName(Fmaj, @"17.Amin.basic.Chord");
    CreateChildWithName(Fmaj, @"18.A#maj.basic.Chord");
    CreateChildWithName(Fmaj, @"19.Cmaj.basic.Chord");
    CreateChildWithName(Fmaj, @"20.Dmin.basic.Chord");
    CreateChildWithName(Fmaj, @"21.Edim.basic.Chord");
    
    
    CFTreeRef G_maj = CreateChildWithName(majorScales, @"G#maj");
    CreateChildWithName(G_maj, @"1.G#maj.SecondInv.Chord");
    CreateChildWithName(G_maj, @"2.A#min.SecondInv.Chord");
    CreateChildWithName(G_maj, @"3.Cmin.SecondInv.Chord");
    CreateChildWithName(G_maj, @"4.C#maj.SecondInv.Chord");
    CreateChildWithName(G_maj, @"5.D#maj.SecondInv.Chord");
    CreateChildWithName(G_maj, @"6.Fmin.SecondInv.Chord");
    CreateChildWithName(G_maj, @"7.Gdim.SecondInv.Chord");
    CreateChildWithName(G_maj, @"8.G#maj.FirstInv.Chord");
    CreateChildWithName(G_maj, @"9.A#min.FirstInv.Chord");
    CreateChildWithName(G_maj, @"10.Cmin.FirstInv.Chord");
    CreateChildWithName(G_maj, @"11.C#maj.FirstInv.Chord");
    CreateChildWithName(G_maj, @"12.D#maj.FirstInv.Chord");
    CreateChildWithName(G_maj, @"13.Fmin.FirstInv.Chord");
    CreateChildWithName(G_maj, @"14.Gdim.FirstInv.Chord");
    CreateChildWithName(G_maj, @"15.G#maj.basic.Chord");
    CreateChildWithName(G_maj, @"16.A#min.basic.Chord");
    CreateChildWithName(G_maj, @"17.Cmin.basic.Chord");
    CreateChildWithName(G_maj, @"18.C#maj.basic.Chord");
    CreateChildWithName(G_maj, @"19.D#maj.basic.Chord");
    CreateChildWithName(G_maj, @"20.Fmin.basic.Chord");
    CreateChildWithName(G_maj, @"21.Gdim.basic.Chord");
    
    
    CFTreeRef Gmaj = CreateChildWithName(majorScales, @"Gmaj");
    CreateChildWithName(Gmaj, @"1.Gmaj.SecondInv.Chord");
    CreateChildWithName(Gmaj, @"2.Amin.SecondInv.Chord");
    CreateChildWithName(Gmaj, @"3.Bmin.SecondInv.Chord");
    CreateChildWithName(Gmaj, @"4.Cmaj.SecondInv.Chord");
    CreateChildWithName(Gmaj, @"5.Dmaj.SecondInv.Chord");
    CreateChildWithName(Gmaj, @"6.Emin.SecondInv.Chord");
    CreateChildWithName(Gmaj, @"7.F#dim.SecondInv.Chord");
    CreateChildWithName(Gmaj, @"8.Gmaj.FirstInv.Chord");
    CreateChildWithName(Gmaj, @"9.Amin.FirstInv.Chord");
    CreateChildWithName(Gmaj, @"10.Bmin.FirstInv.Chord");
    CreateChildWithName(Gmaj, @"11.Cmaj.FirstInv.Chord");
    CreateChildWithName(Gmaj, @"12.Dmaj.FirstInv.Chord");
    CreateChildWithName(Gmaj, @"13.Emin.FirstInv.Chord");
    CreateChildWithName(Gmaj, @"14.F#dim.FirstInv.Chord");
    CreateChildWithName(Gmaj, @"15.Gmaj.basic.Chord");
    CreateChildWithName(Gmaj, @"16.Amin.basic.Chord");
    CreateChildWithName(Gmaj, @"17.Bmin.basic.Chord");
    CreateChildWithName(Gmaj, @"18.Cmaj.basic.Chord");
    CreateChildWithName(Gmaj, @"19.Dmaj.basic.Chord");
    CreateChildWithName(Gmaj, @"20.Emin.basic.Chord");
    CreateChildWithName(Gmaj, @"21.F#dim.basic.Chord");
    
    
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
