library(ggplot2)

# Load genomic G/C count datasets
chr1 <- scan("data/dataset1.csv")
chr2 <- scan("data/dataset2.csv")
chr3 <- scan("data/dataset3.csv")
chr4 <- scan("data/dataset4.csv")


# Performs Bayesian change-point analysis for a genomic sequence
analysis <- function(x, PLOT = TRUE){
  
  m <- 5000
  n <- length(x)
  s <- cumsum(x)
  
  logpr <- numeric(n - 1)
  
  for (t in seq_along(logpr)){
    logpr[t] <- lbeta(s[t] + 1, t * m - s[t] + 1) +
      lbeta(s[n] - s[t] + 1, (n - t) * m - s[n] + s[t] + 1)
  }
  
  logprmax <- max(logpr)
  pr <- exp(logpr - logprmax)
  pr <- pr / sum(pr)
  
  LogEv1 <- lbeta(s[n] + 1, n * m - s[n] + 1)
  LogEv2 <- -log(n - 1) + logprmax + log(sum(exp(logpr - logprmax)))
  
  LogDen <- max(LogEv1, LogEv2) +
    log(exp(LogEv1 - max(LogEv1, LogEv2)) +
          exp(LogEv2 - max(LogEv1, LogEv2)))
  
  Postprob1 <- exp(LogEv1 - LogDen)
  Postprob2 <- exp(LogEv2 - LogDen)
  
  changepoint <- which.max(pr)
  
  result <- list(
    Postprob1 = Postprob1,
    Postprob2 = Postprob2,
    changepoint = changepoint,
    posterior_t = pr
  )
  
  if (PLOT) {
    barplot(pr, names = seq_along(pr), main = "Posterior Distribution of the Changepoint", xlab = "Window Index", ylab = "Probability")
    df <- data.frame(Win = seq_along(x), chr = x)
    print(ggplot(df, aes(Win, chr)) +
            geom_point(aes(colour = Win > changepoint)) +
            geom_line(aes(colour = Win > changepoint)) +
            scale_color_manual(
              values = c("FALSE" = "black", "TRUE" = "red"),
              labels = c("Before Changepoint", "After Changepoint")
            ) + 
            labs(x = "Window Index", y = "G/C Count", color = "") +
            theme_minimal())
    df$Period <- ifelse(df$Win <= changepoint,
                        "Before Changepoint",
                        "After Changepoint")
    print(ggplot(df, aes(y = chr)) +
            geom_boxplot() +
            facet_wrap(~ Period, nrow = 1) +
            labs(
              x = "",
              y = "G/C Count"
            ) +
            theme_minimal())
    
    
  }
  
  return(result)
}


analysis(chr1)
analysis(chr2)
analysis(chr3)
analysis(chr4)

