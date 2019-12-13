struct NameConstant {
    
    let LoginConstant:[String: Any] = ["isLogin": false, "tokenAccess": ""]
    
    struct StoryBoardID {
        static let homeID = "HomeScene"
        static let groupID = "GroupScene"
        static let locationID = "LocationScene"
        static let dateID = "DateScene"
        static let searchID = "SearchScene"
        static let loginID = "LoginScene"
        static let summayID = "SummaryScene"
        static let paymentID = "PaymentScene"
    }
    
    struct SegueID {
        static let groupID = "GotoGroup"
        static let locationID = "GotoLocation"
        static let dateID = "GotoDate"
        static let itemID = "GotoItem"
        static let itemToLoginID = "OrderToLogin"
        static let itemToSummayID = "OrderToSummary"
        static let summaryToPaymentID = "SummaryToPayment"
        static let homeToLoginID = "HomeToLogin"
    }
    
    struct ButtonID {
        static let groupID = "GroupButton"
        static let locationID = "LocationButton"
        static let dateID = "DateButton"
        static let searchID = "SearchButton"
    }
    
    struct TextFieldID {
        static let userNameID = "UserName"
        static let passwordID = "Password"
    }
}
