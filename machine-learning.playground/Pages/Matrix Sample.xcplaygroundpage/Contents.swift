// Machine Learning Samples
// Some Swift code to go along with the Machine Learning course on Coursera by Andrew Ng
// Created by Sidhant Gandhi
// 2015

let A = Matrix(array2d:[[1, 2, 3, 4, 5], [6, 7, 8, 9, 10]])
A.rows
A.columns
A.column(1)
A.row(1)
A[0, 2]
A.description
// try A + A

do {
    let Aa = try A + A
    Aa.rows
    Aa.columns
} catch {
    print("Something went wrong!")
}

let B = Matrix(array2d: [[1, 0, 3], [2, 1, 5], [3, 1, 2]])
let C = Matrix(array2d: [[1], [6], [2]])

do {
    let D = try B * C
    D.rows
    D.columns
} catch {
    print("Something went wrong!")
}

B *! C // Force multiply

let E = Matrix.identity(4)
E.row(0)
E.row(1)
E.row(2)
E.row(3)

B == B *! Matrix.identity(B.columns) // Check identity

var F = Matrix(array2d: [[1, 2, 3, 4], [5, 6, 7, 8]])
F.row(0)
F.row(1)
F|- // Transpose
F.row(0)
F.row(1)
F.row(2)
F.row(3)

var G = Matrix(array2d: [[0, 3], [1, 4]])
G|-

var H = Matrix(array2d: [[1, 3, -1]])
var I = Matrix(array: [2, 2, 4], rows: 3, columns: 1)

H *! I
