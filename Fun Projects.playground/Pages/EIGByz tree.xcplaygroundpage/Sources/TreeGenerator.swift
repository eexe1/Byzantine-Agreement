// generate a tree from a dictionary full of nodes
// key of dictionary indicates branchs and leaves
// i.e. abc : a branch, bc leaf (N level takes N characters)

public struct TreeGenerator {
    public static func initTree(agents: [Agent], dic: [String: Node], root: Node) -> Tree {
//        var nodeNames = Set<String>()
//        for agent in agents {
//            nodeNames.insert(agent.name!)
//        }
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
            // a bc abc
            var nodeIdentifier: [String] = key.nodeStringToArray()
            for (index, id) in nodeIdentifier.enumerated() {
                if nodeDic[id]?.nodes == nil {
                    nodeDic[id]?.nodes = [Node]()
                }
                if index+1 < nodeIdentifier.count-1 {
                    let node = Node.init(0, identifier: nodeIdentifier[index+1])
                    nodeDic[id]?.nodes!.append(node)
                } else if index+1 == nodeIdentifier.count-1 {
                    nodeDic[id]?.nodes!.append(node)
                }
            }
        }
        
        return tree
    }
}

extension String {
    // abbccc -> a bb ccc
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



