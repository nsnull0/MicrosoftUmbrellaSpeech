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

- (void)startConfig:(NSString *)speechKey
      regionService:(NSString *)regionService {
  _speechConfiguration = [[SPXSpeechConfiguration alloc] initWithSubscription:speechKey region:regionService];
  if (!_speechConfiguration) {
    [_delegate errorHandler:COULD_NOT_LOAD_SPEECH_CONFIG];
  }else{
    [_speechConfiguration setPropertyTo:@"True" byId:SPXSpeechServiceResponseRequestDetailedResultTrueFalse];
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
        SPXRecognitionResult *result = event.result;
        
        [_self.delegate onPartialResponse:result.text];
      }];
      [_recognizer addRecognizedEventHandler:^(SPXSpeechRecognizer * speech, SPXSpeechRecognitionEventArgs * event) {
        SPXRecognitionResult *result = event.result;
        NSString *jsonString = [result.properties getPropertyById:SPXSpeechServiceResponseJsonResult];
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *resultProperties = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *resultBestList = [resultProperties valueForKey:@"NBest"];
        if ([resultBestList count] > 0) {
          NSDictionary *resultBestDictionary = resultBestList.firstObject;
          NSString *resultBestConfidence = [NSString stringWithFormat:@"%@",[resultBestDictionary valueForKey:@"Confidence"]];
          NSString *resultBestLexical = [NSString stringWithFormat:@"%@", [resultBestDictionary valueForKey:@"Lexical"]];
          [_self.delegate onFinishedResponse:resultBestLexical score:resultBestConfidence];
          [_self stopRecognize];
        }else{
          [_self.delegate onNoResponse];
        }
      }];

      [_recognizer addCanceledEventHandler:^(SPXSpeechRecognizer * speech, SPXSpeechRecognitionCanceledEventArgs * event) {
        [_self stopRecognize];
        [_self.delegate onNoResponse];
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
