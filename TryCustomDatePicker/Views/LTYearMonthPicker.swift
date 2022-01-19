//
//  LTYearMonthPicker.swift
//  TryCustomDatePicker
//
//  Created by dong on 2022/1/19.
//

import UIKit

class LTYearMonthPicker: UIView {
    private let yearComponent = 0
    private let monthComponent = 1

    private var pickView: LTPickerView!
    private var left: UIView!
    private var right: UIView!
    // for
    private var years: [Int] = []
    private var months: [Int] = []

    public var date: Date = Date()
    public var minimumDate: Date?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        setupDateData(date: date)
    }

    private func setupViews() {
        pickView = LTPickerView()
        pickView.frame = CGRect(x: 9, y: 0, width: UIScreen.main.bounds.width - 9 * 2, height: 300)
        addSubview(pickView)
        pickView.delegate = self
        pickView.dataSource = self
        pickView.showsLargeContentViewer = false
        pickView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(9)
            make.right.equalToSuperview().offset(-9)
            make.top.bottom.equalToSuperview()
        }

        left = UIView()
        left.layer.cornerRadius = 24
        left.layer.masksToBounds = true
        left.layer.borderWidth = 2
        left.layer.borderColor = UIColor.hexString("492AD2").cgColor
        pickView.addSubview(left)
        left.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 156, height: 48))
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(1 / 2.0)
        }
        right = UIView()
        right.layer.cornerRadius = 24
        right.layer.masksToBounds = true
        right.layer.borderWidth = 2
        right.layer.borderColor = UIColor.hexString("492AD2").cgColor
        pickView.addSubview(right)
        right.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 156, height: 48))
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(3 / 2.0)
        }
    }

    private func setupDateData(date: Date) {
        self.date = date
        let calendar = NSCalendar.current
        let compt = calendar.dateComponents([.year, .month, .day], from: date)
        guard let currentYear = compt.year, let currentMonth = compt.month else {
            return
        }

        for year in 1 ... currentYear {
            years.append(year)
        }
        for month in 1 ... 12 {
            months.append(month)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0) { [weak self] in
            self?.pickView.selectRow(currentMonth - 1, inComponent: self?.monthComponent ?? 1, animated: true)
            self?.pickView.selectRow(currentYear - 1, inComponent: self?.yearComponent ?? 0, animated: true)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LTYearMonthPicker: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == yearComponent {
            return years.count
        }
        if component == monthComponent {
            return months.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return (UIScreen.main.bounds.width - 18 * 2) / 2.0
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 48
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var itemView: PickItemView
        if let res = view {
            itemView = res as! PickItemView
        } else {
            let viewCreate = PickItemView()
            itemView = viewCreate
        }
        if component == yearComponent {
            let year = years[row]
            itemView.label.text = "\(year)"
        } else if component == monthComponent {
            let month = months[row]
            itemView.label.text = "\(month)"
        }
        // viewCreate.backgroundColor = UIColor.randomColor
        return itemView
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("print component:\(component) row:\(row)")
        if component == yearComponent {
            // 更新月份(根据最小时间的年月）可选择月份s
        }
        // now Date
        var datecomp = NSCalendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        datecomp.year = years[pickerView.selectedRow(inComponent: yearComponent)]
        datecomp.month = months[pickerView.selectedRow(inComponent: monthComponent)]
        date = Calendar.current.date(from: datecomp as DateComponents) ?? Date()
        if let mini = minimumDate, date.compare(mini) == .orderedAscending {
            setupDateData(date: mini)
        }
    }
}
