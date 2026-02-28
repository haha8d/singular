## app.R ##
library(shiny)
library(shinydashboard)
library(dashboardthemes)
library(shinycustomloader)
library(shinyalert)
library(shinyjs)
library(ggplot2)
library(ggpubr)
library(DT)
library(circlize)#CCC-Interactome
library(ComplexHeatmap)#CCC-Interactome
library(visNetwork)#GRN
library(htmlwidgets)#GRN
library(plyr)#GRN

#Source the helper function
source("www/cell_cell_com_interactome.R")
source("www/grns.R")
source("www/go_pathway.R")
source("www/sighotspotter.R")
#cell-cell communication data 
cell_cell_com_interactome <- read.csv("Visualization-data/Cell-Cell-Com/Interactome.csv")
cell_cell_com_interactome$significance <- round(cell_cell_com_interactome$significance, 3)
#SighotSpotter 
cell_cell_com_sighotspotter_nodes <- read.csv("Visualization-data/Cell-Cell-Com/SighotSpotter_nodes.csv")
cell_cell_com_sighotspotter_edges <- read.csv("Visualization-data/Cell-Cell-Com/SighotSpotter_edges.csv")
cell_cell_com_sighotspotter_edges$weight <- round(cell_cell_com_sighotspotter_edges$weight, 3)
#grn data
grn_grni3 <- read.csv("Visualization-data/GRN/GRNI.csv")
grn_grni3$Score <- round(grn_grni3$Score, 4)

#Gene ontology data 
gene_ontology <- read.csv("Visualization-data/GO/GO.csv")
gene_ontology <- gene_ontology[gene_ontology$FDR != 0,]
gene_ontology$FDR <- round(gene_ontology$FDR, 4)
gene_ontology$expect <- round(gene_ontology$expect, 3)
gene_ontology$enrichmentRatio <- round(gene_ontology$enrichmentRatio, 3)
gene_ontology$link <- paste0("<a href='", gene_ontology$link, "'>",gene_ontology$link, "</a>")
#Pathway data 
pathway_kegg <- read.csv("Visualization-data/Pathway/pathways.csv")
pathway_kegg <- pathway_kegg[pathway_kegg$FDR != 0,]
pathway_kegg$FDR <- round(pathway_kegg$FDR, 4)
pathway_kegg$expect <- round(pathway_kegg$expect, 3)
pathway_kegg$link <- paste0("<a href='", pathway_kegg$link, "'>",pathway_kegg$link, "</a>")

