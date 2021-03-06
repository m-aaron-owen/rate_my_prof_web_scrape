
library(shinydashboard)

## list of all departments; used in all tabs of the app ##
department_list = c("Accounting","Anthropology", "Art", "Behavioral Sciences",
                    "Biology", "Business", "Chemistry", "Communication",
                    "Computer Science", "Criminal Justice", "Cultural Studies",
                    "Early Childhood Education", "Economics", "Education",
                    "Engineering", "English", "Fashion", "Finance", "Geology",
                    "Health Science", "History, Philosophy, Poly Sci",
                    "Languages", "Law", "Management", "Marketing",
                    "Mathematics", "Music", "Nursing", "Physical Ed",
                    "Physical Sciences", "Physics", "Psychology", "Social Science",
                    "Social Work", "Sociology")


dashboardPage(skin = "red",
    dashboardHeader(title = "Scrape My Professors"),
    dashboardSidebar(
        sidebarMenu(id = "sidebarmenu",
            
            ### different tabs ###
            menuItem("Home", tabName = "Home", icon = icon("home")),
            menuItem("Ratings I", tabName = "Ratings_I", icon = icon("bar-chart")),
            menuItem("Ratings II", tabName = "Ratings_II", icon = icon("line-chart")),
            menuItem("Tags", tabName = "Tags", icon = icon("tags")),
            menuItem("Wordclouds", tabName = "Comments", icon = icon("comments")),
            
            ## panel only to appear when inside the "Ratings I" tab ##
            conditionalPanel("input.sidebarmenu == 'Ratings_I'",
                            checkboxGroupInput(inputId = "dep",
                                                label = "Choose Department(s)",
                                                choices = department_list,
                                                selected = "Accounting"
                                                )
                             ),
            
            ## panel only to appear when inside the "Ratings II" tag ##
            conditionalPanel("input.sidebarmenu == 'Ratings_II'",
                             selectInput(inputId = "school",
                                         label = "School",
                                         choices = c("All",
                                                     "Borough of Manhattan CC",
                                                     "LaGuardia CC",
                                                     "Kingsboro CC",
                                                     "Nassau CC",
                                                     "Queensboro CC"),
                                         selected = "All"
                             ),
                             checkboxGroupInput(inputId = "dep_exp",
                                                label = "Choose Department(s)",
                                                choices = department_list,
                                                selected = "Accounting"
                             )
            ),
            
            ## panel to appear only when inside the "Tags" tab ##
            conditionalPanel("input.sidebarmenu == 'Tags'",
                             selectInput(inputId = "dep_tags",
                                         label = "Department",
                                         choices = department_list,
                                         selected = "Accounting"),
                             selectInput(inputId = "tags",
                                         label = "Select Professor Tags",
                                         choices = c(`Accessible Outside of Class` = "Accessible.Outside.of.Class",
                                                     `Amazing Lectures` = "Amazing.Lectures",
                                                     `Beware of Pop Quizzes` = "Beware.of.Pop.Quizzes",
                                                     Caring = "Caring",
                                                     `Clear Grading Criteria` = "Clear.Grading.Criteria",
                                                     `Extra Credit` = "Extra.Credit",
                                                     `Get Ready to Read` = "Get.Ready.to.Read",
                                                     `Gives Good Feedback` = "Gives.Good.Feedback",
                                                     `Graded by Few Things` = "Graded.by.Few.Things",
                                                     `Group Projects` = "Group.Projects",
                                                     Hilarious = "Hilarious",
                                                     Inspirational = "Inspirational",
                                                     `Lecture Heavy` = "Lecture.Heavy",
                                                     `Lots of Homework` = "Lots.of.Homework",
                                                     `Participation Matters` = "Participation.Matters",
                                                     Respected = "Respected",
                                                     `Skip Class? You won't Pass` = "Skip.Class.You.won.t.Pass",
                                                     `So Many Papers` = "So.Many.Papers",
                                                     `Test Heavy` = "Test.Heavy",
                                                     `Tough Grader` = "Tough.Grader"),
                                         selected = "Accessible.Outside.of.Class")
                             ),
            
            ## panel to appear only when inside the "Comments" tab ##
            conditionalPanel("input.sidebarmenu == 'Comments'",
                             selectInput(inputId = "dep_cloud",
                                         label = "Department",
                                         choices = department_list,
                                         selected = "Accounting")
                             )
            )
        ),
    dashboardBody(
        
        ## custom styles ##
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
        ),
        tabItems(
            
            ## output for the "Home" tab ##
            tabItem(tabName = "Home",
                    fluidRow(
                        
                        ## insert image ##
                        box(img(src = "scrape.png"), width = 12, align = "center")
                        ),
                    fluidRow(
                        
                        ## different tags have different properties as designated in the custom.css file ##
                        box(tags$p("Choosing a college is hard, but choosing a college AND the right major is even harder.", 
                                     tags$u(tags$b("Let Scrape My Professor ")), " help you with both!"),
                            tags$p("--------------------------------------------------------------------", align = "center"),
                            tags$p(tags$u(tags$b("Scrape My Professor ")), " is an interactive application that allows you to compare the same 
                                   academic department(s) across multiple institutions of higher learning to help you make 
                                   the right choice for your education."),
                            tags$p("Using student-submitted data scraped from", tags$a("RateMyProfessors.com,", href = "http://www.ratemyprofessors.com/"), 
                                   "for all departments in the five community colleges with the highest enrollment in 
                                   the New York City area, you can explore the following:",
                                   tags$ul(
                                       tags$li("the differences in quality and difficulty ratings,"),
                                       tags$li("how gender and attractiveness affect ratings,"),
                                       tags$li("the most commonly used descriptive tags, and"),
                                       tags$li("the most frequently used words in reviews.")
                                   ),
                            tags$p('Click one of the tabs on the left panel to get started!')
                            ), width = 12)
                        )
                    ),
            
            ## output for the "Ratings I" tab ##
            tabItem(tabName = "Ratings_I",
                    fluidRow(
                        box(tags$p("Students can rate their professors, on a scale from 1 to 5, for both overall quality and level of difficulty. 
                                   Below are the averages for these ratings across schools."), 
                            tags$p("Select which department(s) you want to compare from the left panel."), width = 12),
                        box(plotOutput("ratingPlot"), width = 12),
                        box(tags$p("Note: not all colleges offer courses in all departments."), width = 12)
                        )
                    ),
            
            ## output for the "Ratings II" tab ##
            tabItem(tabName = "Ratings_II",
                    fluidRow(
                        box(tags$p("The figures below demonstrate the relationship between difficulty score and overall score for professors in
                                   the selected departments."),
                            tags$p("Not surprisingly, difficult professors are rated as lower quality. What is surprising, however, is
                                   how the gender and attractiveness of professors influence this relationship."), width = 12)
                            ),
                    fluidRow(
                        box(plotOutput("scatterPlot"), width = 12)
                    ),
                    fluidRow(
                        box(plotOutput("barPlot"), width = 12)
                        )
                    ),
            
            ## output for the "Tags" tab ##
            tabItem(tabName = "Tags",
                    fluidRow(
                        box(tags$p("With each review, students can add up to three (out of 20) descriptive tags to characterize the professor."),
                            tags$p("The below figure shows the proportion of the selected tag relative to all tags submitted for that 
                                   department within each college. That is, for the default figure, about 5% of the 
                                   LaGuardia CC’s accounting department professors were given the tag “Accessible Outside of Class”."), width = 12),
                        box(plotOutput("tagsPlot"), width = 12),
                        box(tags$p("Note: an empty column means that particular tag was never given to a professor at that college."), width = 12)
                        )
                    ),
            
            ## output for the "Comments" tab ##
            tabItem(tabName = "Comments",
                    fluidRow(
                        box(tags$p("Students are allowed up to 350 words to write a personal review of their professors."), 
                            tags$p("Below are wordclouds, characterizations of commonly-used words, for the selected department's reviews. Larger text indicates higher
                                   frequencies of words in reviews."), width = 12),
                        box(title = "Borough of Manhattan CC", status = "primary", plotOutput("wordCloud_man")
                            ),
                        box(title = "Kingsboro CC", status = "primary", plotOutput("wordCloud_kng")
                            )
                    ),
                    fluidRow(
                        box(title = "LaGuardia CC", status = "primary", plotOutput("wordCloud_lag")
                            ),
                        box(title = "Nassau CC", status = "primary", plotOutput("wordCloud_nas")
                            )
                    ),
                    fluidRow(
                        box(title = "Queensboro CC", status = "primary", plotOutput("wordCloud_qns")
                            )
                        )
                    )
            )
    )
)

