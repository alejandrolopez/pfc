$.colorbox({width:"60%", height:"80%", html:"<p></p>"});
$("#cboxLoadedContent").html('\
    <h2>Listado de editoriales a añadir</h2>\n\
    <div>\n\
        <ul>\n\
            <% @publishers.each do |publisher| %>\n\
                <li>\n\
                    <%= link_to publisher.name, add_publisher_to_book_books_path(:publisher_id => publisher.id), :remote => true, :title => t("book.add_publisher_to_book"), :method => :post %>\n\
                </li>\n\
            <% end -%>\n\
        </ul>\n\
    </div>');