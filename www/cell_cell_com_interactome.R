color_vector <- function(column) {
  # Create a unique set of values from the column
  unique_values <- unique(column)
  
  # Assign a color to each unique value
  #colors <- rainbow(length(unique_values))
  colors <- hsv(seq(0,1 - 1/length(unique_values),length.out = length(unique_values)), .35, .85)
  
  # Map each value in the column to its corresponding color
  color_vector <- colors[match(column, unique_values)]
  
  return(color_vector)
}
Visualize_chord_network <- function(DF){
  
  Cell_cell_Data_draw <- DF[,c( "Ligand", "Receptor", "score")]
  # Get the color vector for the column
  grid_colors <- color_vector(c(DF$Lig.pop, DF$Rec.pop))
  names(grid_colors) <- c(DF$Ligand, DF$Receptor)
  #Plot the circos 
  circos.par(gap.degree=1)
  chordDiagram(Cell_cell_Data_draw,
               directional = 1, diffHeight = mm_h(5),
               annotationTrack = "grid",
               preAllocateTracks = 1,
               direction.type = c("diffHeight", "arrows"),
               grid.col = grid_colors,
               link.arr.type = "big.arrow",
               link.arr.length = 0.2)
  circos.trackPlotRegion(track.index = 1, panel.fun = function(x, y) {
    xlim = get.cell.meta.data("xlim")
    xplot = get.cell.meta.data("xplot")
    ylim = get.cell.meta.data("ylim")
    sector.name = get.cell.meta.data("sector.index")
    circos.text(mean(xlim), ylim[1], sector.name, facing = "clockwise", niceFacing = TRUE, 
                adj = c(0, .75),cex=1)
  },bg.border = NA)
  #Plot the cell types 
  names(grid_colors) <- c(DF$Lig.pop, DF$Rec.pop)
  grid_colors <- grid_colors[!duplicated(grid_colors)]
  
  #define the legend outline based on the number of cells 
  ncol <- NULL
  if (length(names(grid_colors)) > 15){
    ncol <- 3
  }else{
    ncol <- 1
  }
  L1 <- Legend(labels = names(grid_colors),
             type = "points", 
              background  = grid_colors,
              legend_gp = gpar(col = "white"),
              title = "Cell Type",
              title_gp = gpar(fontsize = 16),
              labels_gp = gpar(fontsize = 16),
             ncol = ncol)
  draw(L1, just = c("left"), x= unit(1, "npc") - unit(120, "mm"))
}
