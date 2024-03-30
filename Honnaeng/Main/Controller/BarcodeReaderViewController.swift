//
//  BarcodeReaderViewController.swift
//  Honnaeng
//
//  Created by Rarla on 3/30/24.
//

import AVFoundation
import UIKit

class BarcodeReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var viewModel: MainViewModel
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "바코드로 추가"
        label.font = .Heading3
        label.textAlignment = .center
        label.textColor = UIColor(named: "white")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let barcodeBox: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(named: "white")?.cgColor
        view.layer.borderWidth = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.layer.borderColor = UIColor(named: "white")?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "black")
        
        view.addSubview(titleLabel)
        view.addSubview(barcodeBox)
        view.addSubview(backButton)
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            barcodeBox.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            barcodeBox.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            barcodeBox.widthAnchor.constraint(equalToConstant: 300),
            barcodeBox.heightAnchor.constraint(equalToConstant: 300),
            
            backButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -40),
            backButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 100),
            backButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        captureSession?.addInput(videoInput)
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        captureSession?.addOutput(metadataOutput)
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        
        guard let captureSession = captureSession else { return }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        
        guard let previewLayer = previewLayer else { return }
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .background).async {
            self.captureSession?.startRunning()
        }
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = barcodeBox.frame
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .background).async {
            self.captureSession?.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession?.stopRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        guard let apiKey = Bundle.main.foodSafetyKoreaApiKey,
              let urlString = URL(string: "https://openapi.foodsafetykorea.go.kr/api/\(apiKey)/C005/json/1/1/BAR_CD=\(code)") else { return }
        
        let session = URLSession.shared.dataTask(with: URLRequest(url: urlString)) { data, response, error in
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            if let json = try? decoder.decode(OpenFoodAPI.self, from: data) {
                print(json.serviceId.row[0].name, json.serviceId.row[0].group)
            }
        }
        session.resume()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
