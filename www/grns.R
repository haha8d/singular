plot_grns <- function(DF)
{
  ids <-  unique(c(DF$TF, DF$target))
  
  source_Nodesize <- data.frame(plyr::count(DF$TF))
  source_Nodesize$freq <- source_Nodesize$freq + 1
  
  to_Nodesize <- data.frame(x = unique(DF$target[!(DF$target %in% DF$TF)]))
  to_Nodesize$freq <- 1
  nodes_size <- rbind(source_Nodesize, to_Nodesize)
  colnames(nodes_size)[2] <- "value"
  
  nodes <- data.frame(id = ids, label = ids,
                      shape = ifelse(ids %in% DF$TF & ids %in% DF$target, "circle", "bigdot"), #change the shapes to circle and dot to get the v1
                      shadow = TRUE,
                      color = ifelse(ids %in% DF$TF & ids %in% DF$target, "darkblue", "lightblue"),
                      font.color = "white")
  
  nodes <- merge(nodes, nodes_size, by.x = "id", by.y = "x")
  edges <- data.frame(from = DF$TF, to = DF$target, arrows = "to",
                      color = ifelse(DF$effect == "Activation", "darkgreen", "darkred"))
  
  net <- visNetwork(nodes, edges, width = "100%", height = 900)%>% 
    visNodes(shadow = list(enabled = TRUE)) %>% 
    visEdges(smooth = list(enabled = TRUE)) %>% 
    visInteraction(navigationButtons = TRUE)  %>% 
    visOptions(highlightNearest = list(enabled = TRUE, algorithm = "hierarchical"), nodesIdSelection = TRUE)
  
  net
}