//
//  PickItemView.swift
//  TryCustomDatePicker
//
//  Created by dong on 2022/1/18.
//

import SnapKit
import UIKit

class PickItemView: UIView {
    var label: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        label = UILabel()
        label.textColor = UIColor.hexString("492AD2")
        label.text = "-"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
