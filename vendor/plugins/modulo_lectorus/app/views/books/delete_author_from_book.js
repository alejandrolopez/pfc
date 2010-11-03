$("#book_authors").find("#author_<%= @author.id %>").slideUp("slow");
$("#book_authors").find("#author_<%= @author.id %>").remove();