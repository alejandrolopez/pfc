$.colorbox({width:"60%", height:"80%", html:"<p></p>"});
$("#cboxLoadedContent").html('\
    <h2>Listado de autores a añadir</h2>\n\
    <div>\n\
        <ul>\n\
            <% @authors.each do |author| %>\n\
                <li>\n\
                    <%= link_to author.complete_name, add_author_to_book_books_path(:author_id => author.id), :remote => true, :title => t("book.add_author_to_book"), :method => :post %>\n\
                </li>\n\
            <% end -%>\n\
        </ul>\n\
    </div>');