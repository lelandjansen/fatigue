struct TopologicalSort<T: Hashable> {
    
    static func sort(_ graph: Dictionary<T, Set<T>>) -> [T] {
        // Precondition: Graph must be acyclic
        var discovered = Set<T>()
        var stack = [T]()
        
        func topologicalSort(_ node: T) {
            discovered.insert(node)
            for neighbor in graph[node]! {
                if !discovered.contains(neighbor) {
                    topologicalSort(neighbor)
                    discovered.insert(neighbor)
                }
            }
            stack.append(node)
        }
        
        for (node, _) in graph {
            if !discovered.contains(node) {
                topologicalSort(node)
            }
        }
        
        return stack.reversed()
    }
    
}
