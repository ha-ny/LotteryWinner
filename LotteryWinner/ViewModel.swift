//
//  ViewModel.swift
//  LotteryWinner
//
//  Created by 김하은 on 2023/09/13.
//

import Foundation

class ViewModel {
    
    //아무 초기값이나 넣은거
    var drwtNo1 = Observable(value: "1")
    //drwtNo1.listner
    var drwtNo2 = Observable(value: "2")
    var drwtNo3 = Observable(value: "3")
    var drwtNo4 = Observable(value: "4")
    var drwtNo5 = Observable(value: "5")
    var drwtNo6 = Observable(value: "6")
    var bnusNo = Observable(value: "보너스 넘버")
}
