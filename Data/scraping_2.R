
library(tidyverse)  
library(rvest)    
library(stringr)   
library(lubridate)
library(tidyr)

url <-'https://www.etsy.com/fr/shop/LAGRACEWAX'



#>>Recuperation des lien vers toutes les pages
get_last_page <- function(html){
  pages_data <- html %>% 
    html_nodes('.wt-action-group__item') %>% 
    html_text()                   
  
  pages_data[(length(pages_data)-1)] %>%            
    unname() %>% 
    str_extract("[[:digit:]]+") %>%
    as.numeric()                                     
}

latest_page_number <- get_last_page(read_html(url))
urll <- 'https://www.etsy.com/fr/shop/LAGRACEWAX?ref=items-pagination&page='
list_of_pages <- str_c(urll,1:latest_page_number,'&sort_order=custom',sep='')



#>>Recuperation de tous les blocks dans chaque pages
get_block <- function(html){
  html %>% 
    html_nodes('.display-inline-block')%>% 
    html_attr("href") %>%
    na.omit()  %>%
    as.character()
}



#get all block image
get_block_img <- function(html){
  html %>% 
    html_nodes('.max-width-full')%>% 
    html_attr("data-src-zoom-image") %>%
    na.omit()  %>%
    as.character()
}

#get title
get_title<- function(html){
  html %>% 
    html_nodes('.listing-page-title-component')%>% 
    html_text()  %>% 
    str_trim() %>% 
    unlist()                  
}

#get price
get_price<- function(html){
  html %>% 
    html_nodes('.text-largest')%>% 
    html_text()  %>% 
    str_trim() %>% 
    unlist()                  
}

#get price
get_text<- function(html){
  all_text <- html %>% 
    html_nodes('.text-body ')%>% 
    html_text()  %>% 
    str_trim() %>% 
    unlist()
  n_vues <- all_text[2]
  type <- all_text[4]
  desc <- all_text[5]
  
  return(cbind(n_vues,type,desc))
}




all_data_page <- data.frame()
for(page in  1:latest_page_number){ 

  list_of_block <- get_block(read_html(list_of_pages[page]))
  all_data_block <- data.frame()
  
  for(b in list_of_block){
    block <- read_html(b)
    all_img_bloc <- get_block_img(block) 
    all_title_block <- get_title(block)
    all_price_block <- get_price(block)
    all_text_block <- get_text(block)
    all_text_text_block <- cbind.data.frame(all_title_block,all_price_block,all_text_block)
    all_data_block <- rbind.data.frame(all_data_block,cbind.data.frame(all_img_bloc,all_text_text_block))
  }
  all_data_page <- rbind.data.frame(all_data_page,all_data_block)
  
  library(writexl)
  write_xlsx(all_data_page, path =paste("C:\\Users\\aso\\Downloads\\WaxClassification_6_",page,".xlsx",sep=""))
  print(page)
}


