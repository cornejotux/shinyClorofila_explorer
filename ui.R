useShinyjs()
#pageWithSidebar(
fluidPage(

    title="Chl-a Explorer",
    #theme = shinytheme("flatly"),
    headerPanel(
        HTML('<center><img src="header.png" scale width="800" height="100"/></center>')
            ),
    sidebarPanel(
        HTML('
            <table style="width:160%">
                <tr>
                    <td style="width: 50%"><left><img src="NCEAS.jpg" scale width="170" height="50"/></left></td>
                    <td style="width: 50%"><right><img src="SASAP.jpg" scale width="50" height="50"/></right></td>
                </tr>
            </table>
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
 ')),
                    id = "tabselected"
                    )
            )
    )

    
