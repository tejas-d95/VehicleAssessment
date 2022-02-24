//
//  UILabel+Extension.swift
//  VehicleAssessment
//
//  Created by Tejas Dubal on 23/02/22.
//

import UIKit

extension UILabel {
  func set(image: UIImage, with text: String) {
    let attachment = NSTextAttachment()
    attachment.image = image
    attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
    let attachmentStr = NSAttributedString(attachment: attachment)

    let mutableAttributedString = NSMutableAttributedString()
    mutableAttributedString.append(attachmentStr)

    let textString = NSAttributedString(string: text, attributes: [.font: UIFont.boldSystemFont(ofSize: 20)])
    mutableAttributedString.append(textString)

    self.attributedText = mutableAttributedString
  }
}
