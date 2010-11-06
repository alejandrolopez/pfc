$("#form_comment_book_<%= @book.id %>").find("TEXTAREA").removeClass("error");
$("#form_comment_book_<%= @book.id %>").find("TEXTAREA").attr("value", "");
$("#form_comment_book_<%= @book.id %>").hide();
$("#comments_book_<%= @book.id %>").append("<div><span class=\"autor\"><%= @comment.author  %></span><span class=\"comentario\"><%= @comment.comment %></span></div>");