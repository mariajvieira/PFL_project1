import qualified Data.List
import qualified Data.Array
import qualified Data.Bits
import Data.Time.Format.ISO8601 (yearFormat)

-- PFL 2024/2025 Practical assignment 1

-- Uncomment the some/all of the first three lines to import the modules, do not change the code of these lines.

type City = String
type Path = [City]
type Distance = Int

type RoadMap = [(City,City,Distance)]

cities :: RoadMap -> [City]
cities x = Data.List.nub (map (\(x,y,z) -> x) x ++ map (\(x,y,z) -> y) x)

areAdjacent :: RoadMap -> City -> City -> Bool
areAdjacent [] _ _ = False
areAdjacent ((x,y,_):xs) c1 c2
    | (x == c1 && y == c2) || (x == c2 && y == c1) = True
    | otherwise = areAdjacent xs c1 c2

distance :: RoadMap -> City -> City -> Maybe Distance
distance [] _ _ = Nothing
distance ((x,y,dist):rs) c1 c2 
    |x==c1 && y==c2   = Just dist
    |x==c2 && y==c1   = Just dist
    |otherwise        =distance rs c1 c2


adjacent :: RoadMap -> City -> [(City,Distance)]
adjacent = undefined


pathDistance :: RoadMap -> Path -> Maybe Distance  
pathDistance _ [n] = Nothing
pathDistance r p = pathDistanceAux r p

pathDistanceAux :: RoadMap -> Path -> Maybe Distance  
pathDistanceAux [] _ = Nothing
pathDistanceAux _ [] = Nothing
pathDistanceAux _ [n] = Just 0
pathDistanceAux roadmap (p1:p2:ps) =
    case distance roadmap p1 p2 of 
        Just dist  -> addMaybe (Just dist) (pathDistanceAux roadmap (p2:ps))
        Nothing    ->  Nothing

-- Auxiliary function for adding Maybe variables
addMaybe :: Maybe Distance -> Maybe Distance -> Maybe Distance
addMaybe (Just x) (Just y) = Just (x + y) 
addMaybe _ _ = Nothing


rome :: RoadMap -> [City]
rome = undefined

isStronglyConnected :: RoadMap -> Bool
isStronglyConnected = undefined

shortestPath :: RoadMap -> City -> City -> [Path]
shortestPath = undefined

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