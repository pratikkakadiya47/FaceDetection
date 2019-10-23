//
//  NostalgiaCamera.h
//  FaceDetection
//
//  Created by Synoptek Mac 2 on 26/09/19.
//  Copyright © 2019 Synoptek Mac 2. All rights reserved.
//

#ifndef NostalgiaCamera_h
#define NostalgiaCamera_h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Protocol for callback action
@protocol NostalgiaCameraDelegate <NSObject>
    
- (void)matchedItem;
    
    @end

// Public interface for camera. ViewController only needs to init, start and stop.
@interface NostalgiaCamera : NSObject
    
-(id) initWithController: (UIViewController<NostalgiaCameraDelegate>*)c andImageView: (UIImageView*)iv;
-(void)start;
-(void)stop;
    
    @end

#endif /* NostalgiaCamera_h */
