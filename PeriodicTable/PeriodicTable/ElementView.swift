//
//  ElementView.swift
//  PeriodicTable
//
//  Created by Karen Fuentes on 12/21/16.
//  Copyright © 2016 Karen Fuentes. All rights reserved.
//

import UIKit

class ElementView: UIView {
    
    @IBOutlet weak var elementSymbLabel: UILabel!
    @IBOutlet weak var elementNumbLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    // xib file
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let view = Bundle.main.loadNibNamed("ElementView", owner: self, options: nil)?.first as? UIView {
            view.backgroundColor = .clear
            self.addSubview(view)
            view.frame = self.bounds
        }
     
        }
    }
   


