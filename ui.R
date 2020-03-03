useShinyjs()
#pageWithSidebar(
fluidPage(

    title="Chl-a Explorer",
    #theme = shinytheme("flatly"),
    headerPanel(
        HTML('<center><img src="Abate.jpg"/></center>')
            ),
    sidebarLayout(
        sidebarPanel(
            HTML('
                <img src="Logo_Ifop.jpg" scale width="170" height="50"/>
                '),
                
    
            conditionalPanel(
              condition="input.tabselected==1",uiOutput("Region"), uiOutput("Species"), uiOutput("sliderYear"), uiOutput("dateRange"), 
                  uiOutput('overLay')
            )
            
        ),
    
        mainPanel(
            # Output: Tabset w/ plot, summary, and table ----
            tabsetPanel(type = "tabs",
                    tabPanel("Chl-a por estaciones", value = 1,  plotOutput('plotByYear')),
                    tabPanel("Información general", value = 4, HTML(
                             '<b>Data</b>:<br> 
                            Datos de .....
            ')), id = "tabselected")
            )
        ),
    # Footer
    hr(),

    HTML("Creado por <a href='http://www.jorgecornejo.net' target=_new>Jorge Cornejo</a> <br>
         (jorge.cornejo@ifop.cl). V1.0 2020/03")
        
    )

    
