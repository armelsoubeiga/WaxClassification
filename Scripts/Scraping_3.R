library(tidyverse)  
library(rvest)    
library(stringr)   
library(lubridate)
library(tidyr)

#>>Recuperation des lien vers toutes les pages
url <- 'https://www.afrikrea.com'
urll <- '/fr/categories/fabrics-supplies?categories%5B%5D=ankara-wax-prints&categories%5B%5D=fabrics&page='
list_of_pages <- str_c(url,urll,1:64,sep='')



#>>Recuperation de tous les blocks dans chaque pages
get_block <- function(html){
  html %>% 
    html_nodes('.card')%>% 
    html_attr("data-url") %>%
    na.omit()%>%
    as.character()
}


#get all block image
get_block_img <- function(html){
  html %>% 
    html_nodes('#product-details-images ul li a')%>% 
    html_attr("href")
}

#get title
get_title<- function(html){
  h1 <- html %>% 
    html_nodes('#product-details-info div div h2')%>% 
    html_text() %>% 
    str_trim() %>% 
    unlist() 
  h2 <-   html %>% 
    html_nodes('#product-details-info div div h1')%>% 
    html_text() %>% 
    str_trim() %>% 
    unlist()  
  return(paste(h1,',',h2))
}


#get price
get_price<- function(html){
  html %>% 
    html_nodes('.product-price-block > .as-h4')%>% 
    html_text()  %>% 
    str_trim() %>% 
    unlist()                  
}

#get price
get_vues<- function(html){
  all_vue <- html %>% 
    html_nodes('.panel-title')%>% 
    html_text()  %>%            
    str_extract("[[:digit:]]+") %>%
    as.numeric() 
    return(paste(all_vue[1],'likes'))
}



get_text<- function(html){
  html %>% 
    html_nodes('#product-description-body')%>% 
    html_text()  %>% 
    str_trim() %>% 
    unlist()                  
}


all_data_page <- data.frame()
for(page in  13:64){ 
  
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
  write_xlsx(all_data_page, path =paste("C:\\Users\\Soubeiga Armel\\Downloads\\urls\\WaxClassification_6_",page,".xlsx",sep=""))
  print(page)
}
