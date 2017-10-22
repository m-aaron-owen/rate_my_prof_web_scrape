
function(input, output) {
    output$distPlot <- renderPlot({
        
        if (input$grouped == "None") {
            ggplot(profs, aes(x = difficulty_score, y = overall_score)) +
                geom_point(position = "jitter", alpha = 0.03, color = "white") +
                scale_color_manual(values = "red") + 
                stat_sum(inherit.aes = F, aes(x = difficulty_score, y = overall_score, 
                                                     label = paste(round(..prop.. * 100, 1))), 
                         size = 4, geom = "text", position = position_dodge(width = 0.8), color = "red") +
                theme(panel.background = element_rect(fill = "black"), panel.grid.major = element_blank(),
                      panel.grid.minor.y = element_blank()) +
                geom_hline(yintercept = 0.75, color = "white") +
                geom_hline(yintercept = 1.25, color = "white") +
                geom_hline(yintercept = 1.75, color = "white") +
                geom_hline(yintercept = 2.25, color = "white") +
                geom_hline(yintercept = 2.75, color = "white") +
                geom_hline(yintercept = 3.25, color = "white") +
                geom_hline(yintercept = 3.75, color = "white") +
                geom_hline(yintercept = 4.25, color = "white") +
                geom_hline(yintercept = 4.75, color = "white") +
                geom_hline(yintercept = 5.25, color = "white")
        } else {
            ggplot(profs, aes(x = difficulty_score, y = overall_score)) +
                geom_point(position = "jitter", alpha = 0.03, color = "white") +
                scale_color_manual(values = c("red", "orange")) + 
                stat_sum(inherit.aes = F, aes_string(x = "difficulty_score", y = "overall_score", 
                                                     color = input$grouped, label = "paste(round(..prop.. * 100, 1))"), 
                         size = 4, geom = "text", position = position_dodge(width = 0.8)) +
                theme(panel.background = element_rect(fill = "black"), panel.grid.major = element_blank(),
                      panel.grid.minor.y = element_blank()) +
                geom_hline(yintercept = 0.75, color = "white") +
                geom_hline(yintercept = 1.25, color = "white") +
                geom_hline(yintercept = 1.75, color = "white") +
                geom_hline(yintercept = 2.25, color = "white") +
                geom_hline(yintercept = 2.75, color = "white") +
                geom_hline(yintercept = 3.25, color = "white") +
                geom_hline(yintercept = 3.75, color = "white") +
                geom_hline(yintercept = 4.25, color = "white") +
                geom_hline(yintercept = 4.75, color = "white") +
                geom_hline(yintercept = 5.25, color = "white")
        }
        
    })
}
