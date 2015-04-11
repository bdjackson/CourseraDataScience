# Quiz 2

## Question 1
Consider the following data with x as the predictor and y as as the outcome.


```r
x <- c(0.61, 0.93, 0.83, 0.35, 0.54, 0.16, 0.91, 0.62, 0.62)
y <- c(0.67, 0.84, 0.6, 0.18, 0.85, 0.47, 1.1, 0.65, 0.36)
```

Give a P-value for the two sided hypothesis test of whether β1 from a linear
regression model is 0 or not.

Answer:

First, perform the linear regression

```r
fit=lm(y~x)
```
The fitted coeficients are

```r
fit
```

```
## 
## Call:
## lm(formula = y ~ x)
## 
## Coefficients:
## (Intercept)            x  
##      0.1885       0.7224
```

```r
beta.0 <- coef(fit)[1]
beta.1 <- coef(fit)[2]
```

Now, compute the variance on $\beta_1$. To do this, we use the errors on $y_i$

```r
err <- y-predict(fit)
var.beta.1 <- sum(err^2)/(NROW(x)-2)/sum((x-mean(x))^2)
```

Finally, compute the t statistic, and use it to compute the p value

```r
t.beta.1 <- beta.1/sqrt(var.beta.1)
2*pt(t.beta.1, NROW(x)-2, lower.tail=FALSE)
```

```
##          x 
## 0.05296439
```

## Question 2
Consider the previous problem, give the estimate of the residual standard
deviation.

Answer:

```r
sqrt(1/(NROW(x)-2)*sum(err^2))
```

```
## [1] 0.2229981
```

## Question 3
In the mtcars data set, fit a linear regression model of weight (predictor) on
mpg (outcome). Get a 95% confidence interval for the expected mpg at the average
weight. What is the lower endpoint?

Answer:

```r
library(datasets)
fit <- lm(mtcars$mpg~mtcars$wt)
```

Extract the slope and intercept from the fit

```r
beta.0 <- coef(fit)[1]
beta.1 <- coef(fit)[2]
```

Calculate a few other useful things

```r
mean.weight <- mean(mtcars$wt)
err <- mtcars$mpg-predict(fit)
var <- sum(err^2)/(nrow(mtcars)-2)
sum.square.wt.diff <- sum((mtcars$wt - mean.weight)^2)

var.beta.0 <- (var*
               (1/nrow(mtcars) + mean.weight^2/sum((mtcars$wt - mean.weight)^2)))
var.beta.1 <- var/sum((mtcars$wt-mean(mean.weight))^2)
```

These functions are used to calculate the the variance on the line, and variance
on the prediction at a given point

```r
var.line <- function(x0) {
  (beta.0 +
   beta.1*x0 +
   c(-1,1)*qt(0.975, fit$df)*sqrt(var*(1/nrow(mtcars) +
                                       (x0-mean.weight)^2/sum.square.wt.diff)))
}

var.prediction <- function(x0) {
  (beta.0 +
   beta.1*x0 +
   c(-1,1)*qt(0.975, fit$df)*sqrt(var*(1 +
                                       1/nrow(mtcars) +
                                       (x0-mean.weight)^2/sum.square.wt.diff)))
}

var.line(mean.weight)
```

```
## [1] 18.99098 21.19027
```


## Question 4
Refer to the previous question. Read the help file for mtcars. What is the
weight coefficient interpreted as?

Answer:

The estimated expected change in mpg per 1,000 lb increase in weight


## Question 5
Consider again the mtcars data set and a linear regression model with mpg as
predicted by weight (1,000 lbs). A new car is coming weighing 3000 pounds.
Construct a 95% prediction interval for its mpg. What is the upper endpoint?

Answer:

Using the function from before

```r
var.prediction(3)
```

```
## [1] 14.92987 27.57355
```

## Question 6
Consider again the mtcars data set and a linear regression model with mpg as
predicted by weight (in 1,000 lbs). A “short” ton is defined as 2,000 lbs.
Construct a 95% confidence interval for the expected change in mpg per 1 short
ton increase in weight. Give the lower endpoint.

Answer:

```r
conf.int.beta.1 <- beta.1 + c(-1,1)*qt(0.975, df=fit$df)*sqrt(var.beta.1)
2*conf.int.beta.1
```

```
## [1] -12.97262  -8.40527
```

## Question 7
If my X from a linear regression is measured in centimeters and I convert it to
meters what would happen to the slope coefficient?

Answer:

It is multipllied by 100


## Question 8
I have an outcome, Y, and a predictor, X and fit a linear regression model with
Y=β0+β1X+ϵ to obtain $\hat{\beta}_0$ and $\hat{\beta}_1$. What would be the consequence to the
subsequent slope and intercept if I were to refit the model with a new
regressor, X+c for some constant, c?

Answer:

The intercept of the regression line is given by
$\hat{\beta}_0 = \bar{Y} - \hat{\beta}_1 \bar{X}$.
If we define $X' = X+c$, the new intercept becomes
$$
\hat{\beta}_0' = \bar{Y}' - \hat{\beta}_1' \bar{X}'
$$
This is just a translation in $X$, so
$$
\bar{Y}' = \bar{Y} \\
\bar{X}' = \bar{X} + c \\
\hat{\beta}_1' = \hat{\beta}_1
$$
giving
$$
\hat{\beta}_0' = \bar{Y} - \hat{\beta}_1 \bar{X} - \hat{\beta}_1 c \\
\hat{\beta}_0' = \hat{\beta}_0 - \hat{\beta}_1 c \\
$$

## Question 9
Refer back to the mtcars data set with mpg as an outcome and weight (wt) as
the predictor. About what is the ratio of the the sum of the squared errors,
∑ni=1(Yi−Y^i)2 when comparing a model with just an intercept (denominator) to
the model with the intercept and slope (numerator)?

Answer:

```r
fit <- lm(mtcars$mpg~mtcars$wt)
mean.mpg <- mean(mtcars$mpg)

sq.err.full.fit <- sum(fit$residuals^2)
sq.err.mean <- sum((mtcars$mpg - mean(mtcars$mpg))^2)

sq.err.full.fit/sq.err.mean
```

```
## [1] 0.2471672
```


## Question 10
Do the residuals always have to sum to 0 in linear regression?

Answer:

If the intercept is included, the residuals must sum to 0.

