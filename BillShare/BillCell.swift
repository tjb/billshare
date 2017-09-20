//
//  BillCell.swift
//  BillShare
//
//  Created by Tyler Bobella on 9/4/17.
//  Copyright © 2017 Tyler Bobella. All rights reserved.
//

import UIKit

class BillCell: UICollectionViewCell {
    
    var bill: Bill? {
        didSet {
            setupViews()
        }
    }
    
    var companyLabel: UILabel?
    var dueInLabel: UILabel?
    var amountDueLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        self.companyLabel = {
            let companyLabel = UILabel()
            companyLabel.text = self.bill?.name
            companyLabel.textAlignment = .left
            companyLabel.translatesAutoresizingMaskIntoConstraints = false
            return companyLabel
        }()
        
        self.dueInLabel = {
            let dueInLabel = UILabel()
            dueInLabel.text = "Due in \(self.getNumberOfDays()) days"
            dueInLabel.textColor = UIColor.darkGray
            dueInLabel.font = UIFont.italicSystemFont(ofSize: 10)
            dueInLabel.translatesAutoresizingMaskIntoConstraints = false
            return dueInLabel
        }()
        
        self.amountDueLabel = {
            let amountDueLabel = UILabel()
            if let price = self.bill?.price,
                let percentage = self.bill?.percentages?.first,
                let amountDue = Double().getProperAmountDue(price: price, percentage: percentage)  {
                amountDueLabel.text = Double().currencyFormatter(value: amountDue)
            }
            amountDueLabel.textAlignment = .center
            amountDueLabel.translatesAutoresizingMaskIntoConstraints = false
            return amountDueLabel
        }()
        
        if let companyLabel = self.companyLabel, let dueInLabel = self.dueInLabel, let amountDueLabel = self.amountDueLabel {
            self.addSubview(companyLabel)
            self.addSubview(dueInLabel)
            self.addSubview(amountDueLabel)
            self.setupConstraints(["companyLabel": companyLabel, "dueInLabel": dueInLabel, "amountDuelabel": amountDueLabel])
        }
    }
    
    private func setupConstraints(_ cellViews: [String: UIView]) {
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[companyLabel]-25-[dueInLabel]-|", options: NSLayoutFormatOptions(), metrics: nil, views: cellViews))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[dueInLabel]-|", options: NSLayoutFormatOptions(), metrics: nil, views: cellViews))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[companyLabel]-|", options: NSLayoutFormatOptions(), metrics: nil, views: cellViews))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-250-[amountDuelabel]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: cellViews))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[amountDuelabel]-|", options: NSLayoutFormatOptions(), metrics: nil, views: cellViews))
    }
    
    private func getNumberOfDays() -> Int {
        let calendar = NSCalendar.current
        
        if let dueDate = self.bill?.dueDate {
            let diff = calendar.component(.day, from: dueDate)
            return diff
        }
        
        return 0
    }
    
}

extension Date {
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
    
}

extension Double {
    
    func currencyFormatter(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let amount = formatter.string(from: value as NSNumber) {
            return amount
        }
        return "$0.00"
    }
    
    func getProperAmountDue(price: Double, percentage: Percentage) -> Double? {
        // wtf is this shit
        if let percent = percentage.percentage?.doubleValue {
            var toMultiple = percent
            var toPay = price
            toMultiple.divide(by: Double(100.00))
            toPay.multiply(by: toMultiple)
            return toPay
        }
        return 0.00
    }
    
}
