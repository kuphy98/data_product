# This is a code for a course project of Data Products.
setwd("~/Dropbox/Machine.Learning/Data Products/Shiny-Project/")

# before you run runApp(), 
# you need to load shiny library in your environment
library(shiny)

shinyUI(
  pageWithSidebar(
    # Application title
    headerPanel("Statistical Distribution Generator"),
    
    sidebarPanel(
      selectInput(
        "randomfn", "Select a probability function:", 
        choices=c(Gaussian="Gaussian", Poisson="Poisson", Binomial="Binomial")),
      numericInput("nrand", 'How many random numbers do you want to generate? ', 100, min = 0, max = 100000),
      submitButton('Generate'),
      
      conditionalPanel(
        condition="input.randomfn=='Gaussian' ",
        h3(''),
        h5("Please, choose two more valuses for your Gaussian distribution: "),
        sliderInput("mean", "Mean", min=-100, max=100, value = 0),
        sliderInput("sd", "Standard Deviation", min=0, max=100, value = 10),
        submitButton('Generate')
      ),
      
      conditionalPanel(
        condition="input.randomfn=='Poisson' ",
        h3(''),
        sliderInput("lambda", "$$\\rm{Please, decide~ the~ value~ of}~ \\lambda~ (>0):$$", min=0, max=100, value = 10), 
        submitButton('Generate')
      ),
      
      conditionalPanel(
        condition="input.randomfn=='Binomial' ",
        h3(''),
        h5("What are the trial size and the success probability? "),
        sliderInput("size", "Number of Trials", min=0, max=10000, value = 100), 
        numericInput("prob", 'Success Probability (Insert a decimal value)', 1/2, min = 0, max = 1, step=0.01),
        submitButton('Generate')
      ),
      
      br(),
      
      checkboxInput("norm", "Nomalize the histogram", FALSE),
      checkboxInput("gfit", "Compare the histogram (density distribution) to the gaussian distribution", FALSE),
      submitButton("Apply")
    ), # sidebarPanel
    
    mainPanel(
      
      tabsetPanel(
        
        tabPanel(p("Distribution"),
          h4('Brief Description: '),
          uiOutput("ui"),
      
          h3(''),
          h3(''),
      
          textOutput("text"),
          textOutput("text2"),
          br(),
      
          plotOutput("newDist"),
          
          uiOutput("eqs")
        ),
        tabPanel(p("Generated Numbers"), dataTableOutput("newData"), verbatimTextOutput("sum"))
    )
    )
    
  )
)

