#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

data <- read.csv("../../data/Income.csv")


# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Linear Regression - what is the optimal line?"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        HTML(
          "Use the sliders to adjust the values of a,b, and c, for the covariance matrix. The resultant output
        is a scatter plot of the datapoints generated from a MVN(0, Sigma) distribution, as well as a visualisation of the effect of the linear transformation of the Identity matrix by Sigma. Fun fact - the area plotted is the determinant of Sigma!"),
        # Text instructions
        img(src="rss.png",width="100%"),
        
         sliderInput("intercept",
                     withMathJax(helpText("The value of the intercept, $$\\beta_0$$")),
                     min = -50,
                     max = -30,
                     value = -40),
         sliderInput("slope",
                     withMathJax(helpText("The value of the slope, $$\\beta_1$$")),
                     min = 1,
                     max = 10,
                     value = 6)
         
         
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("lmPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
   output$lmPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
     coef <- c(input$slope, input$intercept)
     Fitted <- coef[2] + coef[1]*data$Education
     Income <- transform(data, Fitted = Fitted)
     
      
      # draw the histogram with the specified number of bins
     ggplot(Income, aes(Education, Income)) + 
       geom_point(color="red") + 
       geom_abline(slope=coef[1], intercept=coef[2], col="dodgerblue") +
       geom_segment(aes(x = Education, y = Income,
                        xend = Education, yend = Fitted)) +
       coord_cartesian(xlim = c(9, 23), ylim = c(15, 90))
     
   })
}

# Run the application 
shinyApp(ui = ui, server = server)
