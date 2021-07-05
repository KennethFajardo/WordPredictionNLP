library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    title = "NLP Word Prediction",
    tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Yusei+Magic&display=swap');
       .container-fluid{
            margin-top: 150px;
       }
       h1{
            width: 35%;
            color: #555;
            border-bottom: 2px solid #777; 
       }
       h3{
            color: #999;
            margin-top: -5px;   
       }
       #text1{
            border-color: rgba(17, 119, 187, 0.4);
            text-align: center;
       }
       #time{
            margin-top: 20px;
       }
       @media only screen and (max-width: 1000px){
           h1{
                width: 70%;
           }
       }
    ")),
    fluidRow(
        column(12, align="center",
               # Application title
               titlePanel(
                   h1("DATA SCIENCE CAPSTONE"),
               ),
               h3("Word Prediction with NLP")
           )
    ),
    br(),br(),
    fluidRow(
        column(12, align="center",
               textInput("text1", label=NULL, placeholder = "Enter any text", width="600px")    
        )
    ),
    fluidRow(
        column(12, align="center",
               uiOutput("uio1"),
               uiOutput("uio2"),
               uiOutput("uio3")
        )
    ),
    fluidRow(
        column(12, align="center",
               textOutput("time")   
        )
    )
))
