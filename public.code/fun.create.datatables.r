fun.write.table <- function(append = F){
  output.table <-
    paste0('write.table(x = txt,file = html.file,append = ',append,
           ',fileEncoding = \'utf8\',col.names = F,row.names = F,quote = F)')
  return(output.table)
}

fun.create.datatables <- function(obj,title,file.name,data.source){
  html.file <- paste0(file.name,'.html')
  txt <- '<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>\n<link href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css" rel="stylesheet">\n<script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>\n<script>$(document).ready(function(){$(\'#table\').DataTable();});</script>\n\n\n'
  eval(parse(text = fun.write.table(append = F)))
  txt <-
    paste0('<div align="left">Date and time of creation or update:',Sys.time(),'</div>')
  eval(parse(text = fun.write.table(append = T)))
  txt <- paste0('<div align="center"><h1>',title,'</h1></div>')
  eval(parse(text = fun.write.table(append = T)))
  txt <- paste0('<div align="right"><h4>Source:',data.source,'</h4></div>')
  eval(parse(text = fun.write.table(append = T)))
  txt <- html.table
  eval(parse(text = fun.write.table(append = T)))
}
