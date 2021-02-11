library(tidyverse)  
library(rvest)    
library(stringr)   
library(lubridate)
library(tidyr)

#>>Recuperation des lien vers toutes les pages
url <- 'https://www.ungrandmarche.fr/merceries/c/tissus/fantaisie/africains-wax/858?page='
list_of_pages <- str_c(url,1:6,sep='')



#>>Recuperation de tous les blocks dans chaque pages
get_block <- function(html){
  html %>% 
    html_nodes('.product_img')%>% 
    html_attr("href") %>%
    na.omit()%>%
    as.character()
}


#get all block image
get_block_img <- function(html){
  html %>% 
    html_nodes('.product_list > .col-lg-2 img')%>% 
    html_attr("data-src")
}

#get title
get_title<- function(html){
html %>% 
    html_nodes('.col-lg-12 h1')%>% 
    html_text() %>% 
    str_trim() %>% 
    unlist() 
}


#get price
get_price<- function(html){
  all_price <- html %>% 
    html_nodes('.product_price span')%>% 
    html_text() %>%            
    str_extract("[[:digit:]]+") %>%
    as.numeric() 
  return(paste(all_price[1],"€"))            
}


#get price
get_vues<- function(html){
  all_vue <- html %>% 
    html_nodes('#tproduct_rates strong')%>% 
    html_text()  
  return(paste(all_vue[1],'Notes'))
}



get_text<- function(html){
  html %>% 
    html_nodes('#tproduct_description > .mce')%>% 
    html_text()  %>% 
    str_trim() %>% 
    unlist()                  
}


all_data_page <- data.frame()
for(page in  1:6){ 
  
  list_of_block <- get_block(read_html(list_of_pages[page]))
  all_data_block <- data.frame()
  
  for(b in list_of_block){
    block <- read_html(b)
    all_img_bloc <- get_block_img(block) 
    all_title_block <- get_title(block)
    all_price_block <- get_price(block)
    all_vue_block <- get_vues(block)
    all_text_block <- get_text(block)
    all_text_text_block <- cbind.data.frame(all_title_block,all_price_block,all_vue_block,all_text_block)
    all_data_block <- rbind.data.frame(all_data_block,cbind.data.frame(all_img_bloc,all_text_text_block))
  }
  all_data_page <- rbind.data.frame(all_data_page,all_data_block)
  
  library(writexl)
  write_xlsx(all_data_page, path =paste("C:\\Users\\Soubeiga Armel\\Downloads\\urls-3\\WaxClassification_9_",page,".xlsx",sep=""))
  print(page)
}
