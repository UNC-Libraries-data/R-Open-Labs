library(shiny)
library(tidyverse)
library(spData) # For getting spatial data
library(sf) # For preserving spatial data
library(leaflet) # For making maps
library(DT) # For making fancy tables

# Load review data
ratings <- read.csv("data/ramen-ratings.csv")

# Load map data
mapData <- world[c(2,11)]

# Clean review data
ratings <- filter(ratings, Stars != "Unrated")
ratings$Stars <- as.numeric(as.character(ratings$Stars))

# Clean country data
ratings$Country <- recode(ratings$Country, 
                          USA = "United States", 
                          `South Korea` = "Republic of Korea",
                          Singapore = "Malaysia",
                          `Hong Kong` = "China",
                          UK = "United Kingdom",
                          Sarawak = "Malaysia",
                          Holland = "Netherlands",
                          Dubai = "United Arab Emirates")

# Define UI for application
ui <- fluidPage(
  
  # CSS
  tags$head(
    tags$style(HTML("
      body { background-color: #f2efe9; }
      .container-fluid { background-color: #fff; width: 1100px; padding: 60px; }
      .topimg { width: 120px; display: block; margin: 0px auto 40px auto; }
      .title { text-align: center; }
      .toprow { margin: 60px 0px; padding: 30px; background-color: #fae8bb; }
      .filters { margin: 0px auto; }
      .shiny-input-container { width:100% !important; }
      .table { padding: 30px; margin-top: 30px; }
      .leaflet-top { z-index:999 !important; }
      "))
    ),
   
  # Top image
  img(class = "topimg", src = "https://i.ibb.co/1zSfPP2/ramen-3950790-640.png"),
  
   # Application title
   h1("Ramen Reviews", class = "title"),
   
   fluidRow(class = "toprow",
     fluidRow (class = "filters",
               
       column(6,
         # Style Menu
         selectInput("style", "Style", c("All",
                                         "Bowl",
                                         "Box",
                                         "Cup",
                                         "Pack",
                                         "Tray"))
       ),
       
       column(6,
         # Country menu
         selectInput("country", "Country", levels(ratings$Country) %>% 
                           append("All") %>% # Add "All" option
                           sort()) # Sort options alphabetically
         
       )
     )
   ),
   
   fluidRow (
     
     column(6, class = "bar",
       # Bar Chart
       plotOutput("brandBar")
     ),
     
     column(6, class = "map",
       # Map
       leafletOutput("map")
     )
     
   ),
  
   fluidRow (class = "table",
     # Table
     dataTableOutput("table")
   )
   
)

# Define server logic
server <- function(input, output) {

  # Create bar chart of brands
  output$brandBar <- renderPlot( {
    
    # Filter data based on selected Style
    if (input$style != "All") {
      ratings <- filter(ratings, Style == input$style)
    }
    
    # Filter data based on selected Country
    if (input$country != "All") {
      ratings <- filter(ratings, Country == input$country)
    }
    
    # Error message for when user has filtered out all data
    validate (
      need(nrow(ratings) > 0, "No reviews found. Please make another selection.")
    )
    
    # Get top 20 brands
    brands <- group_by(ratings, Brand) %>% 
      summarise(avgRating = mean(Stars)) %>% 
      arrange(desc(avgRating)) %>% 
      top_n(20)
    
    # Bar chart
    ggplot(brands, aes(reorder(Brand, avgRating))) +
      geom_bar(aes(weight = avgRating), fill = "tomato3") + 
      coord_flip() +
      ggtitle("Top 20 Ramen Brands") +
      xlab("Brand") +
      ylab("Avg. Rating") +
      theme_bw(base_size = 16)
    
  })
  
  # Create world map
  output$map <- renderLeaflet({
    
    # Filter data based on selected Style
    if (input$style != "All") {
      ratings <- filter(ratings, Style == input$style)
    }
    
    # Filter data based on selected Country
    if (input$country != "All") {
      ratings <- filter(ratings, Country == input$country)
    }
    
    # Hide map when user has filtered out all data
    validate (
      need(nrow(ratings) > 0, "")
    )
    
    # Get average rating by country
    countries <- group_by(ratings, Country) %>% 
      summarise(avgRating = mean(Stars))
    
    # Add spatial data to countries dataframe
    countries <- left_join(countries, mapData, c("Country" = "name_long"))

    # Create color palette for map
    pal <- colorNumeric(palette = "YlOrRd", domain = countries$avgRating)
    
    # Create label text for map
    map_labels <- paste("Ramen from",
                        countries$Country, 
                        "has an average rating of", 
                        round(countries$avgRating, 1))
    
    # Generate basemap
    map <- leaflet() %>%
      addTiles() %>% 
      setView(0, 0, 1)
    
    # Add polygons to map
    map %>% addPolygons(data = countries$geom,
                  fillColor = pal(countries$avgRating),
                  fillOpacity = .7,
                  color = "grey",
                  weight = 1,
                  label = map_labels,
                  labelOptions = labelOptions(textsize = "12px")) %>% 
      
      # Add legend to map
      addLegend(pal = pal, 
                values = countries$avgRating,
                position = "bottomleft")
    
  })
  
  # Create data table
  output$table <- renderDataTable({
    
    # Filter data based on selected Style
    if (input$style != "All") {
      ratings <- filter(ratings, Style == input$style)
    }
    
    # Filter data based on selected Country
    if (input$country != "All") {
      ratings <- filter(ratings, Country == input$country)
    }
    
    # Hide table when user has filtered out all data
    validate (
      need(nrow(ratings) > 0, "")
    )
    
    ratings[,2:6]
    
  })
   
}

# Run the application 
shinyApp(ui = ui, server = server)

