' # # # # # # # # # # # #
  # PageRank Algorithm  # 
# # # # # # # # # # # # '

# Define function to load an adjacency matrix
A_load <- function (f) {
  A <- as.matrix(read.table(f))
  cat(paste('The loaded graph has', nrow(A), 'vertices and', sum(A), 'edges.'))
  return(A)
}

# Define function to generate an adjacency matrix
A_gen <- function (n, p) {
  A <- matrix(sample(0:1, n*n, prob = c(1-p, p), replace = T), ncol = n, byrow = T)
  cat(paste('The generated graph has', nrow(A), 'vertices and', sum(A), 'edges.'))
  return(A)
}

# Define PageRank function (p = probability of teleport)
PageRank <- function (A, p, n_iter, output = T) {
  
  # Define assertions
  if (!is.matrix(A) | !all(A %in% 0:1)) {
    stop(noquote('no (valid) adjacency matrix is provided.'))
  } else if (!is.numeric(p) | p < 0 | p > 1) {
    stop(noquote('p must be a probability between 0 and 1.'))
  } else if (!n_iter%%1==0 | n_iter < 1) {
    stop(noquote('n_iter must be a positive integer.'))
  }
  
  # Initialize transition matrix
  s <- matrix(rep(NA, ncol(A) * (n_iter+1)), nrow = n_iter+1, ncol = ncol(A))
  s[1, ] <- rep(1/ncol(A), ncol(A))
  
  # Repeat Markov Chain for n_iter iterations
  for (i in 1:n_iter) {
    
    # Calculate transition vector at t + 1
    for (j in 1:ncol(A)) {
      s[i+1, j] <- ifelse(sum(A[j, ]) == 0 
                          , 1 / ncol(A)
                          , p / ncol(A) + (1 - p) * sum(A[, j] * (s[i, ] / apply(A, 1, sum))))
    }
    
    # Break if converged
    if (i > 1) if (all(round(s[i, ], 4) == round(s[i+1, ], 4))) break
  }
  
  # Build and return output
  rank <- data.frame(as.character(1:ncol(s)), round(s[i+1, ], 4), rep(p, ncol(A)))
  colnames(rank) <- c('Node', 'PageRank', 'P')
  
  if (output) {
    if (i == n_iter) {
      cat(noquote('PageRank Output:\n\n'))
      print(rank[order(-rank$PageRank), c('Node', 'PageRank')], row.names = F)
      cat(noquote(paste('\nWarning: PageRank did not converge in', i, 'iterations.')))
    } else {
      cat(noquote('PageRank Output:\n\n'))
      print(rank[order(-rank$PageRank), c('Node', 'PageRank')], row.names = F)
      cat(noquote(paste('\nPageRank converged in', i, 'iterations.')))
    }
  } else {
    return(rank[order(-rank$PageRank), ])
  }
}


# Load/generate an adjacency matrix
A <- A_load('~/Desktop/R/PageRank/A_big.txt')
A <- A_gen(10, .6)

# Plot the graph
library(igraph)
plot(graph.adjacency(A,'directed'))

# Do 100 PageRank iterations on example graph with P(teleport) = 0.2
PageRank(A, .2, 100)


# Effect of P(teleport) on ranking  
library(ggplot2)

# Calculate permutations
df <- data.frame()
for (i in seq(0,1,.005)) {
  df <- rbind(df, PageRank(A, i, 100, F))
}

# Plot
ggplot(data=df, aes(x=P, y=PageRank, group=Node, fill=Node, colour=Node)) +
  geom_line(size=1) +
  scale_x_continuous(breaks = seq(0,1,0.1)) +
  expand_limits(y=0.135) +
  xlab('P(teleport)') +
  ggtitle('Effect of P(teleport) on PageRank')
