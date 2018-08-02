function [ answer ] = is_word_in_the_sheet( excel_sheet, word )

if any(strcmp( excel_sheet(:) , word)) == 1
    answer = true;
else 
    answer = false;
end

end

