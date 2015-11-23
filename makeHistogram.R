
makeHisto <- function(data, nfn, norm, gfit){
    
    h <- hist(data)
    if (norm) {
        title <- paste(nfn, " Distribution (Normalized)")
        plot(h, main = title, xlab = 'Generated Numbers', border = "blue", lwd = 2, las = 1
                   , col = "lightblue", freq=F)
    }
    else {
        title <- paste(nfn, " Distribution")
        plot(h, main = title, xlab = 'Generated Numbers', border = "blue", lwd = 2, las = 1
              , col = "lightblue")
    }
    
    leg.txt <- paste("Mean: ", round(mean(data), digits=3), "\nStd.Dev.: ", round(sd(data), digits=3))
    legend("topright", legend = leg.txt, title="Histogram Stat.", bty = "n")

    if(gfit == TRUE) {
        
        legend("topleft", c(nfn, "Gaussian [Ref]"), col=c("blue", "red"), lwd=3)
        
        if(norm == FALSE) {
            sf <- h$counts / h$density
            mydensity <- density(data, adjust =2)
            mydensity$y <- mydensity$y * sf[1]
            lines(mydensity, col="red", lwd=2)
            
            xfit<-seq(min(data),max(data),length=40) 
            yfit<-dnorm(xfit,mean=mean(data),sd=sd(data)) 
            yfit <- yfit*diff(h$mids[1:2])*length(data) 
            lines(xfit, yfit, col="blue", lwd=2)
        }
    
        if(norm) {
            lines(density(data, adjust = 2), col="red", lwd=2)
            curve(dnorm(x, mean=mean(data), sd=sd(data)), add=TRUE, col="darkblue", lwd=2) 
        }
    }
    
    return(h)
}