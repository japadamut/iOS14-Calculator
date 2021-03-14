//
//  HomeViewController.swift
//  iOS-Calculator
//
//  Created by Juan A. Pujante Adamut on 13/03/2021.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Outlets
    
    // Result
    @IBOutlet weak var resultLabel: UILabel!
    
    //Numbers
    @IBOutlet weak var number0: UIButton!
    @IBOutlet weak var number1: UIButton!
    @IBOutlet weak var number2: UIButton!
    @IBOutlet weak var number3: UIButton!
    @IBOutlet weak var number4: UIButton!
    @IBOutlet weak var number5: UIButton!
    @IBOutlet weak var number6: UIButton!
    @IBOutlet weak var number7: UIButton!
    @IBOutlet weak var number8: UIButton!
    @IBOutlet weak var number9: UIButton!
    @IBOutlet weak var numberDecimal: UIButton!
    
    // Operators
    @IBOutlet weak var operatorAC: UIButton!
    @IBOutlet weak var operatorPlusMinus: UIButton!
    @IBOutlet weak var operatorPercent: UIButton!
    @IBOutlet weak var operatorResult: UIButton!
    @IBOutlet weak var operatorPlus: UIButton!
    @IBOutlet weak var operatorMinus: UIButton!
    @IBOutlet weak var operatorMultiplication: UIButton!
    @IBOutlet weak var operatorDivision: UIButton!
    
    // MARK: - Variables
    
    private var total: Double = 0                   // Total
    private var temp: Double = 0                    // Screen value
    private var opetating: Bool = false             // Touched operator?
    private var decimal: Bool = false               // Is decimal?
    private var operation: OperationType = .none    // Actual operation
    
    // MARK: - Constants
    
    private let kDecimalSeparator = Locale.current.decimalSeparator!
    private let kMaxLenght: Int = 9
    private let kTotal = "total"
    
    private enum OperationType {
        case none, addiction, substraction, multiplication,
             division, percent
    }
    
    // MARK: - Formatters
    
    // Formatting of auxiliary values
    private let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Formatting of total auxiliary values
    private let auxTotalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Formatting of default screen values
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    
    // Formatting of values by screen in scientific notation
    private let printScientificFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        number0.round()
        number1.round()
        number2.round()
        number3.round()
        number4.round()
        number5.round()
        number6.round()
        number7.round()
        number8.round()
        number9.round()
        numberDecimal.round()
        
        operatorAC.round()
        operatorPlusMinus.round()
        operatorPercent.round()
        operatorResult.round()
        operatorPlus.round()
        operatorMinus.round()
        operatorMultiplication.round()
        operatorDivision.round()
        
        numberDecimal.setTitle(kDecimalSeparator, for: .normal)
        
        total = UserDefaults.standard.double(forKey: kTotal)
        
        result()
    }

    // MARK: - Button actions
    
    @IBAction func operatorACAction(_ sender: UIButton) {
        
        clear()
        UserDefaults.standard.set(0, forKey: kTotal)
        sender.shine()
    }

    @IBAction func operatorPlusMinusAction(_ sender: UIButton) {
        
        temp *= (-1)
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        sender.shine()
    }
    
    @IBAction func operatorPercentAction(_ sender: UIButton) {
        
        if operation != .percent {
            result()
        }
        opetating = true
        operation = .percent
        result()
        sender.shine()
    }
    
    @IBAction func operatorResultAction(_ sender: UIButton) {
        
        result()
        sender.shine()
    }
    
    @IBAction func operatorPlusAction(_ sender: UIButton) {
        
        if operation != .none {
            result()
        }
        opetating = true
        operation = .addiction
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func operatorMinusAction(_ sender: UIButton) {

        if operation != .none {
            result()
        }
        opetating = true
        operation = .substraction
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func operatorMultiplicationAction(_ sender: UIButton) {
        
        if operation != .none {
            result()
        }
        opetating = true
        operation = .multiplication
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func operatorDivisionAction(_ sender: UIButton) {
        
        if operation != .none {
            result()
        }
        opetating = true
        operation = .division
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func numberDecimalAction(_ sender: UIButton) {
        
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))
        if !opetating && currentTemp!.count >= kMaxLenght {
            return
        }
        resultLabel.text = resultLabel.text! + kDecimalSeparator
        decimal = true
        selectVisualOperation()
        sender.shine()
    }
    
    @IBAction func numberAction(_ sender: UIButton) {
        
        operatorAC.setTitle("C", for: .normal)
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))
        if !opetating && currentTemp!.count >= kMaxLenght {
            return
        }
        
        currentTemp = auxFormatter.string(from: NSNumber(value: temp))
        
        // Selected operation?
        if opetating {
            total = total == 0 ? temp : total
            resultLabel.text = ""
            currentTemp = ""
            opetating = false
        }
        
        // Selected decimal?
        if decimal {
            currentTemp = "\(String(describing: currentTemp))\(kDecimalSeparator)"
            decimal = false
        }
        
        let number = sender.tag
        temp = Double(currentTemp! + String(number))!
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        selectVisualOperation()
        sender.shine()
    }
    
    // Clear values
    private func clear() {
        if operation == .none {
            total = 0
        }
        operation = .none
        operatorAC.setTitle("AC", for: .normal)
        if temp != 0 {
            temp = 0
            resultLabel.text = "0"
        } else {
            total = 0
            result()
        }
    }
    
    // Get final result
    private func result() {
        
        switch operation {

        case .none:
            // No operation
            break
        case .addiction:
            total += temp
            break
        case .substraction:
            total -= temp
            break
        case .multiplication:
            total *= temp
            break
        case .division:
            total /= temp
            break
        case .percent:
            temp /= 100
            total = temp
            break
        }
        
        // Screen format
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > kMaxLenght {
            
            resultLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
        } else {
            
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
                
        operation = .none
        
        selectVisualOperation()
        
        UserDefaults.standard.set(total, forKey: kTotal)
        
        print("TOTAL: \(total)")
        
    }
    
    private func selectVisualOperation () {
        
        if opetating {
            
            switch operation {
            
                case .none, .percent:
                    operatorPlus.selectOperation(false)
                    operatorMinus.selectOperation(false)
                    operatorMultiplication.selectOperation(false)
                    operatorDivision.selectOperation(false)
                    break
                case .addiction:
                    operatorPlus.selectOperation(true)
                    operatorMinus.selectOperation(false)
                    operatorMultiplication.selectOperation(false)
                    operatorDivision.selectOperation(false)
                    break
                case .substraction:
                    operatorPlus.selectOperation(false)
                    operatorMinus.selectOperation(true)
                    operatorMultiplication.selectOperation(false)
                    operatorDivision.selectOperation(false)
                    break
                case .multiplication:
                    operatorPlus.selectOperation(false)
                    operatorMinus.selectOperation(false)
                    operatorMultiplication.selectOperation(true)
                    operatorDivision.selectOperation(false)
                    break
                case .division:
                    operatorPlus.selectOperation(false)
                    operatorMinus.selectOperation(false)
                    operatorMultiplication.selectOperation(false)
                    operatorDivision.selectOperation(true)
                    break
            }
        } else {
            
            operatorPlus.selectOperation(false)
            operatorMinus.selectOperation(false)
            operatorMultiplication.selectOperation(false)
            operatorDivision.selectOperation(false)
        }
        
    }
    
}
