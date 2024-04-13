//
//  BarcodeReaderViewController.swift
//  Honnaeng
//
//  Created by Rarla on 3/30/24.
//

import AVFoundation
import UIKit

class BarcodeReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var delegate: FoodDetailNavigationDelegate?
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "바코드로 입력"
        label.font = .Heading3
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let barcodeInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "바코드를 영역에 잘 맞춰주세요"
        label.font = .Paragraph3
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let barcodeBox: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(named: "gray00")?.cgColor
        view.layer.borderWidth = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.backgroundColor = UIColor(named: "gray03")
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .Paragraph2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCaptureSession()
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor(named: "white")
        
        view.addSubview(titleLabel)
        view.addSubview(barcodeInfoLabel)
        view.addSubview(barcodeBox)
        view.addSubview(backButton)
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            barcodeInfoLabel.topAnchor.constraint(equalTo: barcodeBox.topAnchor, constant: -50),
            barcodeInfoLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            barcodeBox.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            barcodeBox.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            barcodeBox.widthAnchor.constraint(equalToConstant: 300),
            barcodeBox.heightAnchor.constraint(equalToConstant: 300),
            
            backButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -40),
            backButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 100),
            backButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func configureCaptureSession() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        guard let captureSession = captureSession else {
            failed()
            return
        }
        
        captureSession.addInput(videoInput)
        
        let metadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metadataOutput)
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = barcodeBox.frame
        previewLayer?.videoGravity = .resizeAspectFill
        
        guard let previewLayer = previewLayer else { return }
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .background).async {
            self.captureSession?.startRunning()
        }
    }
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = barcodeBox.frame
    }
    
    private func failed() {
        PopUp.shared.showOneButtonPopUp(self: self,
                                        title: "바코드로 입력 실패",
                                        message: "해당 장치에서 카메라가 지원되지 않습니다.")
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let captureSession = captureSession else { return }
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.captureSession?.startRunning()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let captureSession = captureSession else { return }
        if captureSession.isRunning {
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.captureSession?.stopRunning()
            }
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
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
            guard let data = data, error == nil else { return }
            
            let decoder = JSONDecoder()
            if let json = try? decoder.decode(OpenFoodAPI.self, from: data) {
                DispatchQueue.main.async {
                    let name = json.serviceId.row[0].name
                    self.delegate?.showFoodDetail(name: name)
                }
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
