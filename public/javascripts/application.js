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

    $(".save_book").click(function(){
        authors = [];
        $("#book_authors LI").each(function(j){
            authors.push($(this).attr("author_id"));
            });

        $("#book_author_ids").attr("value",authors.join(","));
        });
    });