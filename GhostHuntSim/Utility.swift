//
// Created by Jesse Douglas on 2016-10-08.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import AVFoundation

public func dispatchAfterSeconds(when: Double, block: dispatch_block_t) {
    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(when * Double(NSEC_PER_SEC)))
    dispatch_after(dispatchTime, dispatch_get_main_queue(), block)
}

public func isCameraAvailable() -> Bool {
    return AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo).count > 0
}

public func isTorchAvailable() -> Bool {
    let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
    
    for device in devices {
        if device.hasTorch == true {
            return true;
        }
    }
    return false;
}

public func isMicrophoneAvailable() -> Bool {
    let inputs = AVAudioSession.sharedInstance().availableInputs
    
    if inputs != nil {
      for port in inputs! {
          if port.portType == AVAudioSessionPortBuiltInMic ||
              port.portType == AVAudioSessionPortHeadsetMic {
              return true;
          }
      }
    }
    return false;
}
