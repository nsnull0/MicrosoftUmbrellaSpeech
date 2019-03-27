//
//  SpeechToTextX.h
//  MicrosoftSpeechX
//
//  Created by Yoseph Joyz on 25/03/19.
//  Copyright © 2019 Joyz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ErrorType) {
  COULD_NOT_LOAD_SPEECH_CONFIG,
  SPEECH_CONFIG_NOT_READY,
  RECOGNIZER_SPEECH_NOT_READY,
  COULD_NOT_CREATE_RECOGNIZER
};

@protocol SpeechToTextXProtocol
@required
-(void) errorHandler:(ErrorType)type;
-(void) onPartialResponse:(NSString*)text;
-(void) onFinishedResponse:(NSString*)text score:(NSString*)confidence;
-(void) action:(NSString*)anyAction;
@end

@interface SpeechToTextX : NSObject

@property (nonatomic, weak) id<SpeechToTextXProtocol> delegate;

-(void)startConfig:(NSString *) speechKey
     regionService:(NSString *) regionService;

-(void)initiateRecognizer;
-(void)startRecognize;
-(void)stopRecognize;
@end
