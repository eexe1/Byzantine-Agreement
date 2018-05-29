public enum Order: String {
    case Attack = "attack"
    case Retreat = "retreat"
}

public struct Message {
    public var originArray = [Agent]()
    public var destination: Agent
    public var order: Order
    public init(order: Order, originArray: [Agent], destination: Agent) {
        self.order = order
        self.originArray = originArray
        self.destination = destination
    }
}


// honest agents
public func relayMessage(_ message:Message, sender: Agent, receiver:Agent) {
    var origin = message.originArray
    if origin.contains(where: { (agent) -> Bool in
        if agent.name! == receiver.name! {
            if origin.index(of: agent) == 0 {
                // special case: skip when the initial agent is General
                return false
            }
            return true
        } else {
            return false
        }}) {
        // drop it due to a loop message
        return
    }
    origin.append(sender)
    let message = Message(order: message.order, originArray: origin, destination: receiver)
    receiver.curMessages.append(message)
}

// evil agents: assume always send the opposite order: retreat
public func relayEvilMessage(_ message: Message, sender: Agent, receiver:Agent) {
    var origin = message.originArray
    if origin.contains(where: { (agent) -> Bool in
        if agent.name! == receiver.name! {
            if origin.index(of: agent) == 0 {
                // special case: skip when the initial agent is General
                return false
            }
            return true
        } else {
            return false
        }}) {
        // drop it due to a loop message
        return
    }
    origin.append(sender)
    let message = Message(order: Order.Retreat, originArray: origin, destination: receiver)
    receiver.curMessages.append(message)
}


public func roundCompleted(_ agents: [Agent?]) {
    for agent in agents {
        agent!.message.append(contentsOf: agent!.curMessages)
    }
}


public func printMessage(_ agent: Agent) {
    for message in agent.message {
        var chain = ""
        for origin in (message?.originArray.reversed())! {
            chain += " \(origin.name!) says"
        }
        print("\(agent.name!) says\(chain) \((message?.order)!)")
    }
}

