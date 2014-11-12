#con <- url('http://biostat.jhsph.edu/~jleek/contact.html')
#html.code <- readLines(con)
#close(con)

print('Number of characters in each line:')
print(paste('10: ', as.character(nchar(html.code[10]))))
print(paste('20: ', as.character(nchar(html.code[20]))))
print(paste('30: ', as.character(nchar(html.code[30]))))
print(paste('100: ', as.character(nchar(html.code[100]))))
