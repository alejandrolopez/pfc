$.colorbox.close();
<% unless @publisher.blank? %>
    $("#book_publishers UL").append('<li id="publisher_<%= @publisher.id %>" publisher_id="<%= @publisher.id %>"><%= link_to @publisher.name, delete_publisher_from_book_books_path(:publisher_id => @publisher.id), :title => t("book.delete_publisher_from_book"), :remote => true, :method => :delete %></li>');
<% end %>