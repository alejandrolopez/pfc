$("#form_comment_noticia_<%= @noticia.id %>").find("TEXTAREA").removeClass("error");
$("#form_comment_noticia_<%= @noticia.id %>").find("TEXTAREA").attr("value", "");
$("#form_comment_noticia_<%= @noticia.id %>").hide();
$("#comments_noticia_<%= @noticia.id %>").append("<div><span class=\"autor\"><%= @comment.author  %></span><span class=\"comentario\"><%= @comment.comment %></span></div>");