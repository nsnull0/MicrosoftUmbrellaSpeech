//
//  SpeechToTextX.m
//  MicrosoftSpeechX
//
//  Created by Yoseph Joyz on 25/03/19.
//  Copyright © 2019 Joyz. All rights reserved.
//

#import "SpeechToTextX.h"
#import <MicrosoftCognitiveServicesSpeech/SPXSpeechApi.h>

@interface SpeechToTextX()
@property (nonatomic, strong) SPXSpeechConfiguration *speechConfiguration;
@property (nonatomic, strong) SPXSpeechRecognizer *recognizer;
@end

@implementation SpeechToTextX

- (void)startConfig:(NSString *)speechKey regionService:(NSString *)regionService {
  _speechConfiguration = [[SPXSpeechConfiguration alloc] initWithSubscription:speechKey region:regionService];
  if (!_speechConfiguration) {
    [_delegate errorHandler:COULD_NOT_LOAD_SPEECH_CONFIG];
  }
}

- (void)initiateRecognizer {
  if (_speechConfiguration) {
    _recognizer = [[SPXSpeechRecognizer alloc] init:_speechConfiguration];
    if (!_recognizer) {
      [_delegate errorHandler:COULD_NOT_CREATE_RECOGNIZER];
    }else{
      __typeof(self) __weak _self = self;
      [_recognizer addRecognizingEventHandler:^(SPXSpeechRecognizer * speech, SPXSpeechRecognitionEventArgs * event) {
        [_self.delegate rawResponse:event];
      }];
    }
  }else{
    [_delegate errorHandler:SPEECH_CONFIG_NOT_READY];
  }
}

- (void) startRecognize {
  if (!_recognizer) {
    [_delegate errorHandler:RECOGNIZER_SPEECH_NOT_READY];
  }else{
    [_recognizer startContinuousRecognition];
  }
}

- (void) stopRecognize {
  if (!_recognizer) {
    [_delegate errorHandler:RECOGNIZER_SPEECH_NOT_READY];
  }else{
    [_recognizer stopContinuousRecognition];
  }
}


@end
