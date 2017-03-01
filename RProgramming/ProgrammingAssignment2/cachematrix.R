makeCacheMatrix <- function(x = matrix()) {
   # Creates a special "vector" which is really a list containing functions to
   # get/set the matrix to cache and to get/set the inverse of that matrix.
   #
   # Args:
   #   x: The matrix whose inverse will be calculated
   #
   # Returns:
   #   The list of accessors/mutators for a matrix and its inverse
   i <- NULL
   set <- function(mat) {
      x <<- mat
      i <<- NULL
   }
   get <- function() x
   setinverse <- function(inv) i <<- inv
   getinverse <- function() i
   list(set = set, get = get, setinverse = setinverse, getinverse = getinverse )
}

cacheSolve <- function(x, ...) {
   # Computes the inverse of the matrix contained in the special list x.
   #
   # Args:
   #   x: A list created by the makeCacheMatrix function
   #   ... A variable list of arguments that will be passed to the solve fuction
   #
   # Returns:
   #   The inverse of the matrix contained in x either from cache or that has been computed.
   i <- x$getinverse()
   if (!is.null(i)) {
      message("getting cached data")
      return(i)
   }
   mat <- x$get()
   i <- solve(mat, ...)
   x$setinverse(i)
   i
}
