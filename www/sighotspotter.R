prepare_sighotspotter_data <- function(nodes_DF, edges_DF, study, tissue, cell, weight){
  selected_nodes <- nodes_DF[nodes_DF$study == study &
                               nodes_DF$tissue == tissue &
                               nodes_DF$cell == cell ,]
  
  selected_edges <- edges_DF[edges_DF$study == study &
                               edges_DF$tissue == tissue &
                               edges_DF$cell == cell &
                               edges_DF$weight >= weight,]
  
  return(list(selected_nodes, selected_edges))
}

plot_sighotspotter <- function(nodes, edges){
  
  net <- visNetwork(nodes, edges, width = "100%", height = 900)%>% 
    visNodes(shadow = list(enabled = TRUE)) %>% 
    visEdges(smooth = list(enabled = TRUE), arrows = "to") %>% 
    visInteraction(navigationButtons = TRUE)  %>% 
    visLegend(position = "right", main = "", width = 0.1, stepY = 50) %>% 
    visOptions(highlightNearest = list(enabled = TRUE, algorithm = "hierarchical"), nodesIdSelection = TRUE)
  
  net
}
