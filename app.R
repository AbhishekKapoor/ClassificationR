library(shiny)
library(GPArotation)

shinyUI(fluidPage(theme = "bootstrap.css",titlePanel("SmartR-Classfication Tool"),
                  
                  sidebarPanel( 
                    helpText("Upload the .csv sheet the data has to be in same format as the sample file, downloadable below"),
                    a("Factor sheet", href="https://dl.dropboxusercontent.com/u/46021747/factor%20raw%20data.csv"),     
                    fileInput("dataset", "File data", multiple=TRUE),
                    radioButtons("Model", "Choose the Model ", # radioButtons - "Model" - select 
                                   list("Unrotated"="none",
                                     "Varimax (T)"="Varimax", 
                                     "Quartimax (Q)"="quartimax",
                                     "BentlerT"="bentlerT",
                                     "GeominT"="geominT",
                                     "Bifactor"="bifactor",
                                     "Promax"="promax",
                                     "Oblimin"="oblimin",
                                     "Simplimax"="simplimax",
                                     "BentlerQ"="bentlerQ",
                                     "GeominQ"="geominQ",
                                     "Biquartimin"="biquartimin")), #Close radioButtons 
                    br(),
                    radioButtons("fitting", "Choose the Fitting Method", # radioButtons - "rotation" - select rotation method
                                 list("Principal Components method"="principal",
                                      "maximum likelihood method"="ml",
                                      "Weighted least squares method"="wls", 
                                      "Generalized weighted least squares method"="gls",
                                      "Principle axis method"="pa",
                                      "Minimize the sample size weighted chi square"="minchi"
                                 )),
                    numericInput("n1", label="Column number1 to be not included in analysis:", value=0) # numericInput - "k" - number of retained factors
                    ,numericInput("n2", label="Column number2 to be not included in analysis:", value=0) # numericInput - "k" - number of retained factors
                    ,numericInput("n3", label="Column number3 to be not included in analysis:", value=0)
                    ,numericInput("n4", label="Column number4 to be not included in analysis:", value=0) # numericInput - "k" - number of retained factors
                    ,numericInput("n5", label="Column number5 to be not included in analysis:", value=0) # numericInput - "k" - number of retained factors
                    ,numericInput("n6", label="Column number6 to be not included in analysis:", value=0)
                    ,numericInput("n7", label="Column number7 to be not included in analysis:", value=0)
                    ,numericInput("n8", label="Column number8 to be not included in analysis:", value=0)
                    ,numericInput("n9", label="Column number9 to be not included in analysis:", value=0)
                    ,numericInput("n10", label="Column number10 to be not included in analysis:", value=0)
                    ,downloadButton("downloadData", 'Download loading'),
                    br(),
                    downloadButton("downloadData1", 'Download with Factor score'), 
                    br(),  
                    br(),
                    h6 ("Created, Powered & Copyrighted by Smart Mandate Analytical Solutions Pvt Ltd.")
                  ),
                  
                  mainPanel( # all of the output elements go in here 
                    {tabsetPanel(id="tabcur",
                                 tabPanel("Documentations", id="tabDocumentations",
                                          p("Exploratory Factor Analysis is a web application created with R and Shiny."),
                                          br(),
                                          a("It is created and maintained by Smart Mandate Analytical Solutions",href="http://smartmandate.in/"),
                                          br(),
                                          p("the user can upload their own datasets - format for uploading the dataset can be downloading from link factor sheet"),
                                          br(),
                                          p("the app uses the", 
                                            span("psych package", style = "color:red"), "by William Revelle")),
                                 tabPanel("Correlations", id="tabCorrelations", plotOutput("corrgramX", width="90%", height="800px")),
                                 tabPanel("NoofFactors", id="tabNoofFactors", 
                                          plotOutput("nf", width="100%",height="800px")),
                                 tabPanel("Summary", id="tabSummary", 
                                          verbatimTextOutput("summary1")),
                                 tabPanel("Components", id="tabComponents", 
                                          verbatimTextOutput("loadings")), 
                                 tabPanel("Factors", id="tabFactors", 
                                          plotOutput("corrgramF", width="90%", height="800px"), 
                                          selected="Documentations"
                                 ))}
                  )
))
