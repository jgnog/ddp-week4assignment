library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Predicting fuel consumption"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderInput("npredictors",
                   "Number of predictors to use in the model:",
                   min = 1,
                   max = 10,
                   value = 1)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs",
        tabPanel("Results",
                 br(),
                 plotOutput("plot1"),
                 br(),
                 p("A model with a perfect fit would produce points that lie exactly on
                   the blue line."),
                 h3("Model details"),
                 h4("Predictors:"),
                 tableOutput("predictors"),
                 tags$b("R squared:"),
                 textOutput("rsquared")
        ),
        tabPanel("Documentation",
                 h3("Predicting fuel consumption with multiple regression"),
                 p("The objective of this application is to select the linear
                    regression model with x predictors that best predicts
                    the response variable."),
                 p("The data for this application is the mtcars dataset which is a set of
                    32 observations of 11 variables on different cars. The response variable
                    is mpg (miles per gallon) and the predictor variables are:"),
                 tags$ul(
                    tags$li("cyl  number of cylinders"),
                    tags$li("disp  displacement in cubic inches"),
                    tags$li("hp  gross horsepower"),
                    tags$li("drat  rear axle ratio"),
                    tags$li("wt  weight in thousands of pounds"),
                    tags$li("qsec  1/4 mile time"),
                    tags$li("vs  V or straight engine (0 = V engine)"),
                    tags$li("am  transmission (0 = automatic, 1 = manual)"),
                    tags$li("gear  number of forward gears"),
                    tags$li("carb  number of carburetors")
                 ),
                 p("This application will ask the user for the number of predictors that
                    should be included in the linear regression model. Then the application
                    will use a wrapper method to select the best predictors to use in the
                    model. The prediction method will work as follows:"),
                 tags$ol(
                    tags$li("Build 10 simple linear regression models (one for each predictor) and
                    select the one that produces the highest R^2 score."),

                    tags$li("If the number of predictors to be included is greater than 1, build
                    9 multiple regression models with the predictor selected in the first
                    step as the first predictor and one of the other predictors as second
                    regressor. Select the model that produces the highest R^2 score."),

                    tags$li("Keep repeating step 2 until the number of predictors in the model
                    is equal to the number requested by the user.")
                ),

                p("The application will show the predictors that were selected using this
                method and the R^2 score achieved with the final model. The plot will
                show the predicted and actual values of *mpg* for each of the cars in
                the dataset."),
                h4("Usage"),
                p("Use the slider in the sidebar to select how many predictors should be included
                  in the model. Everytime you move the slider the application will build a new
                  model and refresh the results."),
                p("The plot shows the actual values of MPG in the x axis and the predicted values
                  of MPG in the y axis. The blue line represents a perfect model where every
                  predicted value is exactly equal to the actual value. You can use this
                  line to compare models visually."),
                p("Below the plot you will have a list of the predictors used in the model
                  and the value of R^2 (coefficient of determination). The higher this number
                  the more variance in the data is explained by the model. This is
                  essentially a measure of the accuracy of the model."),
                h4("Technical note on the approach used to build the model"),
                p("This application commits a serious mistake with its approach to
                  select the best model. The problem is that the model is being tested
                  on exactly the same dataset on which it was built. This most probably
                  leads to overfitting."),
                p("You will probably observe that the more predictors you include the
                  higher the coefficient of determination will be, leading you to
                  believe that more predictors is better. However if one would apply
                  these models to another sample of cars, one would probably find
                  that the accuracy would start decreasing if the model has too many
                  predictors. The models with the higher number of predictors are
                  probably overfitting the data and would perform poorly on a new
                  sample."),
                p("In conclusion, this is not a very good approach to selecting
                  the best model. However, the purpose of the application was to
                  implement a wrapper method of feature selection and that was
                  accomplished successfully.")
        )
      )
    )
  )
))
