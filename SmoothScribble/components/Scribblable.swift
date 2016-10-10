//
//  Scribblable.swift
//  SmoothScribble
//
//  Created by Simon Gladman on 05/11/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//

import UIKit

// MARK: Scribblable protocol

protocol Scribblable
{
    func beginScribble(_ point: CGPoint)
    func appendScribble(_ point: CGPoint)
    func endScribble()
    func clearScribble()
}

// MARK: ScribbleView base class

class ScribbleView: UIView
{
    let backgroundLayer1 = CAShapeLayer()
    let backgroundLayer2 = CAShapeLayer()
    let LineLayer = CAShapeLayer()
    let LineLayer2 = CAShapeLayer()
    
    let drawingLayer = CAShapeLayer()
    
    let titleLabel = UILabel()
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    required init()
    {
        super.init(frame: CGRect.zero)
        
        backgroundLayer1.strokeColor = UIColor.white.cgColor
        backgroundLayer1.fillColor = nil
        backgroundLayer1.lineWidth = 5
        LineLayer.backgroundColor = UIColor.white.cgColor
         LineLayer2.backgroundColor = UIColor.white.cgColor
        
        backgroundLayer2.strokeColor = UIColor.white.cgColor
        backgroundLayer2.fillColor = nil
        backgroundLayer2.lineWidth = 5
        
        drawingLayer.strokeColor = UIColor.white.cgColor
        drawingLayer.fillColor = nil
        drawingLayer.lineWidth = 5

        layer.addSublayer(backgroundLayer1)
        
        layer.addSublayer(backgroundLayer2)
        
        
        
       
        LineLayer.lineWidth = 1.0
        LineLayer.fillColor = nil
        LineLayer.bounds = CGRect(x: 0.0, y: 0.0, width: screenHeight / 1.2, height: 2)
        LineLayer.path = UIBezierPath(rect: LineLayer.bounds).cgPath

        
        LineLayer2.lineWidth = 1.0
        LineLayer2.fillColor = nil
        LineLayer2.bounds = CGRect(x: 0.0, y: 0.0, width: screenHeight / 1.2, height: 2)
        LineLayer2.path = UIBezierPath(rect: LineLayer2.bounds).cgPath

        
 
        
        
        layer.addSublayer(LineLayer)
        layer.addSublayer(LineLayer2)
        
        layer.addSublayer(drawingLayer)
        
       /* titleLabel.text = title
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = UIColor.blue
        addSubview(titleLabel)
        */
      //  layer.borderColor = UIColor.blue.cgColor
      //  layer.borderWidth = 1
        
        layer.masksToBounds = true
        
      
        
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews()
    {
        titleLabel.frame = CGRect(x: 0,
            y: frame.height - titleLabel.intrinsicContentSize.height - 2,
            width: frame.width,
            height: titleLabel.intrinsicContentSize.height)
    }
}


// MARK: Hermite interpolation implementation of ScribbleView

class HermiteScribbleView: ScribbleView, Scribblable
{
    let hermitePath = UIBezierPath()
    var interpolationPoints = [CGPoint]()
    var currentStage = 0

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        super.init()
       
        //  fatalError("init(title:) has not been implemented")
        
    }

    
    func triggerLandscape() {
        
           backgroundLayer1.transform = CATransform3DMakeScale(1, 1, 1);
        backgroundLayer2.transform = CATransform3DMakeScale(1, 1, 1);
        backgroundLayer1.position = CGPoint(x: 0, y: 0);
        backgroundLayer2.position = CGPoint(x: 0, y: 0 );
           LineLayer.position = CGPoint(x: screenHeight / 2, y: screenHeight / 7 );
           LineLayer2.position = CGPoint(x: screenHeight / 2, y: screenHeight / 3 );
           LineLayer.isHidden = false
           LineLayer2.isHidden = false
        
    }

    func triggerPotrait() {
        
         backgroundLayer1.lineWidth = 10
         backgroundLayer2.lineWidth = 10
        backgroundLayer1.isHidden = false
         backgroundLayer1.transform = CATransform3DMakeScale(0.5, 0.5, 1);
          backgroundLayer2.transform = CATransform3DMakeScale(0.5, 0.5, 1);
        backgroundLayer1.position = CGPoint(x: screenWidth / 10, y: screenHeight / 15);
        backgroundLayer2.position = CGPoint(x: screenWidth / 10, y: screenHeight / 1.5);
        
        LineLayer.isHidden = true
        LineLayer2.isHidden = true
      
        
    }
    
    func moveNext() {
        
       
    }


    
    
    
    func beginScribble(_ point: CGPoint)
    {
        
        interpolationPoints = [point]
    }

    func appendScribble(_ point: CGPoint)
    {
        interpolationPoints.append(point)
        
        hermitePath.removeAllPoints()
        hermitePath.interpolatePointsWithHermite(interpolationPoints)
        
        drawingLayer.path = hermitePath.cgPath
    }
    
    func endScribble()
    {
        if(currentStage == 1) {
        if let backgroundPath = backgroundLayer1.path
        {
            hermitePath.append(UIBezierPath(cgPath: backgroundPath))
        }
        
        backgroundLayer1.path = hermitePath.cgPath
        }else {
            if let backgroundPath = backgroundLayer2.path
            {
                hermitePath.append(UIBezierPath(cgPath: backgroundPath))
            }
            
            backgroundLayer2.path = hermitePath.cgPath
        }
        
        hermitePath.removeAllPoints()
        
        drawingLayer.path = hermitePath.cgPath
    }
    
    func clearScribble()
    {
      //  if(currentStage == 1) {
            backgroundLayer1.path = nil
      //  }else{
            backgroundLayer2.path = nil

      //  }
    }
    
    
}
