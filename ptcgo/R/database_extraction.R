.format_information <- function(txt_mat, db_path = "data-raw/db.sqlite"){
  db <- DBI::dbConnect(RSQLite::SQLite(), dbname = db_path)

  addition_mat <- sapply(1:nrow(txt_mat), function(x){
    id <- txt_mat[x, "id"]
    DBI::dbGetQuery(db, paste0("SELECT Type, X_right, Y_center FROM card",
                               " WHERE Card_ID == '", id, "'"))
  })

  DBI::dbDisconnect(db)

  txt_mat <- .list_to_dataframe(cbind(txt_mat, t(addition_mat)))

  vec <- c("num", "X_right", "Y_center")
  for(i in vec){
    txt_mat[,i] <- as.numeric(txt_mat[,i])
  }

  txt_mat
}

.list_to_dataframe <- function(txt_mat){
  txt_mat2 <- apply(txt_mat, 2, function(x){
    unlist(x)
  })

  as.data.frame(txt_mat2, stringsAsFactors = FALSE)
}
