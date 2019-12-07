library(tidyverse)  
library(rvest)    
library(stringr)   
library(lubridate)
library(tidyr)

#>>Recuperation des lien vers toutes les pages
get_last_page <- function(html){
  html %>% 
    html_nodes('.pages a') %>%  
    html_attr("href")           
}

url_0 <-read_html('https://www.ebay.fr/sch/i.html?_sacat=0&_nkw=coupon+tissu+wax&rt=nc')
url_6 <-read_html('https://www.ebay.fr/sch/i.html?_sacat=0&_nkw=coupon+tissu+wax&_pgn=6&_skc=250&rt=nc')
list_of_pages <- as.character(c(get_last_page(url_0),url_6,get_last_page(url_6)))

#>>Recuperation de tous les blocks dans chaque pages
get_block <- function(html){
  html %>% 
    html_nodes('.lvpic > .lvpicinner a')%>% 
    html_attr("href") %>%
    na.omit()%>%
    as.character()
}


#get all block image
get_block_img <- function(html){
  only_img <- html %>% 
    html_nodes('#mainImgHldr img#icImg')%>% 
    html_attr("src")
  
  multi_img <- html %>% 
    html_nodes('#mainImgHldr ul li img')%>% 
    html_attr("src")
  
  return(as.character(c(only_img,multi_img)))
}

#get title
get_title<- function(html){
  html %>% 
    html_nodes('.it-ttl')%>% 
    html_text() %>% 
    str_trim() %>% 
    unlist() 
}


#get price
get_price<- function(html){
  all_price <- html %>% 
    html_nodes('#vi-mskumap-none span')%>% 
    html_text() %>%            
    as.character() 
  return(all_price[1])            
}



all_data_page <- data.frame()
for(page in  1:length(list_of_pages)){ 
  
  list_of_block <- get_block(read_html(list_of_pages[page]))
  all_data_block <- data.frame()
  
  for(b in list_of_block){
    block <- read_html(b)
    all_img_bloc <- get_block_img(block) 
    all_title_block <- get_title(block)
    all_price_block <- get_price(block)
    all_text_text_block <- cbind.data.frame(all_title_block,all_price_block)
    all_data_block <- rbind.data.frame(all_data_block,cbind.data.frame(all_img_bloc,all_text_text_block))
  }
  all_data_page <- rbind.data.frame(all_data_page,all_data_block)
  
  library(writexl)
  write_xlsx(all_data_page, path =paste("C:\\Users\\Soubeiga Armel\\Downloads\\urls-4\\WaxClassification_10_",page,".xlsx",sep=""))
  print(page)
}


