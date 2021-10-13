import UIKit

var greeting = "Hello, playground"
struct ExcahngeRate{
    var currencyRate : Double = 1{
        willSet{
            print("currencyRate willSet - 환율 변동 예정 : \(currencyRate) -> \(newValue)")
        }
        didSet{
            print("currencyRate didSet - 환율 변동 완료 : \(oldValue) -> \(currencyRate)")
        }
    }
    var KRW : Double = 0{
        didSet{
            print("USD didSet - KRW: \(oldValue) -> \( KRW / currencyRate) 달라로 환전되었음")
        }
        willSet{
            print("USD willSet - 환전 금액 : USD \(newValue / currencyRate) 달러로 환전될 예정")
        }
    }
    var USD : Double = 0{
        didSet{
            print("KRW didSet - USD: \(oldValue) -> \(USD * currencyRate) 원으로 환전되었음")
            
        }
        willSet{
            print("KRW willSet - 환전 금액 : KRW \(newValue * currencyRate) 원으로 환전될 예정")
            
        }
    }
}



var rate = ExcahngeRate(currencyRate: 1100, USD: 1)
rate.KRW = 500000
rate.currencyRate = 1350
rate.KRW = 500000

