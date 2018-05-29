public class Agent: Equatable {
    public var round: Int = 0
    public var isTraitor = false
    public var name: String?
    public var message = [Message?]()
    // messages received in this round (do not propagate them)
    public var curMessages = [Message]()
    public init(traitor: Bool, name: String) {
        isTraitor = traitor
        self.name = name
    }
    public static func == (lhs: Agent, rhs: Agent) -> Bool {
        return lhs.name! == rhs.name!
    }
}
