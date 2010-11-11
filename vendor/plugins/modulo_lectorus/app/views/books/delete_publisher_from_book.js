$("#book_publishers").find("#publisher_<%= @publisher.id %>").slideUp("slow");
$("#book_publishers").find("#publisher_<%= @publisher.id %>").remove();