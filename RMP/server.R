
function(input, output, session) {
    
    observe({
        choices = sort(unique(profs[profs$school == input$school, ]$department))
        updateCheckboxGroupInput(session, 
                            inputId = "dep",
                            label = "Department",
                            choices = choices,
                            selected = choices[1])
    })
    
    output$tilePlot = renderPlot({

        df = profs %>% filter(department == input$dep, school == input$school)

        if (input$sex == F) {
            
            all = as.data.frame(table(df$overall_score, df$difficulty_score))
            
            names(all) = c("overall_score", "difficulty_score", "count")
            
            ggplot(all, aes(difficulty_score, overall_score, fill = count)) +
            geom_tile()

        } else {

            to_merge = as.data.frame(table(df$overall_score, df$difficulty_score, df$sex))
            dummy = data.frame(Var1 = as.factor(rep(c(1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5), 10)), 
                               Var2 = as.factor(rep(1:5, 18)), 
                               Var3 = as.factor(c(rep("female", 45), rep("male", 45))))
            
            all = merge(dummy, to_merge, on = c(Var1, Var2, Var3), all.x = T)
            
            all[is.na(all)] = 0

            all$prop = 0

            all[c(1:45), 5] = round(all[1:45, 4] / sum(all[1:45, 4]) * 100, 1)
            all[c(46:90), 5] = round(all[46:90, 4] / sum(all[46:90, 4]) * 100, 1)

            names(all) = c("overall_score", "difficulty_score", "sex", "count", "proportion")
            
            ggplot(all, aes(difficulty_score, overall_score, fill = count)) +
                geom_tile() +
                geom_text(aes(label = proportion, color = sex, hjust = ifelse(sex == "female", 1.5, -0.5))) +
                scale_colour_manual("% Sex", values = c("red","green"))

        } #else {
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
            summarise(overall = mean(overall_score), diff = mean(difficulty_score))
        
        tidy_df = tidyr::gather(df,rating, score, -school)
        
        ggplot(tidy_df, aes(x = school, y = score, fill = rating)) + geom_bar(stat = "identity", position = "dodge")
    })
    
    output$tagsPlot = renderPlot({
        
        tidy_df = tidyr::gather(grouped_profs, props, values, -school, -department)
        
        x = tidy_df %>% filter(props == input$tags, department == input$dep)
         
        ggplot(x, aes(x = props, y = values, fill = school)) + geom_bar(stat = "identity", position = "dodge")
    })
}
    