#Start the UI 
ui <- tagList(
  dashboardPage(
  dashboardHeader(title = "Singular"),
  ## Sidebar content
  dashboardSidebar( 
    sidebarMenu(
      menuItem("Documentation", tabName = "welcome", icon = icon("file")),
      menuItem("Gene Ontology", tabName = "GO", icon = icon("bar-chart")),
      menuItem("Pathway Enrichment analysis", tabName = "PEA", icon = icon("chart-column")),
      menuItem("Gene Regulatory Networks", tabName = "GRN", icon = icon("circle-nodes")),
      menuItem("Cell Cell Communication", tabName = "CCC", icon = icon("diagram-project"))
      
      
      #)# menu item closing
    )
  ),#Side bar closing
  dashboardBody(
    shinyDashboardThemes(
      theme = "blue_gradient"
    ),
    useShinyjs(),
    tabItems(
      # Boxes need to be put in a row (or column)
      tabItem(tabName = "welcome",
              includeMarkdown("www/README.md")
      ),#Welcome tab
      
      tabItem(tabName = "GO",
              tabPanel(title = "Gene Ontology", value = "go",
                       sidebarLayout(
                         sidebarPanel(
                           selectInput(inputId = "study_go", "Study", ""),
                           selectInput(inputId = "tissue_go", "Tissue", ""),
                           uiOutput("cell_type_go"),
                           uiOutput("fdr_go"),
                           numericInput(inputId = "Top_N_go", label = "Select Top N GOs", value = 10),
                           actionButton("submit_go", "Submit")
                         ),
                         mainPanel(
                           fluidRow(
                             div(style = "overflow-x: auto;",
                               withLoader(plotOutput("go_plot", height = 750, width = 1350), type = "html", loader = "loader4")),
                             withLoader(DT::dataTableOutput("go_table"), type = "html", loader = "loader4")
                             
                           )# fluid row closing 
                         ),#main panel closing
                       )#sidebar layout closing
                       
              ),#tab Panel closing Gene ontology  
      ), #tab item GO 
      
      tabItem(tabName = "PEA",
              tabPanel(title = "Pathway Enrichment", value = "pea",
                       sidebarLayout(
                         sidebarPanel(
                           selectInput(inputId = "study_kegg", "Study", ""),
                           selectInput(inputId = "tissue_kegg", "Tissue", ""),
                           uiOutput("cell_type_kegg"),
                           uiOutput("fdr_kegg"),
                           numericInput(inputId = "Top_N_kegg", label = "Select Top N pathways", value = 10),
                           actionButton("submit_kegg", "Submit")
                         ),
                         mainPanel(
                           fluidRow(
                             div(style = "overflow-x: auto;",
                             withLoader(plotOutput("kegg_plot", height = 750, width = 1750), type = "html", loader = "loader4")),
                             withLoader(DT::dataTableOutput("kegg_table"), type = "html", loader = "loader4")
                             
                           )# fluid row closing 
                         ),#main panel closing
                       )#sidebar layout closing
                       
              ),#tab Panel closing pathway enrichment  
      ), #tab item pathway 
      
      
      tabItem(tabName = "GRN",
              tabPanel(title = "GRNS", value = "grn",
                       sidebarLayout(
                         sidebarPanel(
                           selectInput(inputId = "study_grn", "Study", ""),
                           selectInput(inputId = "tissue_grn", "Tissue", ""),
                           uiOutput("cell_type_GRN"),
                           sliderInput("score_grn", "Significance:", min = 0, max = 1, value = 0.5),
                           actionButton("submit_grn", "Submit")
                         ),
                         mainPanel(
                           fluidRow(
                             withLoader(visNetworkOutput("grni3_grn", height = 750, width = 1100), type = "html", loader = "loader4"),
                             withLoader(DT::dataTableOutput("grn_table"), type = "html", loader = "loader4")
                             
                           )# fluid row closing 
                         ),#main panel closing
                       )#sidebar layout closing
                       
              ),#tab Panel closing Interactome 
              
      ),#GRN tab item 
      tabItem(tabName = "CCC",
              tabsetPanel(
                tabPanel(title = "Interactome", value = "interactome",
                         sidebarLayout(
                           sidebarPanel(
                             selectInput(inputId = "study", "Study", ""),
                             selectInput(inputId = "tissue", "Tissue", ""),
                             sliderInput("intercome_score", "Significance:", min = 0, max = 1, value = 0.5),
                             actionButton("submit", "Submit")
                           ),
                           mainPanel(
                             fluidRow(
                               div(style = "overflow-x: auto;",
                               withLoader(plotOutput("interactome_Chrod", height = 850, width = 1550), type = "html", loader = "loader4")),
                               withLoader(DT::dataTableOutput("interactome_table"), type = "html", loader = "loader4")
                               
                             )# fluid row closing 
                           ),#main panel closing
                         )#sidebar layout closing
                  
                ),#tab Panel closing Interactome 
                tabPanel(title = "Sighotspotter", value = "sighotspotter",
                         sidebarLayout(
                           sidebarPanel(
                             selectInput(inputId = "study_sighot", "Study", ""),
                             selectInput(inputId = "tissue_sighot", "Tissue", ""),
                             uiOutput("cell_type_sighot"),
                             sliderInput("sighot_score", "Weight:", min = 0, max = 1, value = 0.5),
                             actionButton("submit_sighot", "Submit")
                           ),
                           mainPanel(
                             fluidRow(
                               div(style = "overflow-x: auto;",
                                   withLoader(visNetworkOutput("sighot_network", height = 850, width = 1550),
                                              type = "html", loader = "loader4")),
                               withLoader(DT::dataTableOutput("sighot_table"), type = "html", loader = "loader4")
                               
                             )# fluid row closing 
                           ),#main panel closing
                         )#sidebar layout closing
                         )#tab Panel Closing SighotSpotter 
                         
              )#tab Set Panel closing 
              

              
      )#stat tab item 
      
    ),#tab items

    br(), br(), br(), br(),
  tags$footer(
    tags$div(
      class = "ui vertical segment transparent-footer",
      tags$div(
        class = "ui center aligned container",
        tags$div(class = "ui section divider"),
        tags$div(
          class = "copyrights_social_media",
          tags$p(
            class = "copyright",
            "Copyright © ",
            tags$a(href = "https://wwwen.uni.lu/", "University of Luxembourg"),
            " 2024. All rights reserved."
          ),
          tags$div(
            class = "social_media",
            tags$a(href = "https://www.facebook.com/uni.lu", icon("facebook")),
            tags$a(href = "https://twitter.com/uni_lu", icon("twitter")),
            tags$a(href = "https://www.linkedin.com/school/university-of-luxembourg/", icon("linkedin")),
            tags$a(href = "https://www.instagram.com/uni.lu/", icon("instagram")),
            tags$a(href = "https://www.youtube.com/user/luxuni", icon("youtube"))
          )
        ), br(),
        tags$p("Designed by Mohamed Soudy."), br(), 
        tags$div(
          tags$a(
            class = "logo", 
            href = "https://wwwen.uni.lu/", 
            tags$img(src = "https://gitlab.lcsb.uni.lu/mohamed.soudy/singular/-/raw/main/www/uni-centre-lcsb-FR-rgb.svg",
                     alt = "University of Luxembourg Logo", width = "20%")
          ) # a closing       
          ),br(),
        tags$div(
          tags$a(href = "/terms_conditions/", "Terms and conditions")
        )
      )
    )
  ),#footer closing
  ),#Dashboard body
  ),# Dashboard page
)#UI

