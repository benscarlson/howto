library(deSolve)
ode() #General Solver for Ordinary Differential Equations

eigen(mymatrix) #calculate eigen values and eigen vectors

#---- matrices ----#
matrixA <- matrix(c(3,2,4,7,5,0,1,0,8),ncol=3,byrow=T)
matrixB <- matrix(c(6,1,0,2,8,7,3,4,5),ncol=3,byrow=T)
matrixA + 5 #add
matrixA + matrixB #add two matrices
matrixA %*% matrixB #multiply two matrices
matrixA * matrixB #does element by element multiplication
t(matrixA) #transpose of matrix
solve(matrixA) #inverse of matrix
det(matrixA) #determinant of matrix
eigen(matrixA) #eigen values and vectors
