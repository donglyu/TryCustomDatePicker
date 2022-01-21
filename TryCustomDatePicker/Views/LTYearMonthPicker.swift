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

    private var nowDateComonents: DateComponents!

    public var date: Date = Date()
    public var minimumDate: Date?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        nowDateComonents = NSCalendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            self?.setupDateData(date: self!.date)
        }
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
        
        // --- prepare.
        let calendar = NSCalendar.current
        let compt = calendar.dateComponents([.year, .month, .day], from: Date())
        guard let currentYear = compt.year else {
            return
        }
        
        let selectCompt = calendar.dateComponents([.year, .month, .day], from: date)
        guard let selectYear = selectCompt.year, let selectMonth = selectCompt.month else {
            return
        }

        // find star year.
        var yearStart = 1
        if let miniDate = minimumDate {
            let compt = calendar.dateComponents([.year, .month, .day], from: miniDate)
            yearStart = compt.year!
        }

        years.removeAll()
        for year in yearStart ... currentYear {
            years.append(year)
        }

        pickView.reloadAllComponents()

        let rowIndexForYear = years.firstIndex(of: selectYear) ?? years.count - 1
        let rowIndexForMonth = months.firstIndex(of: selectMonth) ?? months.count - 1

        resetMonthsDataByYearRow(row: rowIndexForYear)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.pickView.selectRow(rowIndexForMonth, inComponent: self?.monthComponent ?? 1, animated: true)
            self?.pickView.selectRow(rowIndexForYear, inComponent: self?.yearComponent ?? 0, animated: true)
        }
    }

    private func resetMonthsDataByYearRow(row: Int) {
        // 更新月份(根据最小时间的年月）可选择月份s
        var minMonth = 1
        var maxMonth = 12
        if let mini = minimumDate {
            let compt = NSCalendar.current.dateComponents([.year, .month, .day], from: mini)
            if compt.year == years[row] { // update months
                minMonth = compt.month!
            }
        }

        if years[row] == nowDateComonents.year {
            maxMonth = nowDateComonents.month!
        }

        print("now can select month: \(minMonth), max month: \(maxMonth)")

        months.removeAll()
        for month in minMonth ... maxMonth {
            months.append(month)
        }
        pickView.reloadComponent(monthComponent)
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
            resetMonthsDataByYearRow(row: row)
        }

        // now Date
        var datecomp = NSCalendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        datecomp.year = years[pickerView.selectedRow(inComponent: yearComponent)]
        let monthIndex = pickerView.selectedRow(inComponent: monthComponent)

        datecomp.month = months[monthIndex > months.count - 1 ? 0 : monthIndex]
        date = Calendar.current.date(from: datecomp as DateComponents) ?? Date()
        setupDateData(date: date)
    }
}
