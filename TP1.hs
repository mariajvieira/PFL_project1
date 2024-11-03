import qualified Data.List
import qualified Data.Array
import qualified Data.Bits

-- PFL 2024/2025 Practical assignment 1

type City = String
type Path = [City]
type Distance = Int
type RoadMap = [(City, City, Distance)] 

-- Extracts all unique cities from the RoadMap
cities :: RoadMap -> [City]
cities x = Data.List.nub (map (\(x, y, z) -> x) x ++ map (\(x, y, z) -> y) x) -- Data.List.nub removes duplicates 

-- Checks if two given cities are adjacent in the RoadMap
areAdjacent :: RoadMap -> City -> City -> Bool
areAdjacent [] _ _ = False -- If RoadMap is empty, cities are not adjacent
areAdjacent ((x, y, _):xs) c1 c2
    | (x == c1 && y == c2) || (x == c2 && y == c1) = True 
    | otherwise = areAdjacent xs c1 c2

-- Finds the distance between two cities
distance :: RoadMap -> City -> City -> Maybe Distance
distance [] _ _ = Nothing -- If RoadMap is empty, no distance exists
distance ((x, y, dist):rs) c1 c2 
    | x == c1 && y == c2 = Just dist 
    | x == c2 && y == c1 = Just dist 
    | otherwise = distance rs c1 c2

-- Lists all cities adjacent to the given city with their distances
adjacent :: RoadMap -> City -> [(City, Distance)]
adjacent roadmap city = [(y, dist) | (x, y, dist) <- roadmap, x == city] ++ [(x, dist) | (x, y, dist) <- roadmap, y == city]


-- Computes the total distance of a given path, returns Nothing if the path is invalid
pathDistance :: RoadMap -> Path -> Maybe Distance  
pathDistance _ [n] = Nothing -- Only one city: has no distance
pathDistance r p = pathDistanceAux r p -- Calls auxiliary function to calculate the distance

-- Auxiliary function of pathDistance
pathDistanceAux :: RoadMap -> Path -> Maybe Distance  
pathDistanceAux [] _ = Nothing -- Empty RoadMap
pathDistanceAux _ [] = Nothing -- Empty path
pathDistanceAux _ [n] = Just 0 -- Last city
pathDistanceAux roadmap (p1:p2:ps) =
    case distance roadmap p1 p2 of 
        Just dist -> addMaybe (Just dist) (pathDistanceAux roadmap (p2:ps)) 
        Nothing -> Nothing 

-- Auxiliary function for adding Maybe variables without imports
addMaybe :: Maybe Distance -> Maybe Distance -> Maybe Distance
addMaybe (Just x) (Just y) = Just (x + y) 
addMaybe _ _ = Nothing 

-- Finds the cities with the highest number of roads
rome :: RoadMap -> [City]
rome roadmap = [x | x <- allCities, numRoads x == highestNumRoads]
    where
        allCities = cities roadmap 
        numRoads x = length(adjacent roadmap x) -- Counts the number of roads connected to a city
        highestNumRoads = maximum (map numRoads allCities) -- Finds the maximum number of roads

-- Auxiliary function of isStronglyConnected
-- Depth-first search implementation to explore cities
dfs :: RoadMap -> City -> [City] -> [City]
dfs _ city visited | city `elem` visited = visited -- If the city has already been visited
dfs roadmap city visited =
    let newVisited = city : visited -- Marks city as visited
        neighbors = map fst (adjacent roadmap city) 
    in foldl (\acc nextCity -> dfs roadmap nextCity acc) newVisited neighbors 

-- Checks if the graph represented by the RoadMap is strongly connected
isStronglyConnected :: RoadMap -> Bool
isStronglyConnected roadmap = all reachableFrom allCities
  where
    allCities = cities roadmap 
    reachableFrom city = 
        let visited = dfs roadmap city [] -- Performs DFS from the given city
        in length visited == length allCities -- Checks if all cities were visited


-- Auxiliary function of shortestPath
-- Breadth-first search implementation to find all paths from one city to another
bfs :: RoadMap -> City -> City -> [Path]
bfs roadmap c1 c2 = bfsHelper [(c1, [c1])] 
  where
    bfsHelper :: [(City, Path)] -> [Path]
    bfsHelper [] = [] -- No more paths to explore
    bfsHelper ((current, path):rest)
        | current == c2 = path : bfsHelper rest -- Adds path to results if the destination is reached
        | otherwise = bfsHelper (rest ++ nextPaths) 
      where
        nextPaths = [(nextCity, path ++ [nextCity]) |
                     (nextCity, _) <- adjacent roadmap current,
                     not (nextCity `elem` path)] -- No revisiting cities in the same path


-- Finds all shortest paths between two cities
shortestPath :: RoadMap -> City -> City -> [Path]
shortestPath roadmap c1 c2 
    | c1 == c2 = [[c1]] -- Path from a city to itself
    | otherwise = 
        let allPaths = bfs roadmap c1 c2 -- Finds all paths using BFS
            distances = [(path, pathDistance roadmap path) | path <- allPaths] -- Calculates distances for each path
            minDistance = minimum [d | (_, Just d) <- distances, d >= 0] -- Finds the minimum valid distance
        in [path | (path, Just dist) <- distances, dist == minDistance] -- Filters paths with the minimum distance


travelSales :: RoadMap -> Path
travelSales = undefined

tspBruteForce :: RoadMap -> Path
tspBruteForce = undefined -- only for groups of 3 people; groups of 2 people: do not edit this function

-- Some graphs to test your work
gTest1 :: RoadMap
gTest1 = [("7","6",1),("8","2",2),("6","5",2),("0","1",4),("2","5",4),("8","6",6),("2","3",7),("7","8",7),("0","7",8),("1","2",8),("3","4",9),("5","4",10),("1","7",11),("3","5",14)]

gTest2 :: RoadMap
gTest2 = [("0","1",10),("0","2",15),("0","3",20),("1","2",35),("1","3",25),("2","3",30)]

gTest3 :: RoadMap -- unconnected graph
gTest3 = [("0","1",4),("2","3",2)]
