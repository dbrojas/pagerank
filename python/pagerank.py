import numpy as np
import pandas as pd

def pagerank(a, p):
    
    # initialize transition matrix
    ncol = a.shape[1]
    s = np.repeat(1 / ncol, ncol).reshape(1, -1)
    i = 0
    
    # run markov chain
    while True:
        
        # transition vector at t + 1
        t = np.empty(ncol)
        for j in range(len(t)):
            if sum(a[j, :]) == 0:
                t[j] = 1 / ncol
            else:
                t[j] = p / ncol + (1 - p) * sum(a[:, j] * (s[i, :] / np.sum(a, 1)))

        s = np.vstack([s, t])
        i += 1
        
        # break if converged
        if (i > 0) and (all(np.round(s[i - 1, :], 4) == np.round(s[i, :], 4))):
            break
    
    # sort nodes
    out = pd.Series(np.round(s[-1, :], 4)).reset_index().sort_values(0)[::-1].values
    
    # return pagerank scores
    output = 'Output\n\n'
    for node in range(ncol):
        output += '{}\t{}\n'.format(int(out[node, 0]), 
                                    np.round(out[node, 1], 4))
    output += '\nConverged in {} iterations.'.format(i + 1)
    return print(output)


# # example
# a = np.random.randint(0, 2, (10, 10))
# pagerank(a, 0.2)
