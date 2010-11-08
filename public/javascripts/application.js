$(document).ready(function(){
    $(".close_error").click(function(){
        $("#flash_error").slideUp("slow");
        });

    $(".close_info").click(function(){
        $("#flash_notice").slideUp("slow");
        });

    // Clase con la que informamos que un enlace añadira información en un colorbox
    $(".add_to_colorbox").colorbox();
    
    // Para activar el formulario de comentarios
    $(".show_form_comment").click(function(){
        $("#form_comment_" + $(this).attr("rel")).find("textarea").removeClass("error");
        $("#form_comment_" + $(this).attr("rel")).slideDown("slow");
        });

    // Para activar el formulario de criticas
    $(".show_form_write_critic").click(function(){
        $("#form_write_your_critic_" + $(this).attr("rel")).find("textarea").removeClass("error");
        $("#form_write_your_critic_" + $(this).attr("rel")).slideDown("slow");
        });

    // Guardo los autores y editoriales que se almacenan
    $(".save_book").click(function(){
        authors = [];
        $("#book_authors LI").each(function(j){
            authors.push($(this).attr("author_id"));
            });

        $("#book_author_ids").attr("value",authors.join(","));

        publishers = [];
        $("#book_publishers LI").each(function(j){
            publishers.push($(this).attr("publisher_id"));
            });

        $("#book_publisher_ids").attr("value",publishers.join(","));
        });
    });