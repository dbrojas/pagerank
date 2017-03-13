# PageRank implementation in R

PageRank is an algorithm used by Google Search to rank websites in their search engine results. PageRank works by counting the number and quality of links to a page to determine a rough estimate of how important the website is. The underlying assumption is that more important websites are likely to receive more links from other websites.

To use PageRank for website quality ranking, the internet has to be modelled as a graph. Here, websites are represented vertices which are interconnected by hyperlinks as edges. The algorithm inputs the adjacency matrix corresponding to this graph and computes the PageRank score per vertex using Markov Chains. It outputs a descending ranked list of vertices.
