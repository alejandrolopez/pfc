$.colorbox.close();
<% unless @user.blank? %>
    $(".users-list").append('<li id="user_<%= @user.id %>"><%= link_to @user.login, delete_from_group_group_path(@group, :user_id => @user.id), :title => t("group.delete_from_group"), :remote => true, :method => :delete %></li>');
<% end %>