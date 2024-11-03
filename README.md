## PFL 2024/2025 Practical assignment 1
- Maria Vieira, up202204802
- Marta Cruz, up202205028

### ShortestPath Function Explanation

The shortestPath function identifies all shortest paths between two cities in a given RoadMap. The function first handles the base case where the starting and destination cities are the same, returning a single path. For other cases, it uses a breadth-first search (BFS) to find all paths between the cities. The BFS algorithm explores all possible paths from the source city, maintaining a queue of city-path pairs to track current positions and paths. When a path reaches the destination, it is stored. The function calculates the distance of each path using the pathDistance function, which sums distances between consecutive cities in a path. The minimum valid distance is determined, and paths matching this distance are returned.

The data structures used include lists for paths and adjacency representations, making path manipulations straightforward. The Maybe type is used to safely represent valid and invalid distances. The algorithm ensures comprehensive exploration and returns paths with the shortest total distance. BFS is selected because it explores all routes level by level, suitable for discovering paths with minimal number of connections, ensuring efficient and correct path discovery.

### Contribution of each member:
#### Maria Vieira: 50%
Tasks performed:  
- 1 - cities :: RoadMap -> [City]
- 3 - distance :: RoadMap -> City -> City -> Maybe Distance
- 5 - pathDistance :: RoadMap -> Path -> Maybe Distance
- 7 - isStronglyConnected :: RoadMap -> Bool

#### Marta Cruz: 50%
Tasks performed:  
- 2 - areAdjacent :: RoadMap -> City -> City -> Bool
- 4 - adjacent :: RoadMap -> City -> [(City,Distance)]
- 6 - rome :: RoadMap -> [City]
- 8 - shortestPath :: RoadMap -> City -> City -> [Path]

