source("makeHistogram.R")

shinyServer(
  function(input, output) {
    output$text <- renderText({
      paste("You have generated ", input$nrand, " ", input$randomfn, " Random numbers", ".")
    })
    
    output$text2 <- renderText({
      if(input$randomfn == "Gaussian") paste("Setting: ", "\n Mean: ", input$mean, ", S.D.:", input$sd)
      if(input$randomfn == "Poisson") paste("Setting: ", "\n Lambda: ", input$lambda)
      if(input$randomfn == "Binomial") paste("Setting: ", "\n N of trials: ", input$size, ", Success Probability:", input$prob)
      
    })
    
    output$ui <- renderUI({
      if(is.null(input$randomfn))
        return()
          
      switch(input$randomfn,
             "Gaussian" = pre(includeText("gaussian.txt")),
             "Binomial" = pre(includeText("binomial.txt")),
             "Poisson" = pre(includeText("poisson.txt"))
       )
    }) # renderUI
    
    br()
    br()
    
    dataInput <- reactive({
      if(input$randomfn == "Gaussian") x <- rnorm(input$nrand, input$mean, input$sd)
      if(input$randomfn == "Poisson") x <- rpois(input$nrand, input$lambda)
      if(input$randomfn == "Binomial") x <- rbinom(input$nrand, input$size, input$prob)
      
      return(x)
    })
    
    source("makeHistogram.R")
     output$newDist <- renderPlot({
         makeHisto(dataInput(), input$randomfn, input$norm, input$gfit)
     })

    output$newData = renderDataTable({
        values <- format(round(dataInput(), digits = 3))
        df <- data.frame(values)
    }, options = list(lengthMenu = c(10, 30, 50), pageLength = 10, searchable = FALSE))
    
    output$eqs <- renderUI({
      switch(input$randomfn,
             "Gaussian" = withMathJax(helpText('The probability density of the normal distribution is:  
                                               $$f(x | \\mu, \\sigma) = \\frac{1}{\\sigma\\sqrt{2\\pi}} 
                                               e^{-\\frac{(x - \\mu)^2}{2\\sigma^2}}$$')),
             "Poisson" = withMathJax(helpText('Poisson Probability:  $$f(k; \\lambda) = 
                                              \\frac{\\lambda^k e^-{\\lambda}}{k!}$$')),
             "Binomial" = withMathJax(helpText('Binomial Probability:  
                                               $$f(k; n, p) = \\binom{n}{k} p^k (1-p)^{n-k}$$'))
             ) # switch
    })
    
    output$sum <- renderPrint({
        summary(dataInput())
    })
    
  }
)