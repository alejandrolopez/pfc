$(".users-list").find("#user_<%= @user.id %>").slideUp("slow");
$(".users-list").find("#user_<%= @user.id %>").remove();