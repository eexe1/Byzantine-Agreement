//: Playground - Byzantine Agreement: demonstration of identifying traitors
// Author: Evan Tsai

import Foundation

struct Constants {
    // exclude the general
    static let sizeOfAgents = 3
    // sizeOfAgents > 3 * sizeOfTraitor
    static let sizeOfTraitor = 1
    static let sizeOfHonest = sizeOfAgents - sizeOfTraitor
}

enum Order: String {
    case Attack = "attack"
    case Retreat = "retreat"
}

struct Message {
    var originArray = [Agent]()
    var destination: Agent
    var order: Order
    init(order: Order, originArray: [Agent], destination: Agent) {
        self.order = order
        self.originArray = originArray
        self.destination = destination
    }
}

class Agent: Equatable {
    var round: Int = 0
    var isTraitor = false
    var name: String?
    var message = [Message?]()
    // messages received in this round (do not propagate them)
    var curMessages = [Message]()
    init(traitor: Bool, name: String) {
        isTraitor = traitor
        self.name = name
    }
    static func == (lhs: Agent, rhs: Agent) -> Bool {
        return lhs.name! == rhs.name!
    }
}

class General: Agent {
    init() {
        super.init(traitor: false, name: "G")
    }
}

// honest agents
func relayMessage(_ message:Message, sender: Agent, receiver:Agent) {
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
func relayEvilMessage(_ message: Message, sender: Agent, receiver:Agent) {
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

func roundCompleted(_ agents: [Agent?]) {
    for agent in agents {
        agent!.message.append(contentsOf: agent!.curMessages)
    }
}

func printMessage(_ agent: Agent) {
    for message in agent.message {
        var chain = ""
        for origin in (message?.originArray.reversed())! {
            chain += " \(origin.name!) says"
        }
        print("\(agent.name!) says\(chain) \((message?.order)!)")
    }
}

// program starts

var general = General()
var agents = [Agent?]()

for i in 1...Constants.sizeOfHonest {
    let s = String(UnicodeScalar(UInt8(96+i)))
    agents.append(Agent(traitor: false, name: s))
    
}

// add traitor
for i in 1...Constants.sizeOfTraitor {
    let s = String(UnicodeScalar(UInt8(96+i+Constants.sizeOfHonest)))
    agents.append(Agent(traitor: true, name: s))
}

// start communication

// round 0 : general sends to everyone
// assume general says Attack
for agent in agents {
    let message = Message(order: Order.Attack, originArray: [], destination: agent!)
    relayMessage(message, sender: general, receiver: agent!)
    printMessage(agent!)
}

// add the general
agents.append(general)

roundCompleted(agents)

// propagate the messages
// it needs t + 1 round to identify traitors
for r in 1...Constants.sizeOfTraitor + 1{
    // each round
    print("round \(r) starts")
    for (index, agent) in agents.enumerated() {
        for message in agent!.message {
            if let message = message {
                // relay to others
                let remainingAgents = agents.filter{ $0?.name != agent!.name! }
                for remain in remainingAgents {
                    if let remain = remain {
                        if agent!.isTraitor {
                            relayEvilMessage(message, sender: agent!, receiver: remain)
                        }
                        else {
                            relayMessage(message, sender: agent!, receiver: remain)
                        }
                    }
                }
            }
        }
    }
    roundCompleted(agents)
    // print agents
    for agent in agents {
        printMessage(agent!)
        print("agent: \(agent!.name!) end")
    }
    print("round \(r) completed")
}

