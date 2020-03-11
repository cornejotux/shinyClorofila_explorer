
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
        print(head(temp))
        temp2 <- temp %>% 
          group_by(estacion, Orden) %>% 
          summarise (n = n())
        
        print(temp2)
        # uno <- ggplot(temp, 
        #     aes(x=date, y=estacion, height=chl)) + 
        #  geom_joy(stat = "identity", rel_min_height = 0, scale=input$overlay, alpha=0.5, fill="dodgerblue3", col="dodgerblue3") +
        #   xlab("Fecha") + ylab("Estación") + geom_rangeframe() +theme_tufte() +
        #    theme(axis.text.x = element_text(angle = 45, hjust = 1, size=12), 
        #          axis.text.y = element_text(angle = 0, hjust = 1, size=12),
        #          text = element_text(size=15), title = element_text(size=15)) #+
        #   #ggtitle(paste(input$Species, "run"), subtitle = paste(input$Region)) 
        
        uno <- ggplot(temp, 
                      aes(x=date, y=as.factor(Orden), height=chl, label=estacion)) + 
          geom_density_ridges(stat = "identity", rel_min_height = 0, scale=input$overlay, alpha=0.5, fill="dodgerblue3", col="dodgerblue3") +
          xlab("Fecha") + ylab("Estación") + #geom_rangeframe() + 
          theme_tufte() +
          theme(axis.text.x = element_text(NULL), #angle = 45, hjust = 1, size=12), 
                #axis.text.y = element_text(angle = 0, hjust = 1, size=12),
                text = element_text(size=15), title = element_text(size=15),
                axis.text.y=element_blank(),axis.ticks=element_blank(), 
                axis.line.y = element_blank()
                ) +
          annotate("text", label = temp2$estacion, x=ISOdate(min(temp$Year), 1, 1), y = temp2$Orden, size = 3, colour = "red")
          #scale_y_discrete(labels = estacion)
        #ggtitle(paste(input$Species, "run"), subtitle = paste(input$Region)) 
        
        avg <- temp %>%
          group_by(MES, DIA) %>%
          dplyr::summarize(Mean = mean(chl, na.rm=TRUE), sd=sd(chl, na.rm=TRUE)) %>% 
          mutate(Year = ISOdate(2020, MES, DIA))
        
        dos <- ggplot(avg,
                      aes(x=Year, y=Mean)) +
              geom_point() + stat_smooth() + xlab("Día del año") + ylab("Chl-a Promedio (mg/m3??)")
        
        grid.arrange(grobs=list(uno, dos), nrow=2, heights=unit(c(7,2), c("in", "in")))
    },  height = 800, width = 700 )
    
    
})
    
