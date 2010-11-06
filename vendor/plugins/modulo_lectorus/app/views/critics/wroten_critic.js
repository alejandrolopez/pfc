$("#form_write_your_critic_book_<%= @book.id %>").find("TEXTAREA").removeClass("error");
$("#form_write_your_critic_book_<%= @book.id %>").find("#critic_title").attr("value", "");
$("#form_write_your_critic_book_<%= @book.id %>").find("TEXTAREA").attr("value", "");
$("#form_write_your_critic_book_<%= @book.id %>").hide();