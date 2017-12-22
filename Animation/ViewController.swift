//
//  ViewController.swift
//  Animation
//
//  Created by Patrick Bellot on 12/14/17.
//  Copyright © 2017 Polestar Interactive LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
  
  var shapeLayer: CAShapeLayer!
  var pulsatingLayer: CAShapeLayer!
  
  let percentageLabel: UILabel = {
    let label = UILabel()
    label.text = "Start"
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 32)
    label.textColor = .white
    return label
  }()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  private func setupNotificationObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
  }
  
  @objc private func handleEnterForeground() {
    animatePulsatingLayer()
  }
  
  private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
    let layer = CAShapeLayer()
     let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
    layer.path = circularPath.cgPath
    layer.strokeColor = strokeColor.cgColor
    layer.lineWidth = 20
    layer.fillColor = fillColor.cgColor
    layer.lineCap = kCALineCapRound
    layer.position = view.center
    return layer
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNotificationObservers()
    
    view.backgroundColor = UIColor.backgroundColor
    
    setupCircleLayers()
    setupPercentageLabel()
    
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
  }
  
  private func setupPercentageLabel() {
    percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    percentageLabel.center = view.center
    view.addSubview(percentageLabel)
  }
  
  private func setupCircleLayers() {
    pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor.pulsatingFillColor)
    view.layer.addSublayer(pulsatingLayer)
    animatePulsatingLayer()
    
    let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
    view.layer.addSublayer(trackLayer)
    
    shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
    
    shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
    
    shapeLayer.strokeEnd = 0
    
    view.layer.addSublayer(shapeLayer)
  }
  
  private func animatePulsatingLayer() {
    let animation = CABasicAnimation(keyPath: "transform.scale")
    
    animation.toValue = 1.5
    animation.duration = 0.8
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    animation.autoreverses = true
    animation.repeatCount = Float.infinity
    
    pulsatingLayer.add(animation, forKey: "pulsating")
  }
  
  let urlString = "https://firebasestorage.googleapis.com/v0/b/firestorechat-e64ac.appspot.com/o/intermediate_training_rec.mp4?alt=media&token=e20261d0=7219-49d2-b32d-367e1606500c"
  
  private func beginDownloadingFile() {
    print("Attempting to download file")
    
    shapeLayer.strokeEnd = 0
    
    let configuration = URLSessionConfiguration.default
    let operationQueue = OperationQueue()
    let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
    
    guard let url = URL(string: urlString) else { return }
    let downloadTask = urlSession.downloadTask(with: url)
    downloadTask.resume()
    }
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    print(totalBytesWritten, totalBytesExpectedToWrite)
    
    let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
    
    DispatchQueue.main.async {
      self.percentageLabel.text = "\(Int(percentage * 100))%"
      self.shapeLayer.strokeEnd = percentage
    }
   
    print(percentage)
  }
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    print("Finished downloading file")
  }
  
  fileprivate func animateCircle() {
    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    basicAnimation.toValue = 1
    basicAnimation.duration = 2
    basicAnimation.fillMode = kCAFillModeForwards
    basicAnimation.isRemovedOnCompletion = false
    
    shapeLayer.add(basicAnimation, forKey: "urSoBasic")
  }
  
  @objc private func handleTap() {
    print("Attemption to animate stroke")
    
    beginDownloadingFile()
    
    //animateCircle()
  }
  
} // end of class

