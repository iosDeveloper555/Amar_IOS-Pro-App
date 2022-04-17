//
//  ABSteppedProgressBar.swift
//  ABSteppedProgressBar
//
//  Created by Antonin Biret on 17/02/15.
//  Copyright (c) 2015 Antonin Biret. All rights reserved.
//

import UIKit
import Foundation
import CoreGraphics

@objc public protocol ABSteppedProgressBarDelegate {
    
    @objc optional func progressBar(_ progressBar: ABSteppedProgressBar,
        willSelectItemAtIndex index: Int)
    
    @objc optional func progressBar(_ progressBar: ABSteppedProgressBar,
        didSelectItemAtIndex index: Int)
    
    @objc optional func progressBar(_ progressBar: ABSteppedProgressBar,
        canSelectItemAtIndex index: Int) -> Bool
    
    @objc optional func progressBar(_ progressBar: ABSteppedProgressBar,
        textAtIndex index: Int) -> String
    
}

@IBDesignable open class ABSteppedProgressBar: UIView {
    
    @IBInspectable open var numberOfPoints: Int = 3 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable open var hasIndexVal: Int = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    open var currentIndex: Int = 0 {
        willSet(newValue){
            if let delegate = self.delegate {
                delegate.progressBar?(self, willSelectItemAtIndex: newValue)
            }
        }
        didSet {
            animationRendering = true
            self.setNeedsDisplay()
        }
    }
    
    fileprivate var previousIndex: Int = 0
    
    @IBInspectable open var lineHeight: CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    fileprivate var _lineHeight: CGFloat {
        get {
            if(lineHeight == 0.0 || lineHeight > self.bounds.height) {
                return self.bounds.height * 0.4
            }
            return lineHeight
        }
    }
    
    @IBInspectable open var radius: CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    fileprivate var _radius: CGFloat {
        get{
            if(radius == 0.0 || radius > self.bounds.height / 2.0) {
                return self.bounds.height / 2.0
            }
            return radius
        }
    }
    
    @IBInspectable open var progressRadius: CGFloat = 0.0 {
        didSet {
            maskLayer.cornerRadius = progressRadius
            self.setNeedsDisplay()
        }
    }
    
    fileprivate var _progressRadius: CGFloat {
        get {
            if(progressRadius == 0.0 || progressRadius > self.bounds.height / 2.0) {
                return self.bounds.height / 2.0
            }
            return progressRadius
        }
    }
    
    @IBInspectable open var progressLineHeight: CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    fileprivate var _progressLineHeight: CGFloat {
        get {
            if(progressLineHeight == 0.0 || progressLineHeight > _lineHeight) {
                return _lineHeight
            }
            return progressLineHeight
        }
    }
    
    @IBInspectable open var stepAnimationDuration: CFTimeInterval = 0.4
    
    @IBInspectable open var displayNumbers: Bool = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    open var numbersFont: UIFont? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    open var numbersColor: UIColor? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable open var backgroundShapeColor: UIColor = UIColor(red: 166.0/255.0, green: 160.0/255.0, blue: 151.0/255.0, alpha: 0.8) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable open var selectedBackgoundColor: UIColor = UIColor(red: 150.0/255.0, green: 24.0/255.0, blue: 33.0/255.0, alpha: 1.0) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    open var delegate: ABSteppedProgressBarDelegate?
    
    fileprivate var backgroundLayer: CAShapeLayer = CAShapeLayer()
    fileprivate var progressLayer: CAShapeLayer = CAShapeLayer()
    fileprivate var maskLayer: CAShapeLayer = CAShapeLayer()
    fileprivate var centerPoints = Array<CGPoint>()
    
    fileprivate var animationRendering = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    convenience init() {
        self.init(frame:CGRect.zero)
    }
    
