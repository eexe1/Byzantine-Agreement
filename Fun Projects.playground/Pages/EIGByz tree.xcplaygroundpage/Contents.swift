//: [Previous](@previous)
import UIKit
import PlaygroundSupport

enum GUISize {
    static let width: CGFloat = 500
    static let height: CGFloat = 500
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

// add the general
agents.append(general)

// start communication

// round 0 : set initial to each node
// assume general says Attack
for agent in agents {
    // append initial message
    if let agent = agent {
        agent.message.append(Message(order: .Attack, originArray: [agent], destination: agent))
    }
}

// propagate the messages for t + 1 rounds
// since it needs t + 1 round to reach Byzantine Agreement
for r in 1...Constants.sizeOfTraitor + 1{
    // each round
    print("round \(r) starts")
    for (_, agent) in agents.enumerated() {
        for message in agent!.message {
            if let message = message {
                // relay to everyone including itself
                for m_agent in agents {
                    if let m_agent = m_agent {
                        if m_agent.isTraitor {
                            relayEvilMessage(message, sender: agent!, receiver: m_agent)
                        }
                        else {
                            relayMessage(message, sender: agent!, receiver: m_agent)
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

// draw agent1's EIG tree
var agent1 = agents[0]
let initialOrder = Message.orderToElement(Order.Attack)
var root = Node(initialOrder, identifier: agent1!.name! + "0")
var agent1Tree = Tree.init(root)

// convert
let messages: [Message?] = agent1!.message
let dic = Message.convert(messages: messages)
print("\(dic)")

UIGraphicsBeginImageContextWithOptions(CGSize(width: GUISize.width, height: GUISize.height), false, 0)

let grid = Grid(bounds: CGRect(x: 0, y: 0, width: GUISize.width, height: GUISize.height))
grid.draw()

TreeRenderer.drawTree(agent1Tree, width: GUISize.width, height: GUISize.height)

let im = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: GUISize.width, height: GUISize.height))
containerView.addSubview(UIImageView(image: im))
PlaygroundPage.current.liveView = containerView

