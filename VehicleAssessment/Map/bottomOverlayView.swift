//
//  bottomOverlayView.swift
//  VehicleAssessment
//
//  Created by Tejas Dubal on 23/02/22.
//

import UIKit

class BottomOverlayView: UIView {

  private func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
    return CGFloat.pi * degrees/180.0
  }

  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }

    let colorSpace = CGColorSpaceCreateDeviceRGB()

      drawCurvedRectangle(in: rect, in: context, with: colorSpace)
  }

func drawCurvedRectangle(in rect: CGRect, in context: CGContext, with colorSpace: CGColorSpace?) {
    
    let darkColor = UIColor(red: 72.0 / 255.0, green: 121.0 / 255.0, blue: 234.0 / 255.0, alpha: 1)
    let lightColor = UIColor(red: 135.0 / 255.0, green: 199.0 / 255.0, blue: 162.0 / 255.0, alpha: 1)
    let rectWidth = rect.size.width

    let curvedRectangleColor = [darkColor.cgColor, lightColor.cgColor]
    let curvedRectangleLocations: [CGFloat] = [0.1, 0.2]
    guard let curvedRectangleGrad = CGGradient.init(colorsSpace: colorSpace, colors: curvedRectangleColor as CFArray, locations: curvedRectangleLocations) else {
      return
    }

    let curvedRectangleStart = CGPoint(x: rect.size.height, y: 0)
    let curvedRectangleEnd = CGPoint(x: rect.size.height, y: rect.size.width)

    context.saveGState()
    defer { context.restoreGState() }

    let backgroundCurvedRectangle = CGMutablePath()

    // Specify the point that the path should start get drawn.
    backgroundCurvedRectangle.move(to: CGPoint(x: 0.0, y: 0.0))
 
    // Create a line between the starting point and the bottom-left side of the view.
    backgroundCurvedRectangle.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
 
    // Create the bottom line (bottom-left to bottom-right).
    backgroundCurvedRectangle.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
 
    // Create the vertical line from the bottom-right to the top-right side.
    backgroundCurvedRectangle.addLine(to: CGPoint(x: self.frame.size.width, y: 20.0))
 
    // Create the vertical line from the bottom-right to the top-right side.
    //backgroundMountains.addLine(to: CGPoint(x: 0.0, y: 0.0))
    
    backgroundCurvedRectangle.addQuadCurve(to: CGPoint(x: 0.0, y: 0.0), control: CGPoint(x: 60.0, y: 30.0))

    // Background Mountain Drawing
    context.addPath(backgroundCurvedRectangle)

    context.clip()
    context.drawLinearGradient(curvedRectangleGrad, start: curvedRectangleStart, end: curvedRectangleEnd, options: [])
    context.setLineWidth(0)

    // Background Mountain Stroking
    //context.addPath(backgroundCurvedRectangle)
    context.setStrokeColor(UIColor.black.cgColor)
    context.strokePath()
}
}
