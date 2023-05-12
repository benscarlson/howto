* glmm faq (Bolker). http://bbolker.github.io/mixedmodels-misc/glmmFAQ.html#model-definition
* brmstools: https://mvuorre.github.io/brmstools/index.html
* brmstools spaghetti plots: https://mvuorre.github.io/brmstools/articles/panel-spaghetti-plots/panel-spaghetti-plots.html
* Extracting and visualizing tidy draws from brms models https://cran.r-project.org/web/packages/tidybayes/vignettes/tidy-brms.html

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

### Priors

https://github.com/paul-buerkner/brms/blob/e42e8da64fc48919085fabd6cba40b7b86668f4b/R/priors.R#L1782
brmsprior does not return a dataframe so can't be run through kable
`print.brmsprior`

See priors: 
`prior_summary(fit)`
