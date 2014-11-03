# ==============================================================================
# = This file provides tools for finding/caching the inverse of a matrix. The
# = makeCacheMatrix function will take and store a matrix in its environment.
# = cacheSolve will take the resulting list from makeCacheMatrix, and return its 
# = inverse. If the inverse has previously been calculate, it will simply take
# = the cached value to prevent recalculating.
# ==============================================================================

# ------------------------------------------------------------------------------
# This function sets up an environment for storing a matrix and it's cached
# inverse. When calling this function, a list is returned with accessor
# functions:
# set: sets a new matrix, and clears the old inverse
# get: gets the current matrix
# setInverse: sets the inverse matrix
# getInverse: gets the inverse matrix
makeCacheMatrix <- function(x = matrix()) {
        # cache the inverse matrix
        inverse <- NULL

        # check that the input matrix is square. If it isn't print a warning.
        checkSquare <- function(y) {
                if (nrow(y) != ncol(y)) {
                        warning( "This is not a square matrix. "
                               , "Inverting this will cause an error!"
                               )
                }
        }
        checkSquare(x)

        # set the current matrix. This also clears the inverse
        set <- function(y) {
                checkSquare(y)
                x <<- y
                inverse <<- NULL
        }

        # return the current matrix
        get <- function() {
                x
        }

        # set the inverse matrix
        setInverse <- function(new_inverse) {
                inverse <<- new_inverse
        }

        # return the inverse matrix
        getInverse <- function() {
                inverse
        }

        # return a list of the accessor functions
        list( set=set
            , get=get
            , setInverse=setInverse
            , getInverse=getInverse
            )
}


# ------------------------------------------------------------------------------
# This function takes as an input a list x which comes from the makeCacheMatrix
# function. If x already has an inverse cached, this cached matrix will be
# returned. Otherwise, the inverse of the matrix stored in x will be calculated
# and stored in x. Finally, the inverse of x is returned.
cacheSolve <- function(x, ...) {
        # If a result is already found for the inverse, we don't need to do any
        # more. Return the cached inverse matrix.
        if (!is.null(x$getInverse())) {
                message("getting cached data")
                return(x$getInverse())
        }

        # If we are here, we need to compute the inverse of x
        the_matrix <- x$get()

        # check that this is a square matrix.
        if (nrow(the_matrix) != ncol(the_matrix)) {
                stop( "What are you thinking?!?! This is not a square matrix! "
                    , "I cannot take its inverse!"
                    )
        }

        # find the inverse and set it in x
        x$setInverse(solve(the_matrix, ...))

        # Return a matrix that is the inverse of 'x'
        x$getInverse()
}
