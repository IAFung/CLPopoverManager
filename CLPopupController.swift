//
//  CLPopupController.swift
//  CLDemo
//
//  Created by JmoVxia on 2019/12/28.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit

class CLPopupModel: NSObject {
    var title: String?
    var callback: (() -> Void)?
}

class CLPopupController: UIViewController {
    lazy var arrayDS: [CLPopupModel] = {
        let arrayDS = [CLPopupModel]()
        return arrayDS
    }()

    lazy var tableview: UITableView = {
        let tableview = UITableView()
        tableview.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        tableview.dataSource = self
        tableview.delegate = self
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        initData()
    }
}

extension CLPopupController {
    func initData() {
        do {
            let model = CLPopupModel()
            model.title = "翻牌弹窗(多次调用去重)"
            model.callback = { [weak self] in
                self?.showFlop()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "日历弹窗(排队)"
            model.callback = { [weak self] in
                self?.showCalendar()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "可拖拽弹窗(重叠-挂起)"
            model.callback = { [weak self] in
                self?.showDragView()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "一个按钮(惟一,移除之前,阻止后续弹窗)"
            model.callback = { [weak self] in
                self?.showOneAlert()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "两个按钮(替换之前的所有弹窗,但是不会移除排队的,也不会阻止之后的)"
            model.callback = { [weak self] in
                self?.showTwoAlert()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "加载弹窗(替换之前的所有弹窗,会移除排队的,但是不会阻止之后的)"
            model.callback = { [weak self] in
                self?.showLoading()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "成功弹窗"
            model.callback = { [weak self] in
                self?.showSuccess()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "错误弹窗"
            model.callback = { [weak self] in
                self?.showError()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "提示弹窗"
            model.callback = { [weak self] in
                self?.showTips()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "年月日选择"
            model.callback = { [weak self] in
                self?.showYearMonthDayDataPicker()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "时分选择"
            model.callback = { [weak self] in
                self?.showHourMinuteDataPicker()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "年月日时分选择"
            model.callback = { [weak self] in
                self?.showYearMonthDayHourMinuteDataPicker()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "BMI计算"
            model.callback = { [weak self] in
                self?.showBMIInput()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "一个输入框"
            model.callback = { [weak self] in
                self?.showOneInput()
            }
            arrayDS.append(model)
        }
        do {
            let model = CLPopupModel()
            model.title = "两个输入框"
            model.callback = { [weak self] in
                self?.showTwoInput()
            }
            arrayDS.append(model)
        }
    }
}

extension CLPopupController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayDS.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = arrayDS[indexPath.row].title
        return cell
    }
}

extension CLPopupController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = arrayDS[indexPath.row]
        model.callback?()
    }
}

extension CLPopupController {
    func showFlop() {
        let controller = CLPopupFlopController()
        controller.config.popoverMode = .interrupt
        CLPopoverManager.show(controller)
        CLPopoverManager.show(controller)
        CLPopoverManager.show(controller)
        CLPopoverManager.show(controller)
        CLPopoverManager.show(controller)
        CLPopoverManager.show(controller)
    }

    func showCalendar() {
        CLPopoverManager.showCalendar()
        CLPopoverManager.showFlop { config in
            config.identifier = "AAA"
        }
    }

    func showDragView() {
        CLPopoverManager.showDrag { configure in
            configure.shouldAutorotate = true
            configure.supportedInterfaceOrientations = .all
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showOneAlert(configCallback: { configure in
                configure.shouldAutorotate = true
                configure.supportedInterfaceOrientations = .all
                configure.allowsEventPenetration = true
                configure.autoHideWhenPenetrated = true
                configure.popoverMode = .interrupt
                configure.userInterfaceStyleOverride = .unspecified
            }, title: "我是插队模式", message: "我会插队")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            CLPopoverManager.showOneAlert(configCallback: { configure in
                configure.shouldAutorotate = true
                configure.supportedInterfaceOrientations = .all
                configure.allowsEventPenetration = true
                configure.autoHideWhenPenetrated = true
                configure.popoverMode = .suspend
                configure.userInterfaceStyleOverride = .unspecified
            }, title: "我是挂起模式", message: "我会挂起前面弹窗，关闭后恢复")
        }
    }

    func showOneAlert() {
        CLPopoverManager.showFlop()
        CLPopoverManager.showOneAlert(configCallback: { configure in
            configure.shouldAutorotate = true
            configure.supportedInterfaceOrientations = .all
            configure.allowsEventPenetration = true
            configure.autoHideWhenPenetrated = true
            configure.popoverMode = .unique
            configure.userInterfaceStyleOverride = .unspecified
        }, title: "我是一个按钮", message: "我有一个按钮")
        CLPopoverManager.showDrag()
    }

    func showTwoAlert() {
        CLPopoverManager.showLoading()
        CLPopoverManager.showSuccess()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showTwoAlert(configCallback: { configure in
                configure.shouldAutorotate = true
                configure.popoverMode = .replaceInheritSuspend
                configure.supportedInterfaceOrientations = .all
            }, title: "我是两个按钮", message: "我有两个按钮")
            CLPopoverManager.showDrag()
        }
    }

    func showSuccess() {
        CLPopoverManager.showSuccess(configCallback: { configure in
            configure.shouldAutorotate = true
            configure.supportedInterfaceOrientations = .all
        }, text: "显示成功", dismissCallback: {
            print("success animation dismiss")
        })
    }

    func showError() {
        CLPopoverManager.showError(text: "显示错误", dismissCallback: {
            print("error animation dismiss")
        })
    }

    func showLoading() {
        CLPopoverManager.showLoading()
        CLPopoverManager.showSuccess()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CLPopoverManager.showTwoAlert(configCallback: { configure in
                configure.shouldAutorotate = true
                configure.popoverMode = .replaceAll
                configure.supportedInterfaceOrientations = .all
            }, title: "我是两个按钮", message: "我有两个按钮")
            CLPopoverManager.showDrag()
        }
    }

    func showTips() {
        CLPopoverManager.showTips(text: "AAAAAAAAAAAAAAAAAAAA")
    }

    func showYearMonthDayDataPicker() {
        CLPopoverManager.showYearMonthDayDataPicker(yearMonthDayCallback: { year, month, day in
            print("选中-----\(year)年\(month)月\(day)日")
        })
    }

    func showHourMinuteDataPicker() {
        CLPopoverManager.showHourMinuteDataPicker(hourMinuteCallback: { hour, minute in
            print("选中-----\(hour)时\(minute)分")
        })
    }

    func showYearMonthDayHourMinuteDataPicker() {
        CLPopoverManager.showYearMonthDayHourMinuteDataPicker(yearMonthDayHourMinuteCallback: { year, month, day, hour, minute in
            print("选中-----\(year)年\(month)月\(day)日\(hour)时\(minute)分")
        })
    }

    func showBMIInput() {
        CLPopoverManager.showBMIInput(configCallback: { config in
        }, bmiCallback: { bmi in
            print("BMI-----\(bmi)")
        })
        CLPopoverManager.showOneInput(configCallback: { config in
            config.popoverMode = .suspend
        }, type: .pulse) { value in
            print("-----\(String(describing: value))")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            CLPopoverManager.showOneInput(configCallback: { config in
                config.popoverMode = .replaceInheritSuspend
            }, type: .heartRate) { value in
                print("-----\(String(describing: value))")
            }
        }
    }

    func showOneInput() {
        CLPopoverManager.showOneInput(type: .UrineVolume) { value in
            print("-----\(String(describing: value))")
        }
    }

    func showTwoInput() {
        CLPopoverManager.showTwoInput(type: .bloodPressure) { value1, value2 in
            print("-----\(String(describing: value1))----------\(String(describing: value2))")
        }
    }
}
