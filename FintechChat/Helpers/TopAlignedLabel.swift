//
//  TopAlignedLabel.swift
//  FintechChat
//
//  Created by Ирина Улитина on 14/02/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

class TopAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        guard let text = self.text else { super.drawText(in: rect); return }
        var modifiedRect = rect
        modifiedRect.size.height = CGFloat(text.filter({ $0 == "\n"}).count + 1) * font.lineHeight
        
        super.drawText(in: modifiedRect)
    }
}
