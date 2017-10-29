
function(input, output, session) {

# ===========================
# Ratings I Tab Plot
# ===========================    
    
    output$ratingPlot = renderPlot({
        
        df = profs %>% filter(department %in% input$dep) %>% group_by(school) %>%
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
# Ratings II Tab Plots
# ===========================
    
    output$scatterPlot = renderPlot({
        
        if (input$school == "All") {
            
            df = profs %>% filter(department %in% input$dep_exp)
            
        } else {
            
            df = profs %>% filter(school == input$school, department %in% input$dep_exp)
        }
        
        df %>% 
            ggplot(aes(x = difficulty_score, y = overall_score)) + 
            geom_point(position = "jitter", color = "white") + 
            geom_smooth(aes(color = sex), method = "lm", se = F) + 
            geom_smooth(aes(color = chili), method = "lm", se = F) +
            ylim(c(0.75, 5.25)) +
            scale_color_discrete(breaks = c("male", "female", "attractive", "not attractive")) +
            scale_y_continuous(breaks = seq(0, 5, 0.5)) +
            geom_hline(yintercept = 0.75, color = "white") +
            geom_hline(yintercept = 1.25, color = "white") +
            geom_hline(yintercept = 1.75, color = "white") +
            geom_hline(yintercept = 2.25, color = "white") +
            geom_hline(yintercept = 2.75, color = "white") +
            geom_hline(yintercept = 3.25, color = "white") +
            geom_hline(yintercept = 3.75, color = "white") +
            geom_hline(yintercept = 4.25, color = "white") +
            geom_hline(yintercept = 4.75, color = "white") +
            geom_hline(yintercept = 5.25, color = "white") +
            labs(x = "Difficulty Score", y = "Overall Score") +
            theme(legend.title = element_blank(), panel.background = element_rect(fill = "black"), 
                  panel.grid.major.x = element_blank(), panel.grid.minor.x = element_line(color = "white"),
                  panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank(),
                  axis.ticks = element_blank(), axis.title = element_text(size = 14), 
                  axis.text = element_text(size = 12), legend.text = element_text(size = 12),
                  legend.position = "top") 
        
    })
    
    output$barPlot = renderPlot({
        
        if (input$school == "All") {
            
            df = profs %>% filter(department %in% input$dep_exp)
            
        } else {
            
            df = profs %>% filter(school == input$school, department %in% input$dep_exp)
        }
        
        df %>%
            group_by(difficulty_score_fac) %>%
            summarise(abc = mean(overall_score)) %>%
            ggplot(aes(x = difficulty_score_fac, y = abc, fill = difficulty_score_fac)) +
            geom_bar(stat = "identity", show.legend = F) + 
            labs(x = "Difficulty Score", y = "Mean Overall Score") +
            ylim(c(0, 5)) +
            theme(axis.title = element_text(size = 14), axis.text = element_text(size = 12))
        
    })

# ===========================
# Tags Tab Plot
# ===========================  
    
    output$tagsPlot = renderPlot({
        
        df = grouped_profs %>% select(input$tags, department, school) %>% 
            filter(department == input$dep_tags) %>% 
            group_by(school) 
        
        ggplot(df, aes_string(x = "school", y = input$tags, fill = "school")) + 
            geom_bar(stat = "identity", show.legend = F) +
            labs(title = paste(strsplit(input$tags, split = "\\.")[[1]], collapse = " ")) + 
            theme(axis.title.x = element_blank(), axis.text = element_text(size = 12), plot.title = element_text(hjust = 0.5, size = 16),
                  axis.title.y = element_text(size = 14), panel.border = element_blank()) + 
            ylim(0, 30) +
            ylab("Proportion of All Tags") + scale_fill_brewer(palette = "Dark2")
        
    })

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
        
        ## not all schools have all departments; this prints an empty plot with text in the center ##
        if (length(content_vec) == 0) {
            ggplot() + 
                ylim(c(1, 5)) +
                theme_void() +
                ggplot2::annotate("text", x = 1, y = 4, label = "Department Not at College", size = 7)
            
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
            ggplot() + 
                ylim(c(1, 5)) +
                theme_void() +
                ggplot2::annotate("text", x = 1, y = 4, label = "Department Not at College", size = 7)
            
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
            
            ggplot() + 
                ylim(c(1, 5)) +
                theme_void() +
                ggplot2::annotate("text", x = 1, y = 4, label = "Department Not at College", size = 7)
            
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
            
            ggplot() + 
                ylim(c(1, 5)) +
                theme_void() +
                ggplot2::annotate("text", x = 1, y = 4, label = "Department Not at College", size = 7)

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
            ggplot() + 
                ylim(c(1, 5)) +
                theme_void() +
                ggplot2::annotate("text", x = 1, y = 4, label = "Department Not at College", size = 7)
            
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
