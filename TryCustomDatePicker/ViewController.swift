//
//  ViewController.swift
//  TryCustomDatePicker
//
//  Created by dong on 2022/1/18.
//

import SnapKit
import UIKit

class ViewController: UIViewController {
    var pickView: LTDatePickerView!
    var sysPickerView: UIDatePicker!
    var myPickView: LTYearMonthPicker!

    var customDateLabel: UILabel!
    var systemDateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.randomColor.withAlphaComponent(0.2)

        let button = UIButton(type: .custom)
        button.setTitle("Confirm", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .cyan
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        button.frame = CGRect(x: 10, y: 70, width: 80, height: 44)
        view.addSubview(button)

        customDateLabel = UILabel()
        customDateLabel.textColor = .white // .hexString("120E1B")
        customDateLabel.text = "-"
        view.addSubview(customDateLabel)
        customDateLabel.snp.makeConstraints { make in
            make.top.equalTo(button)
            make.left.equalTo(button.snp.right).offset(24)
        }

        systemDateLabel = UILabel()
        systemDateLabel.textColor = .white // .hexString("120E1B")
        systemDateLabel.text = "-"
        view.addSubview(systemDateLabel)
        systemDateLabel.snp.makeConstraints { make in
            make.top.equalTo(customDateLabel.snp.bottom).offset(12)
            make.left.equalTo(customDateLabel)
        }

        pickView = LTDatePickerView()
        pickView.minimumDate = Date.dateStringToDate("1949-10-01")
        view.addSubview(pickView)
        pickView.snp.makeConstraints { make in
            // make.centerY.equalToSuperview()
            make.top.equalTo(button.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.height.equalTo(300)
        }

        sysPickerView = UIDatePicker()
        sysPickerView.datePickerMode = .date
        sysPickerView.preferredDatePickerStyle = .wheels
        sysPickerView.setValue(UIColor.white, forKey: "backgroundColor")
        view.addSubview(sysPickerView)
        sysPickerView.snp.makeConstraints { make in
            make.top.equalTo(pickView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.height.equalTo(300)
        }
        sysPickerView.isHidden = true

        myPickView = LTYearMonthPicker()
        myPickView.minimumDate = Date.dateStringToDate("2019-07-13")
        view.addSubview(myPickView)
        myPickView.snp.makeConstraints { make in
            make.top.equalTo(pickView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.height.equalTo(300)
        }
    }

    @objc private func tapButton() {
        // print("⛱ system DatePicker's date: \(date) format: \(date.toString()) ")

        let custom = pickView.date
        customDateLabel.text = custom.toString()

//        let date = sysPickerView.date
//        systemDateLabel.text = date.toString()

        let date = myPickView.date
        systemDateLabel.text = date.toString()
    }
}
