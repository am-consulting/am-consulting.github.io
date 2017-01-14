fun_dataTable <-
  function(obj,
           orderColumn = 0,
           orderDirection = 'desc',
           caption = '',
           title = '',
           leftcolumns = 1,
           dateFormat = '%Y-%m',
           menuLength = 10,
           needID = 0,
           filter = 'none') {
    cat(paste0('<h5>', title, '</h5>'))
    if(dateFormat != 0){
      obj[, 1] <- format(obj[, 1], dateFormat)
    }
    if(needID == 1){
      obj <- data.frame(ID = seq(1,nrow(obj)), obj, check.names = F, stringsAsFactors = F)
    }
    DT::datatable(
      obj,
      extensions = c("Buttons", "ColReorder" , "FixedColumns", "FixedHeader"),
      options = list(
        paging = T,
        autoWidth = F,
        info = T,
        lengthChange = T,
        ordering = T,
        searching = T,
        scrollX = T,
        lengthMenu = list(c(menuLength, -1), c(menuLength, 'All')),
        orderClasses = T,
        order = list(list(orderColumn, orderDirection)),
        search = list(regex = T, caseInsensitive = T),
        searchHighlight = T,
        dom = 'BRlfrtip',
        buttons = I('colvis'),
        colReorder = T,
        fixedHeader = T,
        fixedColumns = list(leftColumns = leftcolumns)
      ),
      rownames = F,
      class = 'display compact',
      escape = F,
      filter = filter,
      caption = caption
      # caption = htmltools::tags$caption(style = 'caption-side: bottom; text-align: center;','Table ',
      #                                   htmltools::em(caption))
    )
  }
