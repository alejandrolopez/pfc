$.colorbox({width:"60%", height:"80%", html:"<p></p>"});
$("#cboxLoadedContent").html('\
    <h2>Listado de usuarios a añadir</h2>\n\
    <div>\n\
        <ul>\n\
            <% @users.each do |user| %>\n\
                <li>\n\
                    <%= link_to user.login, add_user_to_group_group_path(@group, :user_id => user.id), :remote => true, :title => t("group.add_user_to_group"), :method => :post %>\n\
                </li>\n\
            <% end -%>\n\
        </ul>\n\
    </div>')