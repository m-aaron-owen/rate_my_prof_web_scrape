
fluidPage(
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "grouped",
                        label = "Group By",
                        choices = c("None",
                                    Sex = "sex", 
                                    Pepper = "chili"),
                        selected = "None")
            ),
        mainPanel(
            plotOutput("distPlot")
            )
        )
    )
