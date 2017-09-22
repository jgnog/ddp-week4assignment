#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)
data("mtcars")

mtcars$cyl <- factor(mtcars$cyl)
mtcars$vs <- factor(mtcars$vs)
mtcars$am <- factor(mtcars$am)
mtcars$gear <- factor(mtcars$gear)
mtcars$carb <- factor(mtcars$carb)

mtcars.predictors <- select(mtcars, -mpg)

select.best.model <- function(n.predictors) {
  best_predictors <- c()
      
  for (i in seq(n.predictors)) {
    best_rsquared <- 0
    best_model <- NULL

    for (j in seq(ncol(mtcars.predictors))) {
      predictor <- colnames(mtcars.predictors)[j]
      predictors <- c(best_predictors, predictor)
      formula <- reformulate(predictors, "mpg")
      model <- lm(formula, mtcars)
      rsquared <- summary(model)$r.squared
      if (rsquared > best_rsquared) {
        best_rsquared <- rsquared
        best_model <- model
        best_predictor <- predictor
      }
    }
    best_predictors <- c(best_predictors, best_predictor)
    mtcars.predictors <- select(mtcars.predictors, -matches(best_predictor))
  }
  best_model
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  best.model <- reactive({
    select.best.model(input$npredictors)
  })
   
  output$plot1 <- renderPlot({
    
    predicted.mpg <- best.model()$fitted.values
    plot.data <- data.frame(predicted <- predicted.mpg, actual <- mtcars$mpg)
    p <- ggplot(plot.data, aes(actual, predicted))
    p <- p + geom_point() + geom_abline(intercept = 0, slope = 1, color = "blue")
    p <- p + ggtitle("Actual vs predicted values of miles per gallon") +
      xlab("Actual MPG") +
      ylab("Predicted MPG")
    p
  })
  
  output$predictors <- renderTable({attr(best.model()$terms, "term.labels")}, colnames = FALSE)
  output$rsquared <- renderText({summary(best.model())$r.squared})
  
})
