rm(list=ls(all=TRUE))

library (shiny)
library(ggplot2) # load ggplot
library (randomForest)
library ("caret")
library(e1071)
library ("kernlab")
library(xgboost)
library(methods)


shinyServer(function(input, output) {

  data<- reactive({
    
    inFile <- input$Train
    inFile1 <- input$Test
    if (is.null(inFile))
      return(NULL)
    if (is.null(inFile1))
      return(NULL)
    df.train <- read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote)
    df.test <- read.csv(inFile1$datapath, header=input$header, sep=input$sep, quote=input$quote)
    Complete_data <- list(train=df.train,test=df.test)
    return(Complete_data)
    
  })
    
  
  # Rotation
  rotationInput <- reactive({
    switch(EXPR=input$rotation,
           none="none",
           Varimax="Varimax", # 1958
           quartimax= "quartimax",
           bentlerT= "bentlerT",
           geominT="geominT",
           bifactor="bifactor",
           promax="promax",
           oblimin="oblimin",
           simplimax="simplimax",
           bentlerQ="bentlerQ",
           geominQ="geominQ",
           biquartimin="biquartimin"
    )    
  }) # rotationInput
  
  # Fitting
  fittingInput <- reactive({
    switch(EXPR=input$fitting,
           principal="principal",
           ml="ml",
           wls="wls", # 1958
           gls= "gls",
           pa= "pa",
           minchi="minchi"
    )    
  }) # fittingInput
  
  
  #  correlelogram for observed variables
  output$corrgramX <- renderPlot({
    #     oldPar <- par(pty="m") #Set parameters for base graphics
    #     corrgram(datasetInput(),
    #              upper.panel=panel.conf, 
    #              lower.panel=panel.pie, #panel.pie, 
    #              type="cor", order=TRUE)
    #     par(oldPar) #Reset to the pre-existing graphic parameters
    #     corrplot(datasetInput(), order = "AOE", cl.pos = "b", tl.pos = "d")
    #corrplot.mixed(datasetInput(), lower = "pie", upper = "number")
    #corrplot.mixed(datasetInput(), lower = "pie", upper = "number", addgrid.col="gray19")
    m<- cor(data(input$dataset))
    col1 <- colorRampPalette(c("#7F0000","red","#FF7F00","yellow","white", 
                               "cyan", "#007FFF", "blue","#00007F"))
    corrplot(m, col=col1(20), cl.length=21,order = "AOE", addCoef.col="grey",title="Correlation Among Variables",line=-2)
  }) 
  
  
  factor.final <- function (df){
    fitting<- input$fitting
    nf<- input$k
    rotation<- input$rotation
    
    if (fitting == "principal")  {
      fa_psych = principal(df,nfactors = nf, rotate=rotation, impute="median",missing=TRUE)    
    }
    else {
      fa_psych = fa(df,nfactors = nf, rotate=rotation, fm=fitting,impute="median",missing=TRUE)
    }
    return (fa_psych)
  }
  
  output$nf <- renderPlot({
    
    data1<-data(input$dataset)
    
    nf<- numberoffactors(data1)
  })
  
  
  output$summary1 <- renderPrint({
    
    fa_psych<- factor.final(data(input$dataset))
    
    return (fa_psych)
  })
  
  
  
  output$loadings <- renderPrint({
    
    fa_psych<- factor.final(data(input$dataset))
    fa_psych1<- fa.sort(fa_psych)
    return (fa_psych1$loading)
  })
  
  
  output$downloadData <- downloadHandler(
    filename = function() { paste("loading", '.csv', sep='')  },
    content = function(file) {
      fa_psych<- factor.final(data(input$dataset))
      fa_psych1<- fa.sort(fa_psych)
      loadings <- as.data.frame(unclass(fa_psych1$loadings))
      write.csv(loadings , file)
      
      
    })
  
  output$downloadData1 <- downloadHandler(
    filename = function() { paste("withfactorscore", '.csv', sep='')  },
    content = function(file) {
      fa_psych<- factor.final(data(input$dataset))
      df<-data(input$dataset)
      data<- cbind (df,fa_psych$scores)##to
      write.csv(data , file)
      
    })
  
  output$corrgramF <- renderPlot({
    fa_psych<- factor.final(data(input$dataset))
    data1<- fa_psych$scores
    m1<- cor(data1)
    col1 <- colorRampPalette(c("#7F0000","red","#FF7F00","yellow","white", 
                               "cyan", "#007FFF", "blue","#00007F"))
    corrplot(m1, col=col1(20), cl.length=21,order = "AOE", addCoef.col="grey",title="Correlation Among Factors",line=-1)
  }) 
  
  
})


