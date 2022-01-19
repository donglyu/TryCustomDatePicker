//
//  LTDatePickerView.swift
//  TryCustomDatePicker
//
//  Created by dong on 2022/1/19.
//

import UIKit

class LTDatePickerView: UIView {
    private let yearComponent = 2
    private let monthComponent = 0
    private let dayComponent = 1

    private var pickView: LTPickerView!
    private var middle: UIView!
    private var left: UIView!
    private var right: UIView!

    // for
    private var years: [Int] = []
    private var months: [Int] = []
    private var days: [Int] = []

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

        middle = UIView()
        middle.layer.cornerRadius = 24
        middle.layer.masksToBounds = true
        middle.layer.borderWidth = 2
        middle.layer.borderColor = UIColor.hexString("492AD2").cgColor
        pickView.addSubview(middle)
        middle.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 98, height: 48))
            make.center.equalToSuperview()
        }

        left = UIView()
        left.layer.cornerRadius = 24
        left.layer.masksToBounds = true
        left.layer.borderWidth = 2
        left.layer.borderColor = UIColor.hexString("492AD2").cgColor
        pickView.addSubview(left)
        left.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 98, height: 48))
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(1 / 3.0)
        }

        right = UIView()
        right.layer.cornerRadius = 24
        right.layer.masksToBounds = true
        right.layer.borderWidth = 2
        right.layer.borderColor = UIColor.hexString("492AD2").cgColor
        pickView.addSubview(right)
        right.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 98, height: 48))
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(5 / 3.0)
        }
    }

    private func setupDateData(date: Date) {
        self.date = date
        let calendar = NSCalendar.current
        let compt = calendar.dateComponents([.year, .month, .day], from: date)

        guard let currentYear = compt.year, let currentMonth = compt.month, let currentDay = compt.day else {
            return
        }

        var daysInCurrentMonth = 0
        if let range = calendar.range(of: .day, in: .month, for: date) {
            daysInCurrentMonth = range.count
        }

        for year in 1 ... currentYear {
            years.append(year)
        }

        for month in 1 ... 12 {
            months.append(month)
        }

        for day in 1 ... daysInCurrentMonth {
            days.append(day)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0) { [weak self] in
            self?.pickView.selectRow(currentMonth - 1, inComponent: self?.monthComponent ?? 0, animated: true)
            self?.pickView.selectRow(currentYear - 1, inComponent: self?.yearComponent ?? 2, animated: true)
            self?.pickView.selectRow(currentDay - 1, inComponent: self?.dayComponent ?? 1, animated: true)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LTDatePickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == yearComponent {
            return years.count
        }
        if component == monthComponent {
            return months.count
        }
        if component == dayComponent {
            return days.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return (UIScreen.main.bounds.width - 18 * 2) / 3.0
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 80
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
        } else if component == dayComponent {
            let day = days[row]
            itemView.label.text = "\(day)"
        }

        // viewCreate.backgroundColor = UIColor.randomColor
        return itemView
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("print component:\(component) row:\(row)")
        if component == yearComponent || component == monthComponent {
            // 更新天
            var datecomp = NSCalendar.current.dateComponents([.year, .month, .day], from: date)
            datecomp.year = years[pickerView.selectedRow(inComponent: yearComponent)]
            datecomp.month = months[pickerView.selectedRow(inComponent: monthComponent)]
            datecomp.day = 2 // days[pickView.selectedRow(inComponent: dayComponent)]
            guard let date = Calendar.current.date(from: datecomp as DateComponents) else { return }

            var daysInCurrentMonth = 0
            if let range = Calendar.current.range(of: .day, in: .month, for: date) {
                daysInCurrentMonth = range.count
            }

            days.removeAll()
            for day in 1 ... daysInCurrentMonth {
                days.append(day)
            }
            pickerView.reloadComponent(dayComponent)
        }

        // now Date
        var datecomp = NSCalendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        datecomp.year = years[pickerView.selectedRow(inComponent: yearComponent)]
        datecomp.month = months[pickerView.selectedRow(inComponent: monthComponent)]
        datecomp.day = days[pickView.selectedRow(inComponent: dayComponent)]
        date = Calendar.current.date(from: datecomp as DateComponents) ?? Date()

        if let mini = minimumDate, date.compare(mini) == .orderedAscending {
            setupDateData(date: mini)
        }
    }
}
