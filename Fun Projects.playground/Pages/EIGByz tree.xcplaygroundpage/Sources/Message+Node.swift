import Foundation

extension Message {
    
    public static func convert(messages: [Message?]) -> [String: Node] {
        
        // key: node_identifier
        // i.e. first level: a,b,c,d
        // second level: under a node: ab,ac,ad
        // ["a":node,"b":node,"ab":node] stored in same dimension
        var dict = [String: Node]()
        for message in messages {
            var key = ""
            if let message = message {
                for origin in message.originArray.reversed() {
                    key += origin.name!
                }
                let element = orderToElement(message.order)
                dict[key] = Node.init(element, identifier: key)
            }
        }
        return dict
    }
    public static func orderToElement(_ order:Order) -> Int {
        switch order {
        case .Attack:
            return 1
        case .Retreat:
            return 0
        }
    }
}
