//
//  ViewController.swift
//  LotteryWinner
//
//  Created by 김하은 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet var lottoNumberLabels: [UILabel]! //당첨 번호
    @IBOutlet var drwNoTextField: UITextField! // 1077회
    @IBOutlet var drwNoDateLabel: UILabel! //로또 추첨일
    @IBOutlet var firstPrzwnerCoLabel: UILabel! //1등 당첨 복권수
    @IBOutlet var firstAccumamntLabel: UILabel! //1등 당첨금

    let pickerView = UIPickerView()
    let pickerViewList: [Int] = Array(1...1079).sorted(by: >)
    
    let lottoColor: [UIColor] = [UIColor(named: "lottoYello")!,UIColor(named: "lottoBlue")!, UIColor(named: "lottoRed")!, UIColor(named: "lottoGray")!, UIColor(named: "lottoGreen")!]
    var drwtNoArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = UIImageView.init(image: UIImage(named: "logo"))
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        drwNoTextField.inputView = pickerView
        drwNoTextField.tintColor = .clear
        drwNoTextField.delegate = self
        
        lottoAPI(drwNo: pickerViewList.max()!)
    }

    @IBAction func beforeButtonClick(_ sender: UIButton) {
        view.endEditing(true)
        guard let text = Int((drwNoTextField.text?.dropLast(1))!) else { return }
        lottoAPI(drwNo: text - 1)
    }
    
    @IBAction func afterButtonClick(_ sender: Any) {
        view.endEditing(true)
        guard let text = Int((drwNoTextField.text?.dropLast(1))!) else { return }

        if text + 1 > 1079{
            let alert = UIAlertController(title: "알림", message: "등록된 회차가 아닙니다!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default){_ in
                self.lottoAPI(drwNo: 1079)
            }
            alert.addAction(ok)
            present(alert, animated: true)
        }else{
            lottoAPI(drwNo: text + 1)
        }
    }
    
    @IBAction func keyboardDown(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
extension ViewController{
    func lottoAPI(drwNo: Int){
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNo)"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                self.drwtNoArray.append(json["drwtNo1"].rawString()!)
                self.drwtNoArray.append(json["drwtNo2"].rawString()!)
                self.drwtNoArray.append(json["drwtNo3"].rawString()!)
                self.drwtNoArray.append(json["drwtNo4"].rawString()!)
                self.drwtNoArray.append(json["drwtNo5"].rawString()!)
                self.drwtNoArray.append(json["drwtNo6"].rawString()!)
                self.drwtNoArray.append(json["bnusNo"].rawString()!)
                print(json)
                
                self.drwNoTextField.text = "\(json["drwNo"].rawString()!)회"
                self.drwNoDateLabel.text =  json["drwNoDate"].rawString()!
                self.firstPrzwnerCoLabel.text =
                "\(json["firstPrzwnerCo"].rawString()!)개"
                self.firstAccumamntLabel.text =
                self.numberFormatter(number: json["firstAccumamnt"].intValue)
                
                self.designView()
                
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func designView(){
        
        for (index, lottoNumberLabel) in lottoNumberLabels.enumerated(){
            lottoNumberLabel.layer.cornerRadius = lottoNumberLabel.frame.height / 2
            lottoNumberLabel.textColor = .white
            
            //로또번호는 숫자마다 색이 지정되어 있다는 소문을 들음
            switch Int(drwtNoArray[index])!{
            case ...10: lottoNumberLabel.layer.backgroundColor = lottoColor[0].cgColor
                case ...20: lottoNumberLabel.layer.backgroundColor = lottoColor[1].cgColor
                case ...30: lottoNumberLabel.layer.backgroundColor = lottoColor[2].cgColor
                case ...40: lottoNumberLabel.layer.backgroundColor = lottoColor[3].cgColor
                case ...45: lottoNumberLabel.layer.backgroundColor = lottoColor[4].cgColor
            default:
                lottoNumberLabel.layer.backgroundColor = lottoColor[0].cgColor
            }
            
            lottoNumberLabel.text = drwtNoArray[index]
            lottoNumberLabel.font = .boldSystemFont(ofSize: 20)
        }
    }
    
    //1등 당첨액 콤마 넣어주기
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return "\(numberFormatter.string(from: NSNumber(value: number))!)원"
    }
}

extension ViewController:UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerViewList[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        lottoAPI(drwNo: pickerViewList[row])
    }
   
    //textField 입력 못하게..?
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
