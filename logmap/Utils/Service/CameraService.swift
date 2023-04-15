//
//  CameraService.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/09.
//

import Foundation
import AVFoundation

class CameraService {
    var session: AVCaptureSession?
    var delegate: AVCapturePhotoCaptureDelegate?
    
    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    // sessionをスタート
    func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping(Error?) -> ()){
        self.delegate = delegate
        checkPermissions(completion: completion)
    }
    
    // ユーザからカメラの使用許可を取得
    private func checkPermissions(completion: @escaping (Error?) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                
                // カメラのセットアップ
                DispatchQueue.main.async {
                    self?.setupCamera(completion: completion)
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera(completion: completion)
        @unknown default:
            break
        }
    }
    
    private func setupCamera(completion: @escaping (Error?) -> ()){
        let session = AVCaptureSession()
        
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                // バックグラウンドスレッドで実行
                DispatchQueue.global(qos: .userInitiated).async {
                    session.startRunning()
                }
                self.session = session
            } catch {
                completion(error)
            }
        }
    }
    
    func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()) {
        
        output.capturePhoto(with: settings, delegate: delegate!)
    }
}
