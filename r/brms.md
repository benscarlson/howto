brmstools: https://mvuorre.github.io/brmstools/index.html
brmstools spaghetti plots: https://mvuorre.github.io/brmstools/articles/panel-spaghetti-plots/panel-spaghetti-plots.html

## Warnings

### Bulk ESS

Note there is also Tail ESS

Warning: Bulk Effective Samples Size (ESS) is too low, indicating posterior means and medians may be unreliable.
Running the chains for more iterations may help. See https://mc-stan.org/misc/warnings.html#bulk-ess

For final results, we recommend requiring that the bulk-ESS is greater than 100 times the number of chains. For example, when running four chains, this corresponds to having a rank-normalized effective sample size of at least 400. In early workflow, ESS > 20 is often sufficient.

To fix:
Try setting iter parameter to a larger value. Or, more iterations relative to warmup. Default is 2000
Try thinning. By default, thin = 1

Rhat should be close to 1, and should be < 1.05

Default warmup is half of iter