server <- function(input, output, session) {
  ###########Interactome############
  #Update cell-cell communication (interactome)
  observe({
    updateSelectInput(session,
                      inputId = "study",
                      choices = unique(cell_cell_com_interactome$study),
                      selected = unique(cell_cell_com_interactome$study)[2])
  })
  observe({
    updateSelectInput(session,
                      inputId = "tissue",
                      choices = cell_cell_com_interactome$tissue[cell_cell_com_interactome$study == input$study],
                      selected = cell_cell_com_interactome$tissue[cell_cell_com_interactome$study == input$study][1])
  })
  
  observe({
    updateSliderInput(session,
                      inputId = "intercome_score",
                      value = mean(cell_cell_com_interactome$significance[cell_cell_com_interactome$tissue == input$tissue]),
                      min = min(cell_cell_com_interactome$significance[cell_cell_com_interactome$tissue == input$tissue]),
                      max = max(cell_cell_com_interactome$significance[cell_cell_com_interactome$tissue == input$tissue]))
  })
  
  Chord_DF <- reactive({
    req(input$study)
    req(input$tissue)
    req(input$intercome_score)
    Chord_DF <- cell_cell_com_interactome[cell_cell_com_interactome$study == input$study,]
    Chord_DF <- Chord_DF[Chord_DF$significance >= input$intercome_score,]
    Chord_DF
  })
  
  output$interactome_Chrod <- renderPlot({

      Visualize_chord_network(Chord_DF())


  })
  
  output$interactome_table <- DT::renderDataTable({
    DF <- Chord_DF()
    DF$Lig.exp.perc <- round(DF$Lig.exp.perc, 3)
    DF$Rec.exp.perc <- round(DF$Rec.exp.perc, 3)
    DF$significance <- round(DF$significance, 3)
    DF$score <- round(DF$score, 3)
    DF
    
  }, options = list(scrollX = T))
  ###########Interactome############
  ###########SighotSpotter##########
  observe({
    updateSelectInput(session,
                      inputId = "study_sighot",
                      choices = unique(cell_cell_com_sighotspotter_edges$study),
                      selected = unique(cell_cell_com_sighotspotter_edges$study)[1])
  })
  observe({
    updateSelectInput(session,
                      inputId = "tissue_sighot",
                      choices = cell_cell_com_sighotspotter_edges$tissue[cell_cell_com_sighotspotter_edges$study == input$study_sighot],
                      selected = cell_cell_com_sighotspotter_edges$tissue[cell_cell_com_sighotspotter_edges$study == input$study_sighot][1])
  })
  
  observe({
    updateSliderInput(session,
                      inputId = "sighot_score",
                      value = mean(cell_cell_com_sighotspotter_edges$weight[cell_cell_com_sighotspotter_edges$tissue == input$tissue_sighot]),
                      min = min(cell_cell_com_sighotspotter_edges$weight[cell_cell_com_sighotspotter_edges$tissue == input$tissue_sighot]),
                      max = max(cell_cell_com_sighotspotter_edges$weight[cell_cell_com_sighotspotter_edges$tissue == input$tissue_sighot]))
  })
  
  output$cell_type_sighot <- renderUI({
    selectInput("sighot_cell", "Cell", choices = unique(cell_cell_com_sighotspotter_edges$cell[cell_cell_com_sighotspotter_edges$tissue == input$tissue_sighot]),
                selected = unique(cell_cell_com_sighotspotter_edges$cell[cell_cell_com_sighotspotter_edges$tissue == input$tissue_sighot])[1])
  })
  
  SigHot_DF <- reactive({
    req(input$study_sighot)
    req(input$tissue_sighot)
    req(input$sighot_cell)
    req(input$sighot_score)
    
    node_edge <- prepare_sighotspotter_data(cell_cell_com_sighotspotter_nodes, cell_cell_com_sighotspotter_edges,
                               input$study_sighot, input$tissue_sighot, input$sighot_cell, input$sighot_score)
    
    node_edge[[1]] <- node_edge[[1]][!duplicated(node_edge[[1]]$id),]
    node_edge
  })
  
  output$sighot_network <- renderVisNetwork({
    
      plot_sighotspotter(SigHot_DF()[[1]], SigHot_DF()[[2]])
    
  })
  
  output$sighot_table <- DT::renderDataTable({
    SigHot_DF()[[2]]
  }, options = list(scrollX = T))
  ##################################
  ###############GRNS###################
  #Update GRN
  observe({
    updateSelectInput(session,
                      inputId = "study_grn",
                      choices = unique(grn_grni3$study),
                      selected = unique(grn_grni3$study)[1])
  })
  observe({
    updateSelectInput(session,
                      inputId = "tissue_grn",
                      choices = grn_grni3$tissue[grn_grni3$study == input$study_grn],
                      selected = grn_grni3$tissue[grn_grni3$study == input$study_grn][1])
  })
  
  output$cell_type_GRN <- renderUI({
    selectInput("GRN_cell", "Cell", choices = unique(grn_grni3$cell[grn_grni3$tissue == input$tissue_grn]),
                selected = unique(grn_grni3$cell[grn_grni3$tissue == input$tissue_grn])[1])
  })
  
  observe({
    updateSliderInput(session,
                      inputId = "score_grn",
                      value = mean(grn_grni3$Score[grn_grni3$tissue == input$tissue_grn]),
                      min = min(grn_grni3$Score[grn_grni3$tissue == input$tissue_grn]),
                      max = max(grn_grni3$Score[grn_grni3$tissue == input$tissue_grn]))
  })
  
  GRN_DF <- reactive({
    req(input$study_grn)
    req(input$tissue_grn)
    req(input$score_grn)
    req(input$GRN_cell)
    GRN_DF <- grn_grni3[grn_grni3$study == input$study_grn,]
    GRN_DF <- GRN_DF[GRN_DF$celltype == input$GRN_cell,]
    GRN_DF <- GRN_DF[GRN_DF$Score >= input$score_grn,]
    GRN_DF
  })
  
  output$grni3_grn <- renderVisNetwork({
      plot_grns(GRN_DF())

  })
  
  output$grn_table <- DT::renderDataTable({
    DF <- GRN_DF()
    DF$Score <- round(DF$Score, 3)
    DF
  }, options = list(scrollX = T))
  ###############GRNS###################
  
  #################GO##################
  observe({
    updateSelectInput(session,
                      inputId = "study_go",
                      choices = unique(gene_ontology$study),
                      selected = unique(gene_ontology$study)[1])
  })
  observe({
    updateSelectInput(session,
                      inputId = "tissue_go",
                      choices = unique(gene_ontology$organ[gene_ontology$study == input$study_go]),
                      selected = unique(gene_ontology$organ[gene_ontology$study == input$study_go])[1])
  })
  
  output$cell_type_go <- renderUI({
    selectInput("go_cell", "Cell", choices = unique(gene_ontology$cell[gene_ontology$organ == input$tissue_go]),
                                                    selected = unique(gene_ontology$cell[gene_ontology$organ == input$tissue_go])[1])
  })
  
  output$fdr_go <- renderUI({
    sliderInput("fdr_go_val", "FDR", min = min(gene_ontology$FDR[gene_ontology$study == input$study_go &
                                                               gene_ontology$cell == input$go_cell & 
                                                               gene_ontology$organ == input$tissue_go]),
                max = max(gene_ontology$FDR[gene_ontology$study == input$study_go &
                                              gene_ontology$cell == input$go_cell & 
                                              gene_ontology$organ == input$tissue_go]),
                value = mean(gene_ontology$FDR[gene_ontology$study == input$study_go &
                                                gene_ontology$cell == input$go_cell & 
                                                gene_ontology$organ == input$tissue_go]))

  })
  
  GO_DF <- reactive({
    req(input$study_go)
    req(input$tissue_go)
    req(input$go_cell)
    req(input$fdr_go_val)
    req(input$Top_N_go)
    GO_DF <- gene_ontology[gene_ontology$study == input$study_go,]
    GO_DF <- GO_DF[GO_DF$organ == input$tissue_go,]
    GO_DF <- GO_DF[GO_DF$cell == input$go_cell,]
    GO_DF <- GO_DF[GO_DF$FDR >= input$fdr_go_val,]
    GO_DF
  })
  
  output$go_plot <- renderPlot({
    if (nrow(GO_DF()) == 0){
      #shinyalert("Parameter Selection", "There is no data that meets the selected parameters!", type = "error")
      return()
    }
    #Subset the up-regulated and down-regulated pathways 
    Go_sign <- split(GO_DF(), with(GO_DF(), sign), drop = TRUE)
    if (length(Go_sign) > 1) #both up and down 
    {
      up_regulated <- na.omit(Go_sign[["upregulated"]][1:input$Top_N_go,])
      down_regulated <- na.omit(Go_sign[["downregulated"]][1:input$Top_N_go,])
      up_regulated_plot <- plot_go_pathway(up_regulated, "Up-Regulated")
      down_regulated_plot <- plot_go_pathway(down_regulated, "Down-Regulated")
      ggarrange(up_regulated_plot, down_regulated_plot, nrow = 1, ncol = 2, align = "hv")
    }else{
      Go_DF_data <- na.omit(Go_sign[[names(Go_sign)]][1:input$Top_N_go,])
      plot_go_pathway(Go_DF_data, names(Go_sign))
    }
  })
  
  output$go_table <- DT::renderDataTable({
    DF <- GO_DF()
    DF
  },options = list(scrollX = T),escape = FALSE)
  #####################################
  #########Pathways Enrichment#########
  
  
  observe({
    updateSelectInput(session,
                      inputId = "study_kegg",
                      choices = unique(pathway_kegg$study),
                      selected = unique(pathway_kegg$study)[1])
  })
  observe({
    updateSelectInput(session,
                      inputId = "tissue_kegg",
                      choices = pathway_kegg$organ[pathway_kegg$study == input$study_kegg],
                      selected = pathway_kegg$organ[pathway_kegg$study == input$study_kegg][1])
  })
  
  output$cell_type_kegg <- renderUI({
    selectInput("kegg_cell", "Cell", choices = unique(pathway_kegg$cell[pathway_kegg$organ == input$tissue_kegg]),
                selected = unique(pathway_kegg$cell[pathway_kegg$organ == input$tissue_kegg])[1])
  })
  
  output$fdr_kegg <- renderUI({
    sliderInput("fdr_kegg_val", "FDR", min = min(pathway_kegg$FDR[pathway_kegg$study == input$study_kegg &
                                                                   pathway_kegg$cell == input$kegg_cell & 
                                                                   pathway_kegg$organ == input$tissue_kegg]),
                max = max(pathway_kegg$FDR[pathway_kegg$study == input$study_kegg &
                                              pathway_kegg$cell == input$kegg_cell & 
                                              pathway_kegg$organ == input$tissue_kegg]),
                value = mean(pathway_kegg$FDR[pathway_kegg$study == input$study_kegg &
                                                 pathway_kegg$cell == input$kegg_cell & 
                                                 pathway_kegg$organ == input$tissue_kegg]))
  })
    
  Pathway_DF <- reactive({
    req(input$study_kegg)
    req(input$tissue_kegg)
    req(input$kegg_cell)
    req(input$fdr_kegg_val)
    req(input$Top_N_kegg)
    Pathway_DF <- pathway_kegg[pathway_kegg$study == input$study_kegg,]
    Pathway_DF <- Pathway_DF[Pathway_DF$organ == input$tissue_kegg,]
    Pathway_DF <- Pathway_DF[Pathway_DF$cell == input$kegg_cell,]
    Pathway_DF <- Pathway_DF[Pathway_DF$FDR >= input$fdr_kegg_val,]
    Pathway_DF <- na.omit(Pathway_DF[order(Pathway_DF$FDR, decreasing = F),][1:input$Top_N_kegg,])
    Pathway_DF
  })
  
  output$kegg_plot <- renderPlot({
    if (nrow(Pathway_DF()) == 0){
      #shinyalert("Parameter Selection", "There is no data that meets the selected parameters!", type = "error")
      return()
    }
    plot_go_pathway(Pathway_DF(), "")
  })
  
  output$kegg_table <- DT::renderDataTable({
    DF <- Pathway_DF()
    DF
  },options = list(scrollX = T),escape = FALSE)
  #####################################
}

shinyApp(ui = ui, server = server)

