// generate a tree from a dictionary full of nodes
// key of dictionary indicates branchs and leaves
// i.e. abc : a branch, bc leaf (N level takes N characters)

public struct TreeGenerator {
    
    /**
     dic only includes longest chains (leaves)
     */
    public static func initTree(agents: [Agent], dic: [String: Node], root: Node) -> Tree {
        var nodeDic = [String: Node]()
        // add a root node
        let tree = Tree.init(root)
        root.nodes = [Node]()
        // add agent nodes
        for agent in agents {
            let node = Node.init(0, identifier: agent.name!)
            nodeDic[agent.name!] = node
            root.nodes!.append(node)
        }
        for (key, node) in dic {
            // a & bc from abc
            var nodeIdentifier: [String] = key.nodeStringToArray()
            for (index, id) in nodeIdentifier.enumerated() {
                if nodeDic[id]?.nodes == nil {
                    nodeDic[id]?.nodes = [Node]()
                }
                if index+1 < nodeIdentifier.count-1 {
                    // if its next one is a node
                    let node = Node.init(0, identifier: nodeIdentifier[index+1])
                    nodeDic[id]?.nodes!.append(node)
                } else if index+1 == nodeIdentifier.count-1 {
                    // if its next one a leaf
                    nodeDic[id]?.nodes!.append(node)
                }
            }
        }
        
        _ = calc(parent: tree.root)
        
        return tree
    }
    /* return (attack count, retreat count) */
    public static func calc(parent: Node) -> (Int, Int) {
        if let nodes = parent.nodes {
            var majority = 0
            var result: (Int, Int) = (0, 0)
            for node in nodes {
                let score = calc(parent: node)
                result = (result.0 + score.0, result.1 + score.1)
            }
            let (attackCount, retreatCount) = result
            var pDecision = (0, 0)
            if attackCount > retreatCount {
                majority = 1
                pDecision = (1, 0)
            }
            parent.element = majority
            return pDecision
        } else {
            if parent.element == Message.orderToElement(.Attack) {
                return (1,0)
            } else {
                return (0,1)
            }
        }
        
    }
    
}



extension String {
    // abbccc -> a bb ccc
    // first len is 1, second is 2, ...etc
    func nodeStringToArray() -> [String] {
        var skip = 1
        var result = [String]()
        var sub: String = ""
        var count = 0
        for char in self {
            if skip > count {
                sub += "\(char)"
                count += 1
            }
            if skip == count {
                result.append(sub)
                sub = ""
                count = 0
                skip += 1
            }
        }
        return result
    }
    
}