    func commonInit() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ABSteppedProgressBar.gestureAction(_:)))
        let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ABSteppedProgressBar.gestureAction(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
        self.addGestureRecognizer(swipeGestureRecognizer)
        
        
        self.backgroundColor = UIColor.clear
        
        self.layer.addSublayer(backgroundLayer)
        self.layer.addSublayer(progressLayer)
        progressLayer.mask = maskLayer
        
        self.contentMode = UIView.ContentMode.redraw
    }
    
    
    override open func draw(_ rect: CGRect) {        
        super.draw(rect)
        
        let largerRadius = fmax(_radius, _progressRadius)

        let distanceBetweenCircles = (self.bounds.width - (CGFloat(numberOfPoints) * 2 * largerRadius)) / CGFloat(numberOfPoints - 1)
        
        var xCursor: CGFloat = largerRadius
        
        for _ in 0...(numberOfPoints - 1) {
            centerPoints.append(CGPoint(x: xCursor, y: bounds.height / 2))
            xCursor += 2 * largerRadius + distanceBetweenCircles
        }
        
        let progressCenterPoints = Array<CGPoint>(centerPoints[0..<(hasIndexVal+1)])
        
        if(!animationRendering) {
            
            if let bgPath = shapePath(centerPoints, aRadius: _radius, aLineHeight: _lineHeight) {
                backgroundLayer.path = bgPath.cgPath
                backgroundLayer.fillColor = backgroundShapeColor.cgColor
            }
            
            if let progressPath = shapePath(centerPoints, aRadius: _progressRadius, aLineHeight: _progressLineHeight) {
                progressLayer.path = progressPath.cgPath
                progressLayer.fillColor = selectedBackgoundColor.cgColor
            }
            
            if(displayNumbers) {
                for i in 0...(numberOfPoints - 1) {
                    let centerPoint = centerPoints[i]
                    let textLayer = CATextLayer()
                    
                    var textLayerFont = UIFont.boldSystemFont(ofSize: _progressRadius)
                    textLayer.contentsScale = UIScreen.main.scale
                    
                    if let nFont = self.numbersFont {
                        textLayerFont = nFont
                    }
                    textLayer.font = CTFontCreateWithName(textLayerFont.fontName as CFString, textLayerFont.pointSize, nil)
                    textLayer.fontSize = textLayerFont.pointSize
                    
                    if let nColor = self.numbersColor {
                        textLayer.foregroundColor = nColor.cgColor
                    }
                    
                    if let text = self.delegate?.progressBar?(self, textAtIndex: i) {
                        textLayer.string = text
                    } else {
                        textLayer.string = ""
                    }
                    
                    textLayer.sizeWidthToFit()
                    
                    textLayer.frame = CGRect(x: centerPoint.x - textLayer.bounds.width/2, y: centerPoint.y - textLayer.bounds.height/2, width: textLayer.bounds.width, height: textLayer.bounds.height)
                    
                    self.layer.addSublayer(textLayer)
                }
            }
        }
        
        if let currentProgressCenterPoint = progressCenterPoints.last {
            
            let maskPath = self.maskPath(currentProgressCenterPoint)
            maskLayer.path = maskPath.cgPath
            
            CATransaction.begin()
            let progressAnimation = CABasicAnimation(keyPath: "path")
            progressAnimation.duration = stepAnimationDuration * CFTimeInterval(abs(currentIndex - previousIndex))
            progressAnimation.toValue = maskPath
            progressAnimation.isRemovedOnCompletion = false
            progressAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            
            
            CATransaction.setCompletionBlock { () -> Void in
                if(self.animationRendering) {
                    if let delegate = self.delegate {
                        delegate.progressBar?(self, didSelectItemAtIndex: self.currentIndex)
                    }
                    self.animationRendering = false
                }
            }
            
            maskLayer.add(progressAnimation, forKey: "progressAnimation")
            CATransaction.commit()
        }
        previousIndex = currentIndex
    }
    
    
    func shapePath(_ centerPoints: Array<CGPoint>, aRadius: CGFloat, aLineHeight: CGFloat) -> UIBezierPath? {
        
        let nbPoint = centerPoints.count
        
        let path = UIBezierPath()
        
        var distanceBetweenCircles: CGFloat = 0
        
        if let first = centerPoints.first, nbPoint > 2 {
            let second = centerPoints[1]
            distanceBetweenCircles = second.x - first.x - 2 * aRadius
        }
        
        let angle = aLineHeight / 2.0 / aRadius;
        
        var xCursor: CGFloat = 0
        
        
        for i in 0...(2 * nbPoint - 1) {
            
            var index = i
            if(index >= nbPoint) {
                index = (nbPoint - 1) - (i - nbPoint)
            }
            
            let centerPoint = centerPoints[index]
            
            var startAngle: CGFloat = 0
            var endAngle: CGFloat = 0
            
            if(i == 0) {
                
                xCursor = centerPoint.x
                
                startAngle = .pi
                endAngle = -angle
                
            } else if(i < nbPoint - 1) {
                
                startAngle = .pi + angle
                endAngle = -angle
                
            } else if(i == (nbPoint - 1)){
                
                startAngle = .pi + angle
                endAngle = 0
                
            } else if(i == nbPoint) {
                
                startAngle = 0
                endAngle = .pi - angle
                
            } else if (i < (2 * nbPoint - 1)) {
                
                startAngle = angle
                endAngle = .pi - angle
                
            } else {
                
                startAngle = angle
                endAngle = .pi
                
            }
            
            path.addArc(withCenter: CGPoint(x: centerPoint.x, y: centerPoint.y), radius: aRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            
            if(i < nbPoint - 1) {
                xCursor += aRadius + distanceBetweenCircles
                path.addLine(to: CGPoint(x: xCursor, y: centerPoint.y - aLineHeight / 2.0))
                xCursor += aRadius
            } else if (i < (2 * nbPoint - 1) && i >= nbPoint) {
                xCursor -= aRadius + distanceBetweenCircles
                path.addLine(to: CGPoint(x: xCursor, y: centerPoint.y + aLineHeight / 2.0))
                xCursor -= aRadius
            }
        }
        return path
    }
    
    func progressMaskPath(_ currentProgressCenterPoint: CGPoint) -> UIBezierPath {
        let maskPath = UIBezierPath(rect: CGRect(x: 0.0, y: 0.0, width: currentProgressCenterPoint.x + _progressRadius, height: self.bounds.height))
        return maskPath
    }
    
    func maskPath(_ currentProgressCenterPoint: CGPoint) -> UIBezierPath {
        
        let angle = _progressLineHeight / 2.0 / _progressRadius;
        let xOffset = cos(angle) * _progressRadius
        
        let maskPath = UIBezierPath()
        
        maskPath.move(to: CGPoint(x: 0.0, y: 0.0))
        
        maskPath.addLine(to: CGPoint(x: currentProgressCenterPoint.x + xOffset, y: 0.0))
        
        maskPath.addLine(to: CGPoint(x: currentProgressCenterPoint.x + xOffset, y: currentProgressCenterPoint.y - _progressLineHeight))
        
        maskPath.addArc(withCenter: currentProgressCenterPoint, radius: _progressRadius, startAngle: -angle, endAngle: angle, clockwise: true)
        
        maskPath.addLine(to: CGPoint(x: currentProgressCenterPoint.x + xOffset, y: self.bounds.height))
        
        maskPath.addLine(to: CGPoint(x: 0.0, y: self.bounds.height))
        maskPath.close()
        
        return maskPath
    }
    
    
    @objc func gestureAction(_ gestureRecognizer:UIGestureRecognizer) {
        if(gestureRecognizer.state == UIGestureRecognizer.State.ended ||
            gestureRecognizer.state == UIGestureRecognizer.State.changed ) {
                
                let touchPoint = gestureRecognizer.location(in: self)
                
                var smallestDistance = CGFloat(Float.infinity)
                
                var selectedIndex = 0
                
                for (index, point) in centerPoints.enumerated() {
                    let distance = touchPoint.distanceWith(point)
                    if(distance < smallestDistance) {
                        smallestDistance = distance
                        selectedIndex = index
                    }
                }
                if(currentIndex != selectedIndex) {
                    if let canSelect = self.delegate?.progressBar?(self, canSelectItemAtIndex: selectedIndex) {
                        if (canSelect) {
                            currentIndex = selectedIndex
                        }
                    } else {
                        currentIndex = selectedIndex
                    }
                }
        }
    }
    
}
