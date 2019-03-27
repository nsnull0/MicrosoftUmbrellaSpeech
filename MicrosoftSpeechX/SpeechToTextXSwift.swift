//
//  SpeechToTextXSwift.swift
//  MicrosoftSpeechX
//
//  Created by Yoseph Joyz on 25/03/19.
//  Copyright © 2019 Joyz. All rights reserved.
//

open class SpeechToTextXSwift : NSObject {
  
  var speechToTextXInstance: SpeechToTextX = SpeechToTextX()
  
  public func initConfiguration(speechKey: String, regionService: String, delegate: SpeechToTextXProtocol?) {
    speechToTextXInstance.startConfig(speechKey, regionService: regionService)
    speechToTextXInstance.delegate = delegate
  }
  
  public func initRecognizer() {
    speechToTextXInstance.initiateRecognizer()
  }
  
  public func startRecognize() {
    speechToTextXInstance.startRecognize()
  }
  
  public func stopRecognize(){
    speechToTextXInstance.stopRecognize()
  }
  
  public override init() {
    super.init()
  }
}
