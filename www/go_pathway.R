plot_go_pathway <- function(DF, title){
  
  
  Enr.plot <- ggplot(DF, aes(x = enrichmentRatio, 
                             y = reorder(description, -enrichmentRatio), 
                             size = size/overlap, 
                             color = 'darkred')) + geom_point() + theme_bw() + 
    xlab("Enrichment Ratio") + ylab("") +
    theme(legend.position = "right", text = element_text(face = "bold"),
          axis.text = element_text(face = "bold"), plot.title = element_text(hjust = 0.5)) +
    scale_colour_discrete(guide = "none") +
    labs(size = "Enrichment (Size/Overlap)") + ggtitle(title)

  return(Enr.plot)
}
