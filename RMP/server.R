

function(input, output, session) {

# ===========================
# Ratings Tab Plot
# ===========================    
    
    output$ratingPlot = renderPlot({
        

        df = profs %>% filter(department == input$dep) %>%
            group_by(school) %>%
            summarise(Overall = mean(overall_score), Difficulty = mean(difficulty_score))

        ### data for difficulty and overall scores were in 2 different columns
        ### so tidyr::gather places them into a single column
        tidy_df = tidyr::gather(df, survey, Rating, -school)

        ggplot(tidy_df, aes(x = school, y = Rating, fill = survey)) + geom_bar(stat = "identity", position = "dodge") + 
            theme(legend.title = element_blank(), axis.title.x = element_blank(), legend.text = element_text(size = 12),
                  axis.text = element_text(size = 12), axis.title.y = element_text(size = 14)) + ylim(c(0, 5)) + 
            scale_fill_manual(values = c("steelblue4", "cyan3")) + ylab("Average Rating")
    })

# ===========================
# Tags Tab Plot
# ===========================  
    
    output$tagsPlot = renderPlot({
        
        z = grouped_profs %>% select(input$tags, department, school) %>% 
            filter(department == input$dep_tags) %>% 
            group_by(school) 
        
        ggplot(z, aes_string(x = "school", y = input$tags, fill = "school")) + 
            geom_bar(stat = "identity", show.legend = F) +
            labs(title = paste(strsplit(input$tags, split = "\\.")[[1]], collapse = " ")) + 
            theme(axis.title.x = element_blank(), axis.text = element_text(size = 12), plot.title = element_text(hjust = 0.5, size = 16),
                  axis.title.y = element_text(size = 14), panel.border = element_blank()) + 
            ylim(0, 30) +
            ylab("Proportion of All Tags") + scale_fill_brewer(palette = "Dark2")
    })
    m = data.frame(x = 1:10, y = 1:10)

# ===========================
# Comments Tab wordclouds
# ===========================     
    
    # words to remove from each word cloud
    words_to_remove = c(stopwords("SMART"), "the", "and", "you", "his", "she", "professor", "her", "for", "but",
                        "are", "will", "take", "him", "this", "have", "that", "with", "all", "was", "your", "dont",
                        "prof", "teacher", "hes", "makes", "lot", "make", "doesnt", "shes", "student", "taking",
                         "professors", "youll", "person", "teaches", "ive", "highly", "guy", "youre", "made", "class",
                         "students", "accounting", "didnt", "teach", "teaching", "bmcc", "chemistry", "accounting",
                         "math", "physics", "business", "english", "sociology")
    
    # manhattan CC
     output$wordCloud_man = renderPlot({

        content_vec = (
            profs %>% 
                filter(department == input$dep_cloud, school == "Borough of Manhattan CC") %>% 
                select("content"))[[1]]

        if (length(content_vec) == 0) {

            ggplot(m, aes(x = x, y = y)) +
                theme_void() + ggtitle("Department Not at College") + 
                theme(plot.title = element_text(hjust = 0.5))
            
        } else {
            my_corp = Corpus(VectorSource(content_vec))
            my_corp = tm_map(my_corp, content_transformer(tolower))
            my_corp = tm_map(my_corp, removePunctuation)
            my_corp = tm_map(my_corp, removeNumbers)
            my_corp = tm_map(my_corp, removeWords, words_to_remove)
            
            myDTM = TermDocumentMatrix(my_corp, control = list(minWordLength = 1))
            
            m = as.matrix(myDTM)
            v = sort(rowSums(m), decreasing = T)
            d = data.frame(word = names(v), freq = v)
            
            wordcloud(words = d$word, freq = d$freq, scale = c(4, 0.5), min.freq = 5,
                      max.words = 100, random.order = F, rot.per = 0.35, colors = brewer.pal(8, "Dark2"))
        }
        
    })
    
    # nassau CC
    output$wordCloud_nas = renderPlot({
        
        content_vec = (
            profs %>% 
                filter(department == input$dep_cloud, school == "Nassau CC") %>% 
                select("content"))[[1]]
        
        if (length(content_vec) == 0) {
            ggplot(m, aes(x = x, y = y)) +
                theme_void() + ggtitle("Department Not at College") + 
                theme(plot.title = element_text(hjust = 0.5))
        } else {
            my_corp = Corpus(VectorSource(content_vec))
            my_corp = tm_map(my_corp, content_transformer(tolower))
            my_corp = tm_map(my_corp, removePunctuation)
            my_corp = tm_map(my_corp, removeNumbers)
            my_corp = tm_map(my_corp, removeWords, words_to_remove)
            
            myDTM = TermDocumentMatrix(my_corp, control = list(minWordLength = 1))
            
            m = as.matrix(myDTM)
            v = sort(rowSums(m), decreasing = T)
            d = data.frame(word = names(v), freq = v)
            
            wordcloud(words = d$word, freq = d$freq, scale = c(4, 0.5), min.freq = 5,
                      max.words = 100, random.order = F, rot.per = 0.35, colors = brewer.pal(8, "Dark2"))
        }
        
        
    })
    
    # kingsboro
    output$wordCloud_kng = renderPlot({
        
        content_vec = (
            profs %>% 
                filter(department == input$dep_cloud, school == "Kingsboro CC") %>% 
                select("content"))[[1]]
        
        if (length(content_vec) == 0) {
            
            ggplot(m, aes(x = x, y = y)) +
                theme_void() + ggtitle("Department Not at College") + 
                theme(plot.title = element_text(hjust = 0.5))
            
        } else {
            my_corp = Corpus(VectorSource(content_vec))
            my_corp = tm_map(my_corp, content_transformer(tolower))
            my_corp = tm_map(my_corp, removePunctuation)
            my_corp = tm_map(my_corp, removeNumbers)
            my_corp = tm_map(my_corp, removeWords, words_to_remove)
            
            myDTM = TermDocumentMatrix(my_corp, control = list(minWordLength = 1))
            
            m = as.matrix(myDTM)
            v = sort(rowSums(m), decreasing = T)
            d = data.frame(word = names(v), freq = v)
            
            wordcloud(words = d$word, freq = d$freq, scale = c(4, 0.5), min.freq = 5,
                      max.words = 100, random.order = F, rot.per = 0.35, colors = brewer.pal(8, "Dark2"))
        }
        
    })
    
    # queensboro
    output$wordCloud_qns = renderPlot({
        
        content_vec = (
            profs %>% 
                filter(department == input$dep_cloud, school == "Queensboro CC") %>% 
                select("content"))[[1]]
        
        if (length(content_vec) == 0) {
            
            ggplot(m, aes(x = x, y = y)) +
                theme_void() + ggtitle("Department Not at College") + 
                theme(plot.title = element_text(hjust = 0.5))

        } else {
        
            my_corp = Corpus(VectorSource(content_vec))
            my_corp = tm_map(my_corp, content_transformer(tolower))
            my_corp = tm_map(my_corp, removePunctuation)
            my_corp = tm_map(my_corp, removeNumbers)
            my_corp = tm_map(my_corp, removeWords, words_to_remove)
            
            myDTM = TermDocumentMatrix(my_corp, control = list(minWordLength = 1))
            
            m = as.matrix(myDTM)
            v = sort(rowSums(m), decreasing = T)
            d = data.frame(word = names(v), freq = v)
            
            wordcloud(words = d$word, freq = d$freq, scale = c(4, 0.5), min.freq = 5,
                      max.words = 100, random.order = F, rot.per = 0.35, colors = brewer.pal(8, "Dark2"))
        }
        
    })
    
    # laguardia CC
    output$wordCloud_lag = renderPlot({
        
        content_vec = (
            profs %>% 
                filter(department == input$dep_cloud, school == "LaGuardia CC") %>% 
                select("content"))[[1]]
        
        if (length(content_vec) == 0) {
            ggplot(m, aes(x = x, y = y)) +
                theme_void() + ggtitle("Department Not at College") + 
                theme(plot.title = element_text(hjust = 0.5))
        } else {
            my_corp = Corpus(VectorSource(content_vec))
            my_corp = tm_map(my_corp, content_transformer(tolower))
            my_corp = tm_map(my_corp, removePunctuation)
            my_corp = tm_map(my_corp, removeNumbers)
            my_corp = tm_map(my_corp, removeWords, words_to_remove)
            
            myDTM = TermDocumentMatrix(my_corp, control = list(minWordLength = 1))
            
            m = as.matrix(myDTM)
            v = sort(rowSums(m), decreasing = T)
            d = data.frame(word = names(v), freq = v)
            
            wordcloud(words = d$word, freq = d$freq, scale = c(4, 0.5), min.freq = 5,
                      max.words = 100, random.order = F, rot.per = 0.35, colors = brewer.pal(8, "Dark2"))
        }
        
    })

}

#############  To be added in an exploratory tab ############
# output$tilePlot = renderPlot({
# 
#         profs$difficulty_score_fac = as.factor(profs$difficulty_score)
#         
#         if (input$school == "All") {
#             
#             df = profs %>% filter(department == input$dep)
#         
#         } else {
#             
#             df = profs %>% filter(department == input$dep, school == input$school)
#         }
#         
#         df %>%
#             group_by(difficulty_score_fac) %>%
#             summarise(abc = mean(overall_score)) %>%
#             ggplot(aes(x = difficulty_score_fac, y = abc)) +
#             geom_bar(stat = "identity") + xlab("Difficulty Score Rating") +
#             ylab("Mean Overall Score Rating") + ylim(c(0, 5))


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
#    })

