$.colorbox.close();
<% unless @author.blank? %>
    $("#book_authors UL").append('<li id="author_<%= @author.id %>" author_id="<%= @author.id %>"><%= link_to @author.complete_name, delete_author_from_book_books_path(:author_id => @author.id), :title => t("book.delete_author_from_book"), :remote => true, :method => :delete %></li>');
<% end %>