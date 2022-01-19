//
//  LTPickerView.swift
//  TryCustomDatePicker
//
//  Created by dong on 2022/1/19.
//

import UIKit

class LTPickerView: UIPickerView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for per in subviews {
            print("subview: \(per)")
          if per.frame.height <= 1 {
              per.backgroundColor = UIColor.white.withAlphaComponent(0.15)
          }else{
              per.backgroundColor = .clear
          }
        }
    }
}
