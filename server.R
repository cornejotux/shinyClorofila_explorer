sp <- c("chinook", "chum", "coho", "pink", "sockeye")
tab <- 0



library(shiny)
shinyServer(function(input, output, session) {

    observeEvent(input$tabselected, {

      if (input$tabselected == 1)
      {
        Region <- Species <- dateRange <- NULL
        if (tab == 0)
        {
          Species <- "sockeye"
          Region <- "Ak. Peninsula and Aleutian Is."
          dateRange <- c("2018-05-01", "2018-11-01")
        } else if (tab == 1)
        {
          Species <- input$Species
          Region <- input$Region
          dateRange <- input$dateRange
        } else if (tab == 2)
        {
          Species <- input$Species2
          dateRange <- input$dateRange2
          Region <- R
          
        } else if (tab == 3)
        {
          Region <- input$Region3
          dateRange <- input$dateRange3
          Species <- S
        }
      
          output$Region <- renderUI({
            selectInput('Region', 'Region', sort(unique(escape$SASAP.Region)), selected = Region)
          })
          searchResult2 <- reactive({
            sort(unique(filter(escape, SASAP.Region == input$Region)$Species ))
          })
          output$Species <- renderUI({
            req(input$Region)
            selectInput("Species", "Species", searchResult2(), selected = Species)
          })
          minmax <- reactive({
            selectYears(filter(escape, SASAP.Region == input$Region, Species == Species))
          })
            output$sliderYear <- renderUI({
              req(input$Species)
              minmax <- minmax()
              sliderInput("sliderYear", "Year range:",
                          min = minmax[1], max = minmax[2],
                          value = c(minmax[1], minmax[2]),
                          step=1, sep = '')
          })
          
          output$dateRange <- renderUI({
            dateRangeInput('dateRange',
                         label = 'Date range input: mm-dd',
                         start = dateRange[1], end = dateRange[2],
                         format = "M-dd")
          })
          
          output$overLay <- renderUI({
            numericInput("overlay", "Plot Overlay:", value=3, min=1, max=10, step=1)
          })
        tab <<- 1
        }
    })
    
    
    observeEvent(input$tabselected, {
      if (input$tabselected == 2)
      {
        Region <- Species <- dateRange <- NULL
        if (tab == 1)
        {
          Species <- input$Species
          R <<- input$Region
          dateRange <- input$dateRange
        }  
        else if (tab == 3)
        {
          R <<- input$Region3
          Species <- S
          dateRange <- input$dateRange3
        }

          output$Region2 <- renderUI({
            selectInput('Region2', 'Region', sort(unique(escape$SASAP.Region)), selected = Region)
          })

        
        output$Species2 <- renderUI({
          req(Species)
          selectInput("Species2", "Species", sp, selected = Species)
        })
        
        output$fix2 <- renderUI({
            req(Species)
            checkboxInput("fix2", "Make Y axis comparable", FALSE)
        })


        output$dateRange2 <- renderUI({
          dateRangeInput('dateRange2',
                         label = 'Date range input: mm-dd',
                         start = dateRange[1],  end = dateRange[2],
                         format = "M-dd")
        })

      tab <<- 2
      }
    })
    
    observeEvent(input$tabselected, {
      if (input$tabselected == 3)
      {
        if (tab == 1)
        {
          S <<- input$Species
          Region <- input$Region
          dateRange <- input$dateRange
        } else if (tab == 2)
        {
          S <<- input$Species2
          dateRange <- input$dateRange2
          Region <- R
        }
        output$Region3 <- renderUI({
          selectInput('Region3', 'Region', sort(unique(escape$SASAP.Region)), selected = Region)
        })
        
        output$fix3 <- renderUI({
            checkboxInput("fix3", "Make Y axis comparable", FALSE)
        })
        
        output$dateRange3 <- renderUI({
          dateRangeInput('dateRange3',
                         label = 'Date range input: mm-dd',
                         start = dateRange[1], end = dateRange[2],
                         format = "M-dd")
          
        })

        tab <<- 3
      }
    })
    
    output$plotByYear <- renderPlot({
        req(input$sliderYear)
        temp <- filter(escape, SASAP.Region == input$Region, Species == input$Species, sampleYear >= input$sliderYear[1], 
                       sampleYear <= input$sliderYear[2])
        ggplot(temp, 
               aes(x=md, y=sampleYear, height=meanEscape, group=sampleYear)) + 
            geom_joy(stat = "identity", rel_min_height = 0, scale=input$overlay, alpha=0.5, fill="dodgerblue3", col="dodgerblue3") +
            scale_x_date(breaks = date_breaks("2 weeks"), labels = date_format("%d-%b"), 
                         limits = c(as.Date(yday(input$dateRange[1]), format = "%j", origin = "1.1.2018"), 
                                    as.Date(yday(input$dateRange[2]), format = "%j", origin = "1.1.2018"))) +
            #geom_rangeframe() + 
            #theme_tufte() +
            #theme_hc() + 
            theme_joy() +
            theme(axis.text.x = element_text(angle = 45, hjust = 1, size=12), 
                  axis.text.y = element_text(angle = 0, hjust = 1, size=12),
                  text = element_text(size=15), title = element_text(size=15)) +
            xlab("Day of the Year") + ylab("Return Year") + 
            ggtitle(paste(input$Species, "run"), subtitle = paste(input$Region)) 
               
    },  height = 700, width = 600 )
    
    output$plotSpeciesByRegion <- renderPlot({
        req(input$Species2)
        temp <- filter(escape, Species == input$Species2)
        scale <- 'free_y'
        if (input$fix2) {scale <- 'fix'}
        temp2 <- summarise(group_by(temp, Species, SASAP.Region, md), meanEscape = sum(meanEscape, na.rm=T))
        ggplot(temp2, aes(x=md, y=meanEscape)) + geom_point(size=0.5, col="blue") + geom_line(col="light blue") + 
            geom_smooth(span=0.1, col = "red", fill="orange") +
            scale_x_date(breaks = date_breaks("month"), labels = date_format("%d-%b"), 
                         limits = c(as.Date(yday(input$dateRange2[1]), format = "%j", origin = "1.1.2018"), 
                                    as.Date(yday(input$dateRange2[2]), format = "%j", origin = "1.1.2018"))) +
            #geom_rangeframe() + 
            #theme_tufte() +
            #theme_hc() + 
            theme_joy() +
            theme(axis.text.x = element_text(angle = 45, hjust = 1, size=12), 
                  #axis.text.y = element_text(angle = 0, hjust = 1, size=12),
                  axis.text.y = element_blank(),
                  text = element_text(size=15), title = element_text(size=15)) +
            xlab("Day of the Year") + ylab("Relative Return") + facet_wrap(~SASAP.Region, scale=scale, ncol = 2)
        
    },  height = 700, width = 600 )
    

    output$plotRegionBySpecie <- renderPlot({
        req(input$Region3)
        scale <- 'free_y'
        if (input$fix3) {scale <- "fix"}
        temp <- filter(escape, SASAP.Region == input$Region3)
        temp2 <- summarise(group_by(temp, Species, SASAP.Region, md), meanEscape = sum(meanEscape, na.rm=T))
        ggplot(temp2, aes(x=md, y=meanEscape)) + geom_point(size=0.5, col="blue") + geom_line(col="light blue") + 
            geom_smooth(span=0.1, col = "red", fill="orange") +
            scale_x_date(breaks = date_breaks("month"), labels = date_format("%d-%b"), 
                         limits = c(as.Date(yday(input$dateRange3[1]), format = "%j", origin = "1.1.2018"), 
                                    as.Date(yday(input$dateRange3[2]), format = "%j", origin = "1.1.2018"))) +
            #geom_rangeframe() + 
            #theme_tufte() +
            #theme_hc() + 
            theme_joy() +
            theme(axis.text.x = element_text(angle = 45, hjust = 1, size=12), 
                  #axis.text.y = element_text(angle = 0, hjust = 1, size=12),
                  axis.text.y = element_blank(),
                  text = element_text(size=15), title = element_text(size=15)) +
            xlab("Day of the Year") + ylab("Relative Return") + facet_wrap(~Species, scale=scale, ncol=2)
        
    },  height = 700, width = 600 )
   
})
