useShinyjs()
#pageWithSidebar(
fluidPage(

    title="Escapement Explorer",
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
            
        #  selectInput('Region', 'Region', 
        #             sort(unique(escape$SASAP.Region))
        #             ),
        # htmlOutput("selectUISpecies"),
        # uiOutput("sliderYear"),
        # dateRangeInput('dateRange',
        #                label = 'Date range input: mm-dd',
        #                start = '2018-05-05', end = '2018-10-10',
        #                format = "M-dd"),
        # numericInput("scale", "Plot Overlay:", value=3, min=1, max=10, step=1),
        
        conditionalPanel(
          condition="input.tabselected==1",uiOutput("Region"), uiOutput("Species"), uiOutput("sliderYear"), uiOutput("dateRange"), 
              uiOutput('overLay')
        ),
        conditionalPanel(
          condition="input.tabselected==2", uiOutput("Species2"), uiOutput("dateRange2"), uiOutput("fix2")
        ),
        conditionalPanel(
          condition="input.tabselected==3", uiOutput("Region3"), uiOutput("dateRange3"), uiOutput("fix3")
        )
        
    ),
    mainPanel(
        # Output: Tabset w/ plot, summary, and table ----
        tabsetPanel(type = "tabs",
                    tabPanel("Escapement", value = 1,  plotOutput('plotByYear')),
                    tabPanel("By Regions", value = 2, plotOutput('plotSpeciesByRegion')),
                    tabPanel("By Species", value = 3, plotOutput('plotRegionBySpecie')),
                    tabPanel("Info", value = 4, HTML(
                             '<b>Data Origin</b>:<br> 
                            The data used in this application is Escapement_location_linked.csv 
                            from <a href="https://knb.ecoinformatics.org/#view/urn:uuid:4d121475-8094-4fd4-a7fe-d804a4ec94ac">KNB</a>.
                            This dataset can be cited as:<br><br>
                            - <i>Jeanette Clark</i> and <i>Rich Brenner</i> (2017) Compiled statewide Alaskan daily salmon 
                            escapement counts, 1922-2017. Knowledge Network for Biocomplexity. 
                            <u>urn:uuid:2965ebba-3867-41da-b8c1-e2cf6c59a861</i><br><br
                            NOTE: This file is not get open to the public, but it will be.<br>

                            <b>Data Procesing</b>:<br> 
                            The data is a daily average of all escapement counts 
                             with more than 10 years of data in the region.<br><br>
                             
                             <b>Plot description</b>:<br>
                             The plot shows day of the year in the <i>x</i> axis, and year for which the escapement count was done 
                            in the <i>y</i> axis. Each curve represents the relative escapement (mean across all the escapement
                            projects) for a particular day of the year. In other words, the curve
                             represent the progression of the escapement run across the entire region.<br><br>
                        
                             <b> Links to other shiny apps</b>:<br>
                             <ul>
                                <li><a href="https://cornejo.shinyapps.io/ASL_shiny/">Size Change Explorer</a></li>
                             </ul>  ')),
                    id = "tabselected"
                    )
            )
    )

    
