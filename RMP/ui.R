
# library(shinydashboard)
# 
# dashboardPage(
#     dashboardHeader(),
#     dashboardSidebar(
#         
#     ),
#     dashboardBody()
# )

fluidPage(
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "school",
                        label = "School",
                        choices = c(BMCC = "man",
                                    QueensboroCC = "qns",
                                    KingsboroCC = "king",
                                    NassauCC = "nas",
                                    LaGuardiaCC = "lg"),
                        selected = "man"),
            checkboxInput(inputId = "sex",
                          label = "Show Gender Proportions",
                          value = T),
            checkboxGroupInput(inputId = "dep", 
                               label = "Department",
                               choices = list("Accounting","Anthropology", "Art", "Behavioral Sciences",
                                              "Biology", "Business", "Chemistry", "Communication",
                                              "Computer Science", "Criminal Justice", "Cultural Studies",
                                              "Early Childhood Education", "Economics", "Education",
                                              "Engineering", "English", "Fashion", "Finance", "Geology",
                                              "Health Science", "History, Philosophy, Poly Sci",
                                              "Languages", "Law", "Management", "Marketing",
                                              "Mathematics", "Music", "Nursing", "Physical Ed",
                                              "Physical Sciences", "Physics", "Psychology", "Social Science",
                                              "Social Work", "Sociology"),
                               selected = "Accounting"),
            selectInput(inputId = "tags",
                        label = "Select Professor Tags",
                        choices = c(`Accessible Outside of Class` = "acc.out.class.prop",
                                    `Amazing Lectures` = "amaz.lect.prop",
                                    `Beware of Pop Quizzes` = "pop.quiz.prop",
                                    Caring = "caring.prop",
                                    `Clear Grading Criteria` = "grad.crit.prop",
                                    `Extra Credit` = "ext.cred.prop",
                                    `Get Ready to Read` = "read.prop",
                                    `Gives Good Feedback` = "feedback.prop",
                                    `Graded by Few Things` = "few.things.prop",
                                    `Group Projects` = "group.proj.prop",
                                    Hilarious = "hilarious.prop",
                                    Inspirational = "inspirational.prop",
                                    `Lecture Heavy` = "lecture.heavy.prop",
                                    `Lots of Homework` = "homework.prop",
                                    `Participation Matters` = "participation.prop",
                                    Respected = "respected.prop",
                                    `Skip Class? You won't Pass` = "skip.class.prop",
                                    `So Many Papers` = "many.papers.prop",
                                    `Test Heavy` = "test.heavy.prop",
                                    `Tough Grader` = "tough.grader.prop"),
                        selected = "acc.out.class.prop")
            ),
        mainPanel(
            plotOutput("tilePlot"),
            plotOutput("ratingPlot"),
            plotOutput("tagsPlot")
            )
        )

    
    )

