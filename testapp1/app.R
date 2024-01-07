library(shiny)

library(rhandsontable)

# Define UI for app that draws a histogram ----
ui <- fluidPage(

  # App title ----
  titlePanel("Hello Shiny!"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

      # Input: Slider for the number of bins ----
      numericInput("seed", "seed", sample(50, 1)),
      actionButton("savefile", "go"),
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)

    ),

    # Main panel for displaying outputs ----
    mainPanel(

      # Output: Histogram ----
      verbatimTextOutput("testfoo"),
      rHandsontableOutput("testtab"),
      plotOutput(outputId = "distPlot")

    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  observeEvent(input$savefile, {
    path <- normalizePath("~/Desktop")
    set.seed(input$seed)

    writeLines(as.character(myrnorm()), con = file.path(path, "temp.txt"))
  })
  rhandsontable(iris)
  output$testfoo <- renderText({
    set.seed(input$seed)
    myrnorm()
    })

  output$testtab <- renderRHandsontable({
    DF = head(iris)
    if (!is.null(DF))
      rhandsontable(DF, stretchH = "all")
  })
  output$distPlot <- renderPlot({

    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")

    })

}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
