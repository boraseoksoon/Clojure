import Foundation

/// `cycle`
///
/// - Parameter upto:
/// - Parameter range:
func cycle(_ range: LazySequence<Array<Int>>, _ generator: Generator? = nil) {
    var generator = generator == nil ? Generator(start: range.first!) : generator
    
    let res = generator!.next()!
    if res >= range.last! {
        generator = Generator(start: range.first!)
    }
    
    return cycle(range, generator)
}

struct Generator: Sequence, IteratorProtocol {
    var start: Int
    var i = 1
    mutating func next()-> Int?{
        defer {
            start += 1
        }
        return start
    }
}

/// `take`
///
/// "Returns a lazy sequence of the first n items in coll, or all items if
/// there are fewer than n.  Returns a stateful transducer when
/// no collection is provided."
/// - Parameter n: number to take out of range
/// - Parameter range: given range of array
func take<S: Sequence>(_ n: Int, _ range: S) -> [S.Element] {
    zip(1...n, range).map { $1 }
}

/// `map`
///
/// "Returns a lazy sequence of the first n items in coll, or all items if
/// there are fewer than n.  Returns a stateful transducer when
/// no collection is provided."
/// - Parameter upto: number to take out of range
/// - Parameter range: given range of array
func map<A,B>(_ arr: [A], _ fn: ((A) -> B)) -> [B] where A: Equatable, B: Equatable {
    var res = [B]()

    for i in arr {
        res.append(fn(i))
    }

    return res
}

//let res2 = map(range(0, 10)) { String($0) }
// print(res2)
// ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

func filter<F>(_ arr: [F], _ fn: ((F) -> Bool)) -> [F] {
    var res = [F]()

    for i in arr {
        if fn(i) {
            res.append(i)
        }
    }

    return res
}

//let res3 = filter(range(0,6)) { $0 % 2 == 0 }
// print(res3)
// [0, 2, 4, 6]

//let arr = [1, 2, 3]
//var a: Int = 0

func reduce<F>(_ arr: [F], _ fn: ((F) -> F)) -> F where F: Numeric {
    var res: F = 0

    for i in arr {
        res += fn(i)
    }

    return res
}

//let sum = reduce(range(0, 100), +)
// print(sum)
// 5050

func range(_ from: Int, _ to: Int) -> LazySequence<Array<Int>> {
    Array((from...to)).lazy
}

