write_to_google_drive <- function(
  data_to_write, #data frame you want to write out
  write_filename = #filename e.g., 'my_out_data.csv',
  # look at filenames in target directory
  my_path_to_googledirve_directory, #path in google directory
  keep_file_in_working_dir = FALSE #set to true if you want to keep local file
  ){
  
  library(tidyverse)
  library(googledrive)
  
  # get list of files
  my_list_of_files <- googledrive::drive_ls(my_path_to_googledirve_directory)
  
  # make a new output filename
  # temp write local
  readr::write_csv(data_to_write, write_filename)
  
  # conditional depending on if we need to overwrite or create new
  if(!write_filename %in% my_list_of_files$name){
    drive_upload(write_filename,
                 path = my_path_to_googledirve_directory,
                 name = write_filename,
                 type = NULL,
                 verbose = TRUE)
    message(paste0('Created ',write_filename, ' in ', my_path_to_googledirve_directory))
  }else{
    google_id <- my_list_of_files %>% filter(name == write_filename) %>% select(id) %>% unlist()
    drive_update(file = as_id(google_id),
                 media = write_filename)
    message(paste0('Updated ',write_filename, ' in ', my_path_to_googledirve_directory))
  }
  
  #remove local file
  if(!keep_file_in_working_dir) file.remove(write_filename)
  
}
