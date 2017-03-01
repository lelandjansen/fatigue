struct LongestPath<T: Hashable> {
    
    static func length(forGraph graph: Dictionary<T, Set<T>>, toNode destination: T) -> Int {
        
        var lengthTo = Dictionary<T, Int>()
        
        for node in TopologicalSort.sort(graph) {
            if !lengthTo.keys.contains(node) {
                lengthTo[node] = 0
            }
            
            for neighbor in graph[node]! {
                if !lengthTo.keys.contains(neighbor) {
                    lengthTo[neighbor] = 0
                }
                
                if lengthTo[neighbor]! < lengthTo[node]! + 1 {
                    lengthTo[neighbor]! = lengthTo[node]! + 1
                }
            }
        }
        
        return lengthTo[destination]!
    }
    
}
