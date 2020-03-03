
shinyServer(function(input, output, session) {

    observeEvent(input$tabselected, {

      if (input$tabselected == 1)
      {

          minmax <- reactive({
            selectYears(filter(escape, SASAP.Region == input$Region, Species == Species))
          })
            output$sliderYear <- renderUI({
              #req(input$Species)
              minmax <- minmax()
              sliderInput("sliderYear", "Rango de años:",
                          min = minmax[1], max = minmax[2],
                          value = c(minmax[1], minmax[2]),
                          step=1, sep = '')
          })
          
          output$overLay <- renderUI({
            numericInput("overlay", "Sobreposición:", value=3, min=1, max=10, step=1)
          })
        tab <<- 1
        }
    })
    
    
    output$plotByYear <- renderPlot({
        req(input$sliderYear)
        temp <- filter(chlorofila, Year >= input$sliderYear[1], Year <= input$sliderYear[2])
        # ggplot(temp, 
            #    aes(x=md, y=sampleYear, height=meanEscape, group=sampleYear)) + 
            # geom_joy(stat = "identity", rel_min_height = 0, scale=input$overlay, alpha=0.5, fill="dodgerblue3", col="dodgerblue3") +
            # scale_x_date(breaks = date_breaks("2 weeks"), labels = date_format("%d-%b"), 
            #              limits = c(as.Date(yday(input$dateRange[1]), format = "%j", origin = "1.1.2018"), 
            #                         as.Date(yday(input$dateRange[2]), format = "%j", origin = "1.1.2018"))) +
            # #geom_rangeframe() + 
            # #theme_tufte() +
            # #theme_hc() + 
            # theme_joy() +
            # theme(axis.text.x = element_text(angle = 45, hjust = 1, size=12), 
            #       axis.text.y = element_text(angle = 0, hjust = 1, size=12),
            #       text = element_text(size=15), title = element_text(size=15)) +
            # xlab("Day of the Year") + ylab("Return Year") + 
            # ggtitle(paste(input$Species, "run"), subtitle = paste(input$Region)) 
            
        ggplot(temp, 
            aes(x=date, y=estacion, height=chl)) + 
         geom_joy(stat = "identity", rel_min_height = 0, scale=input$overlay, alpha=0.5, fill="dodgerblue3", col="dodgerblue3")
        
        
        
               
    },  height = 700, width = 600 )
    
 
   
})
