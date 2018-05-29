public class Node {
    // ensure each node has a unique element
    public var element: Int
    public var identifier: String
    public var nodes: [Node]?
    
    public init(_ element: Int, identifier: String, nodes: [Node]? = nil) {
        self.element = element
        self.nodes = nodes
        self.identifier = identifier
    }
}

extension Node {
    public static func printNode(_ node:Node, indent: String = "", isLast: Bool = false) {
        print(indent + "+-" + String(node.element))
        var nextIndext = indent
        nextIndext += isLast ? "   " : "|  "
        if let nodes = node.nodes {
            for i in 0..<nodes.count {
                printNode(nodes[i], indent: nextIndext, isLast: i == nodes.count-1)
            }
        }
    }
    public func add(_ node: Node) {
        guard let _ = self.nodes else {
            self.nodes = [node]
            return
        }
        self.nodes!.append(node)
    }
    public static func getDic(_ p: Node, coloumn: Int = 0, level: Int = 0, childOffset: Int = 0) -> [String: Node]{
        var dic = [String(coloumn) + "," + String(level) : p]
        if let nodes = p.nodes {
            var length = childOffset
            for i in 0..<nodes.count {
                dic.merge(getDic(nodes[i], coloumn: i + length, level: level+1, childOffset: length), uniquingKeysWith: { (first, _) in first })
                if let count = nodes[i].nodes?.count {
                    length += count
                }
            }
        }
        return dic
    }
}

extension Node: Equatable {
    public static func == (lhs: Node, rhs: Node) -> Bool {
        return
            lhs.identifier == rhs.identifier
    }
}
