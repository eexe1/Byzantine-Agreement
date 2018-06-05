//: [Previous](@previous)
/*:
 EIG Tree shown in text in Console.
 
 EIG Tree shown in GUI.
 
 aab:0 means an agent receives b says a says 0(Retreat)/1(Attack)
 
 Each upper level node's decision is made by the majority of its leaves.
 
 i.e. branch a shows that 2 attacks 1 retreat, therefore the decision is attack
 
 +-a:0 (not updated by the program yet)
 
 |  |  +-aab:1
 
 |  |  +-aaG:1
 
 |  |  +-aac:0
 
 continue to make decisions until you reach a top most node.
 
 */

import UIKit
import PlaygroundSupport


enum GUISize {
    static let width: CGFloat = 800
    static let height: CGFloat = 500
}

enum Constants {
    // agents excluded the general
    static let sizeOfAgents = 3
    // sizeOfAgents > 3 * sizeOfTraitor
    static let sizeOfTraitor = 1
    static let sizeOfHonest = sizeOfAgents - sizeOfTraitor
    // which tree to display
    static let treeDisplayIndex = 0
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
//    print("round \(r) starts")
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
//    print("round \(r) completed")
}

// convert each agent to a EIG tree
var treeArray = [Tree]()
for agent in agents {
    if let agent = agent {
        let root = Node(0, identifier: agent.name! + "r")
        // convert
        let messages: [Message?] = agent.message
        let dic = Message.convert(messages: messages)
        let tree = TreeGenerator.initTree(agents: agents as! [Agent], dic: dic, root: root)
        
        print("----- tree starts -----")
        tree.printTree()
        print("----- tree ends -----")
        treeArray.append(tree)
    }
}

UIGraphicsBeginImageContextWithOptions(CGSize(width: GUISize.width, height: GUISize.height), false, 0)

let grid = Grid(bounds: CGRect(x: 0, y: 0, width: GUISize.width, height: GUISize.height))
grid.draw()

// we only draw one EIG tree
TreeRenderer.drawTree(treeArray[Constants.treeDisplayIndex], width: GUISize.width, height: GUISize.height)

let im = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: GUISize.width, height: GUISize.height))
containerView.addSubview(UIImageView(image: im))
PlaygroundPage.current.liveView = containerView

