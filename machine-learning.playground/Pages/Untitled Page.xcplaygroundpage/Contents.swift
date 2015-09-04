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
