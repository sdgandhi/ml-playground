// Matrix.swift

/* This one is labeled for future blog post

struct Matrix: CustomStringConvertible { // 6 (CustomStringConvertible)
var raw: [[Double]] // 1
var rows: Int { return raw.count } // 2
var columns: Int { return raw[0].count } // 3

init?(_ array: [[Double]]) { // 4

guard array.count > 0 else { return nil }
guard array[0].count > 0 else { return nil } // TODO: Combine with above

let count = array[0].count
let equalElements = array.reduce(true) { return $1.count == count }
guard equalElements else { return nil }

raw = array
}

func element(row: Int, _ column: Int) -> Double? { // 5
guard raw.count > row && raw[0].count > column else { return nil }

return raw[row][column]
}

var description: String { return raw.reduce("") { $0 + $1.description + "\r\n" } } // 7
}

*/
enum MatrixError: ErrorType {
    case DimensionsMismatch(rowsA: Int, columnsA: Int, rowsB: Int, columnsB: Int)
    case OutOfBounds(index: Int, bounds: Int)
}

// MARK: Matrix operators
public func ==(lhs: Matrix, rhs: Matrix) -> Bool {
    return lhs.grid == rhs.grid
}

public func +(lhs: Matrix, rhs: Matrix) throws -> Matrix {
    guard lhs.rows == rhs.rows && lhs.columns == rhs.columns else { throw MatrixError.DimensionsMismatch(rowsA: lhs.rows, columnsA: lhs.columns, rowsB: rhs.rows, columnsB: rhs.columns) }
    
    var sum = [Double]()
    for i in 0..<lhs.grid.count {
        sum.append(lhs.grid[i] + rhs.grid[i])
    }
    
    return Matrix(array: sum, rows: lhs.rows, columns: lhs.columns)
}

public func *(lhs: Matrix, rhs: Matrix) throws -> Matrix {
    guard lhs.columns == rhs.rows else { throw MatrixError.DimensionsMismatch(rowsA: lhs.rows, columnsA: lhs.columns, rowsB: rhs.rows, columnsB: rhs.columns) }
    
    var productGrid = [Double]()
    for i in 0..<lhs.rows {
        let rowArray = lhs.row(i)
        
        for j in 0..<rhs.columns {
            let columnArray = rhs.column(j)
            
            var products = [Double]()
            for k in 0..<rowArray.count {
                products.append(rowArray[k] * columnArray[k])
            }
            
            productGrid.append(products.reduce(0) { $0 + $1 })
        }
    }
    
    return Matrix(array: productGrid, rows: lhs.rows, columns: rhs.columns)
}

infix operator *! { associativity left precedence 150 }
public func *!(lhs: Matrix, rhs: Matrix) -> Matrix {
    assert(lhs.columns == rhs.rows, "Mismatched dimensions in matrix multiplication")
    
    var productGrid = [Double]()
    for i in 0..<lhs.rows {
        let rowArray = lhs.row(i)
        
        for j in 0..<rhs.columns {
            let columnArray = rhs.column(j)
            
            var products = [Double]()
            for k in 0..<rowArray.count {
                products.append(rowArray[k] * columnArray[k])
            }
            
            productGrid.append(products.reduce(0) { $0 + $1 })
        }
    }
    
    return Matrix(array: productGrid, rows: lhs.rows, columns: rhs.columns)
}

postfix operator |- {} // Transpose
public postfix func |-(inout matrix: Matrix) -> Matrix {
    
    var T = Matrix(array: matrix.grid, rows: matrix.columns, columns: matrix.rows)
    
    for i in 0..<matrix.columns {
        T.setRow(i, array: matrix.column(i))
    }
    
    matrix = T
    
    return T
}

public struct Matrix: CustomStringConvertible, Equatable {
    private var grid: [Double]
    public let rows: Int, columns: Int

    // MARK: Initializers
    public init(array: [Double], rows: Int, columns: Int) {
        
        assert(rows > 0, "Cannot initialize matrix with 0 rows.")
        assert(columns > 0, "Cannot initialize matrix with 0 columns.")
        assert(array.count == (rows * columns), "Cannot initialize matrix when array length does not equal rows*columns.")
        
        self.rows = rows
        self.columns = columns
        self.grid = array
    }
    
    public init(array2d: [[Double]]) {
        
        assert(array2d.count > 0, "Cannot initialize matrix with empty array.")
        assert(array2d[0].count > 0, "Cannot initialize matrix with array that is partially empty.")
        let count = array2d[0].count
        let equalElements = array2d.reduce(true) { return $1.count == count }
        assert(equalElements, "Cannot initialize matrix with array that has unequal \"column elements\".")
        
        let flat = array2d.reduce([]) { $0 + $1 }
        self.init(array: flat, rows: array2d.count, columns: array2d[0].count)
    }
    
    // MARK: Public methods
    public func column(c: Int) -> [Double] {
        assert(self.columns > c, "Column index out of bounds.")
        
        var columnArray = [Double]()
        for i in 0..<self.rows {
            columnArray.append(self[i, c])
        }
        
        return columnArray
    }
    
    public mutating func setColumn(c: Int, array: [Double]) {
        assert(self.columns > c, "Column index out of bounds.")
        assert(self.rows == array.count, "Column length mismatch.")
        
        for i in 0..<self.rows {
            self[i, c] = array[i]
        }
    }
    
    public func row(r: Int) -> [Double] {
        assert(self.rows > r, "Row index out of bounds.")
        
        var rowArray = [Double]()
        for i in 0..<self.columns {
            rowArray.append(self[r, i])
        }
        
        return rowArray
    }
    
    public mutating func setRow(r: Int, array: [Double]) {
        assert(self.rows > r, "Row index out of bounds.")
        assert(self.columns == array.count, "Row length mismatch")
        
        for i in 0..<self.columns {
            self[r, i] = array[i]
        }
    }
    
    public subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
    
    public static func identity(dimension: Int) -> Matrix {
        
        let grid = [Double](count: dimension * dimension, repeatedValue: 0)
        var I = Matrix(array: grid, rows: dimension, columns: dimension)
        for i in 0..<dimension { I[i, i] = 1 }
        
        return I
    }
    
    // MARK: Private methods
    private func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    // MARK: CustomStringConvertible
    public var description: String { return grid.description }
}
