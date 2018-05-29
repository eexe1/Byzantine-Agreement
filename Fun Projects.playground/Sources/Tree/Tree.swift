public class Tree {
    public var root: Node
    
    public init(_ root: Node = Node.init(0, identifier: "A")) {
        self.root = root
    }
}

extension Tree {
    public func printTree() {
        Node.printNode(self.root)
    }
}
