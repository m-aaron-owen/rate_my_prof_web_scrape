
# function(input, output) {
#     set.seed(122)
#     histdata <- rnorm(500)
#     
#     output$plot1 <- renderPlot({
#         data <- histdata[seq_len(input$slider)]
#         hist(data)
#     })
# }
# 



#############################

function(input, output, session) {

    observe({

        choices = sort(unique(profs[profs$school == input$school, ]$department))
        updateCheckboxGroupInput(session,
                                 inputId = "dep",
                                 label = "Department",
                                 choices = choices,
                                 selected = choices[1])

    })

    # observe({
    #     choices = sort(unique(profs[profs$school == input$school_cloud, ]$department))
    #     updateSelectInput(session,
    #                      inputId = "dep_cloud",
    #                      label = "Department",
    #                      choices = choices,
    #                      selected = choices[1])
    # })

    output$tilePlot = renderPlot({

        profs$difficulty_score_fac = as.factor(profs$difficulty_score)
        
        if (input$school == "All") {
            
            df = profs %>% filter(department == input$dep)
        
        } else {
            
            df = profs %>% filter(department == input$dep, school == input$school)
        }
        
        df %>%
            group_by(difficulty_score_fac) %>%
            summarise(abc = mean(overall_score)) %>%
            ggplot(aes(x = difficulty_score_fac, y = abc)) +
            geom_bar(stat = "identity") + xlab("Difficulty Score Rating") +
            ylab("Mean Overall Score Rating") + ylim(c(0, 5))
        
# 
#         if (input$sex == F) {
# 
#             all = as.data.frame(table(df$overall_score, df$difficulty_score))
# 
#             names(all) = c("overall_score", "difficulty_score", "count")
# 
#             ggplot(all, aes(difficulty_score, overall_score, fill = count)) +
#             geom_tile()
# 
#         } else {

            # to_merge = as.data.frame(table(df$overall_score, df$difficulty_score, df$sex))
            # dummy = data.frame(Var1 = as.factor(rep(c(1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5), 10)),
            #                    Var2 = as.factor(rep(1:5, 18)),
            #                    Var3 = as.factor(c(rep("female", 45), rep("male", 45))))
            # 
            # all = merge(dummy, to_merge, on = c(Var1, Var2, Var3), all.x = T)
            # 
            # all[is.na(all)] = 0
            # 
            # all$prop = 0
            # 
            # names(all) = c("overall_score", "difficulty_score", "sex", "count", "proportion")
            # 
            # all = all %>% arrange(sex)
            # 
            # all[1:45, 5] = round(all[1:45, 4] / sum(all[1:45, 4]) * 100, 1)
            # all[46:90, 5] = round(all[46:90, 4] / sum(all[46:90, 4]) * 100, 1)
            # 
            # ggplot(all, aes(difficulty_score, overall_score, fill = count)) +
            #     geom_tile() +
            #     geom_text(aes(label = proportion, color = sex, hjust = ifelse(sex == "female", 1.5, -0.5))) +
            #     scale_colour_manual("% Sex", values = c("pink","green"))

         #else {
#
#             to_merge = as.data.frame(table(df$overall_score, df$difficulty_score, df$chili))
#             dummy = data.frame(Var1 = as.factor(rep(c(1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5), 10)),
#                                Var2 = as.factor(rep(1:5, 18)),
#                                Var3 = as.factor(c(rep("attractive", 45), rep("not attractive", 45))))
#
#             all = merge(dummy, to_merge, on = c(Var1, Var2, Var3), all.x = T)
#
#             all[is.na(all)] = 0
#
#             all$prop = 0
#
#             all[c(1:45), 5] = round(all[1:45, 4] / sum(all[1:45, 4]) * 100, 1)
#             all[c(46:90), 5] = round(all[46:90, 4] / sum(all[46:90, 4]) * 100, 1)
#
#             names(all) = c("overall_score", "difficulty_score", "pepper", "count", "proportion")
#
#             ggplot(all, aes(difficulty_score, overall_score, fill = count)) +
#                 geom_tile() +
#                 geom_text(aes(label = proportion, color = pepper, hjust = ifelse(pepper == "attractive", 1.5, -0.5))) +
#                 scale_colour_manual("% Pepper", values = c("red","green"))
#         }
    })

    output$ratingPlot = renderPlot({

        df = profs %>% filter(department == input$dep) %>%
            group_by(school) %>%
            summarise(`Overall Rating` = mean(overall_score), `Difficulty Rating` = mean(difficulty_score))

        tidy_df = tidyr::gather(df, Rating, score, -school)

        ggplot(tidy_df, aes(x = school, y = score, fill = Rating)) + geom_bar(stat = "identity", position = "dodge") + 
            theme(legend.title = element_blank(), axis.title.y = element_blank()) + ylim(c(0, 5)) + xlab("")
    })

    output$tagsPlot = renderPlot({

        # df = grouped_profs %>% select_(input$tags, "department", "school") %>%
        #     filter(department == input$dep) %>%
        #     group_by(school) %>%
        #     summarise_(abc = mean(as.numeric(input$tags), na.rm = T))
        #
        # print(class(input$tags)) # --> says input$tags is character
        # df[is.na(df)] = 0
        #
        # ggplot(df, aes(x = school, y = abc, fill = school)) + geom_bar(stat = "identity")

        tidy_df = tidyr::gather(grouped_profs, props, values, -school, -department)

        x = tidy_df %>% filter(props == input$tags, department == input$dep_tags)
        
        ggplot(x, aes(x = props, y = values, fill = school)) + geom_bar(stat = "identity", position = "dodge") +
            xlab(paste(strsplit(input$tags, split = "\\.")[[1]], collapse = " ")) + 
            ylab("Proportion of all Tags") + 
            theme(axis.text.x = element_blank())
    })

    output$wordCloud_man = renderPlot({

        content_vec = (profs %>% filter(department == input$dep_cloud, school == "MAN") %>% select("content"))[[1]]

        if (length(content_vec) == 0) {
            print("empty")
        } else {
            my_corp = Corpus(VectorSource(content_vec))
            my_corp = tm_map(my_corp, content_transformer(tolower))
            my_corp = tm_map(my_corp, removePunctuation)
            my_corp = tm_map(my_corp, removeNumbers)
            my_corp = tm_map(my_corp, removeWords,
                             c(stopwords("SMART"), "the", "and", "you", "his", "she", "professor", "her", "for", "but",
                               "are", "will", "take", "him", "this", "have", "that", "with", "all", "was", "your", "dont",
                               "prof", "teacher", "hes", "makes", "lot", "make", "doesnt", "shes", "student", "taking",
                               "professors", "youll", "person", "teaches", "ive", "highly", "guy", "youre", "made", "class",
                               "students", "accounting", "didnt", "teach", "teaching", "bmcc"))
            
            myDTM = TermDocumentMatrix(my_corp, control = list(minWordLength = 1))
            
            m = as.matrix(myDTM)
            v = sort(rowSums(m), decreasing = T)
            d = data.frame(word = names(v), freq = v)
            
            wordcloud(words = d$word, freq = d$freq, scale = c(4, 0.5), min.freq = 5,
                      max.words = 100, random.order = F, rot.per = 0.35, colors = brewer.pal(8, "Dark2"))
        }
        
    })
    
    output$wordCloud_nas = renderPlot({
        
        content_vec = (profs %>% filter(department == input$dep_cloud, school == "NAS") %>% select("content"))[[1]]
        
        if (length(content_vec) == 0) {
            print("empty")
        } else {
            my_corp = Corpus(VectorSource(content_vec))
            my_corp = tm_map(my_corp, content_transformer(tolower))
            my_corp = tm_map(my_corp, removePunctuation)
            my_corp = tm_map(my_corp, removeNumbers)
            my_corp = tm_map(my_corp, removeWords,
                             c(stopwords("SMART"), "the", "and", "you", "his", "she", "professor", "her", "for", "but",
                               "are", "will", "take", "him", "this", "have", "that", "with", "all", "was", "your", "dont",
                               "prof", "teacher", "hes", "makes", "lot", "make", "doesnt", "shes", "student", "taking",
                               "professors", "youll", "person", "teaches", "ive", "highly", "guy", "youre", "made", "class",
                               "students", "accounting", "didnt", "teach", "teaching", "bmcc"))
            
            myDTM = TermDocumentMatrix(my_corp, control = list(minWordLength = 1))
            
            m = as.matrix(myDTM)
            v = sort(rowSums(m), decreasing = T)
            d = data.frame(word = names(v), freq = v)
            
            wordcloud(words = d$word, freq = d$freq, scale = c(4, 0.5), min.freq = 5,
                      max.words = 100, random.order = F, rot.per = 0.35, colors = brewer.pal(8, "Dark2"))
        }
        
        
    })
    
    output$wordCloud_kng = renderPlot({
        
        content_vec = (profs %>% filter(department == input$dep_cloud, school == "KNG") %>% select("content"))[[1]]
        
        if (length(content_vec) == 0) {
            print("empty")
        } else {
            my_corp = Corpus(VectorSource(content_vec))
            my_corp = tm_map(my_corp, content_transformer(tolower))
            my_corp = tm_map(my_corp, removePunctuation)
            my_corp = tm_map(my_corp, removeNumbers)
            my_corp = tm_map(my_corp, removeWords,
                             c(stopwords("SMART"), "the", "and", "you", "his", "she", "professor", "her", "for", "but",
                               "are", "will", "take", "him", "this", "have", "that", "with", "all", "was", "your", "dont",
                               "prof", "teacher", "hes", "makes", "lot", "make", "doesnt", "shes", "student", "taking",
                               "professors", "youll", "person", "teaches", "ive", "highly", "guy", "youre", "made", "class",
                               "students", "accounting", "didnt", "teach", "teaching", "bmcc"))
            
            myDTM = TermDocumentMatrix(my_corp, control = list(minWordLength = 1))
            
            m = as.matrix(myDTM)
            v = sort(rowSums(m), decreasing = T)
            d = data.frame(word = names(v), freq = v)
            
            wordcloud(words = d$word, freq = d$freq, scale = c(4, 0.5), min.freq = 5,
                      max.words = 100, random.order = F, rot.per = 0.35, colors = brewer.pal(8, "Dark2"))
        }
        
    })
    
    output$wordCloud_qns = renderPlot({
        
        content_vec = (profs %>% filter(department == input$dep_cloud, school == "QNS") %>% select("content"))[[1]]
        
        if (length(content_vec) == 0) {
            print("empty")
        } else {
            my_corp = Corpus(VectorSource(content_vec))
            my_corp = tm_map(my_corp, content_transformer(tolower))
            my_corp = tm_map(my_corp, removePunctuation)
            my_corp = tm_map(my_corp, removeNumbers)
            my_corp = tm_map(my_corp, removeWords,
                             c(stopwords("SMART"), "the", "and", "you", "his", "she", "professor", "her", "for", "but",
                               "are", "will", "take", "him", "this", "have", "that", "with", "all", "was", "your", "dont",
                               "prof", "teacher", "hes", "makes", "lot", "make", "doesnt", "shes", "student", "taking",
                               "professors", "youll", "person", "teaches", "ive", "highly", "guy", "youre", "made", "class",
                               "students", "accounting", "didnt", "teach", "teaching", "bmcc"))
            
            myDTM = TermDocumentMatrix(my_corp, control = list(minWordLength = 1))
            
            m = as.matrix(myDTM)
            v = sort(rowSums(m), decreasing = T)
            d = data.frame(word = names(v), freq = v)
            
            wordcloud(words = d$word, freq = d$freq, scale = c(4, 0.5), min.freq = 5,
                      max.words = 100, random.order = F, rot.per = 0.35, colors = brewer.pal(8, "Dark2"))
        }
        
    })
    
    output$wordCloud_lag = renderPlot({
        
        content_vec = (profs %>% filter(department == input$dep_cloud, school == "LAG") %>% select("content"))[[1]]
        
        if (length(content_vec) == 0) {
            print("empty")
        } else {
            my_corp = Corpus(VectorSource(content_vec))
            my_corp = tm_map(my_corp, content_transformer(tolower))
            my_corp = tm_map(my_corp, removePunctuation)
            my_corp = tm_map(my_corp, removeNumbers)
            my_corp = tm_map(my_corp, removeWords,
                             c(stopwords("SMART"), "the", "and", "you", "his", "she", "professor", "her", "for", "but",
                               "are", "will", "take", "him", "this", "have", "that", "with", "all", "was", "your", "dont",
                               "prof", "teacher", "hes", "makes", "lot", "make", "doesnt", "shes", "student", "taking",
                               "professors", "youll", "person", "teaches", "ive", "highly", "guy", "youre", "made", "class",
                               "students", "accounting", "didnt", "teach", "teaching", "bmcc"))
            
            myDTM = TermDocumentMatrix(my_corp, control = list(minWordLength = 1))
            
            m = as.matrix(myDTM)
            v = sort(rowSums(m), decreasing = T)
            d = data.frame(word = names(v), freq = v)
            
            wordcloud(words = d$word, freq = d$freq, scale = c(4, 0.5), min.freq = 5,
                      max.words = 100, random.order = F, rot.per = 0.35, colors = brewer.pal(8, "Dark2"))
        }
        
    })

}

