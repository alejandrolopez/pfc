$("#form_comment_blog_post_<%= @post.id %>").find("TEXTAREA").removeClass("error");
$("#form_comment_blog_post_<%= @post.id %>").find("TEXTAREA").attr("value", "");
$("#form_comment_blog_post_<%= @post.id %>").hide();
$("#comments_blog_post_<%= @post.id %>").append("<div><span class=\"autor\"><%= @comment.author  %></span><span class=\"comentario\"><%= @comment.comment %></span></div>");