library(shiny)

shinyUI(fluidPage(theme = "bootstrap.css",titlePanel("SmartR-Classfication Tool"),
                  
                  sidebarPanel( 
                    helpText("Upload the .csv sheet the data has to be in same format as the sample file, downloadable below"),
                    a("Factor sheet", href="https://dl.dropboxusercontent.com/u/46021747/factor%20raw%20data.csv"),     
                    fileInput("Train", "Train File data", multiple=TRUE),
                    fileInput("Test", "Test File data", multiple=TRUE),
                    br(),
                    
                    selectInput("Model", label ="Choose the Model ",                                                                      choices = list("Random Forest",
                                      "GBM", "Neural Network","SVM","LDA","Multinomial Logistic"),selected = "Random Forest"), #Close radioButtons 
                    br(),
                    
                    downloadButton("downloadData", 'Download Test data'),
                    br(),
                     
                    br(),
                    h6 ("Created, Powered & Copyrighted by Juxt - Smart Mandate Analytical Solutions Pvt Ltd.")
                  ),
                  
                  mainPanel( # all of the output elements go in here 
                    {tabsetPanel(id="tabcur",
                                 tabPanel("Documentations", id="tabDocumentations",
                                          p("Classification web app where user upload the data and can run different models"),
                                          br(),
                                          a("It is created and maintained by Smart Mandate Analytical Solutions",href="http://juxt-smartmandate.in/"),
                                          br(),
                                          p("the user can upload their own datasets - format for uploading the dataset can be downloading from link factor sheet"),
                                          br(),
                                          p("the app uses the", 
                                            span("psych package", style = "color:red"), "by William Revelle")),
                                 tabPanel("Summary", id="tabSummary", verbatimTextOutput("Summary"),
                                 tabPanel("NoofFactors", id="tabNoofFactors", 
                                          plotOutput("nf", width="100%",height="800px")),
                                 tabPanel("Components", id="tabComponents", 
                                          verbatimTextOutput("loadings")), 
                                 tabPanel("Factors", id="tabFactors", 
                                          plotOutput("corrgramF", width="90%", height="800px"), 
                                          selected="Documentations"
                                 ))}
                  )
))
