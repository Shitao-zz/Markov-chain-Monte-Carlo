#A Matlab implementation of adaptive metropolis algorithm.

>Adaptive Metropolis (AM) Algorithm aims to efficiently sample a high dimensional
>complex probability distribution. The propose of this post is to document what I
>learn from this Algorithm.

Most of the notations and concepts here are following Haario et al. 2001.

### Metropolis Algorithm 

Metropolis algorithm was named one of the top 10 most influential algorithms of the
20th century, at least by the editors of CiSE (Computing in Science and
Engineering).

Goal: Sample from a high dimensional and complicated distribution. 

Reason: In high dimensions, our intuition for volume breaks down. For example, a
proposal distribution in high dimensions that may seems to be a good one can
fail because it may put a lot probability mass in the low dimension part.

MCMC: The algorithm trys to move to a region of high probability and then trys
to stay near the high probability region.

### Algorithm
Check more details in my documentation
http://shitao.github.io/adaptive-metropolis-algorithm/

### Test case
<img src="/fig/polynomial_test.png" align="center" width="900px"/>

# Infer the input condition uncertainty given SSH observational data

<img src="/fig/mcmc.png" align="center" width="900px"/>

An example to include the grided-SSH data for only 1 day.

<img src="/fig/bayesian_data_day1.jpg" align="center" width="900px"/>


### Reference

Haario, H., E. Saksman, and J. Tamminen, 2001: An adaptive metropolis algorithm.
Bernoulli, 7, 223–242. [Available online at http://www.jstor.org/stable/3318737.]

